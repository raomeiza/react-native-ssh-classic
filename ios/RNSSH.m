#import "RNSSH.h"
#import <React/RCTLog.h>
#import <NMSSH/NMSSH.h>

@implementation SSH

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_queue_create("com.reactnative.ssh", DISPATCH_QUEUE_SERIAL);
}

RCT_EXPORT_METHOD(execute:(NSDictionary *)config 
                  command:(NSString *)command 
                  resolver:(RCTPromiseResolveBlock)resolve 
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    @try {
        // Extract configuration with defaults
        NSString *host = config[@"host"];
        NSString *user = config[@"user"];
        NSNumber *portNum = config[@"port"];
        NSInteger port = portNum ? [portNum integerValue] : 22;
        
        if (!host || !user) {
            NSError *configError = [NSError errorWithDomain:@"RNSSH" 
                                                      code:400 
                                                  userInfo:@{NSLocalizedDescriptionKey: @"Host and user are required"}];
            return reject(@"INVALID_CONFIG", @"Host and user are required", configError);
        }
        
        // Create the SSH session
        NMSSHSession *session = [NMSSHSession connectToHost:host 
                                                    port:port 
                                                withUsername:user];
        
        if (!session.isConnected) {
            NSError *connectError = [NSError errorWithDomain:@"RNSSH" 
                                                       code:404 
                                                   userInfo:@{NSLocalizedDescriptionKey: @"Could not connect to host"}];
            return reject(@"CONNECTION_FAILED", @"Could not connect to host", connectError);
        }
        
        // Authenticate
        BOOL authenticated = NO;
        
        if (config[@"password"]) {
            authenticated = [session authenticateByPassword:config[@"password"]];
        } else if (config[@"privateKey"]) {
            NSString *privateKey = config[@"privateKey"];
            NSString *passphrase = config[@"passphrase"];
            
            if (passphrase) {
                authenticated = [session authenticateByInMemoryPublicKey:nil 
                                                              privateKey:privateKey 
                                                             andPassword:passphrase];
            } else {
                authenticated = [session authenticateByInMemoryPublicKey:nil 
                                                              privateKey:privateKey 
                                                             andPassword:@""];
            }
        }
        
        if (!authenticated) {
            [session disconnect];
            NSError *authError = [NSError errorWithDomain:@"RNSSH" 
                                                     code:401 
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Authentication failed"}];
            return reject(@"AUTH_FAILED", @"Authentication failed", authError);
        }
        
        // Execute the command
        NSError *error = nil;
        NSString *response = [session.channel execute:command error:&error];
        [session disconnect];
        
        if (error) {
            return reject(@"EXECUTION_FAILED", @"Command execution failed", error);
        }
        
        // Trim starting and ending newlines, then split by them
        response = [response stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSArray *result = [response componentsSeparatedByString:@"\n"];
        
        // Return the command output as an array of strings
        resolve(result);
    }
    @catch (NSException *exception) {
        NSError *error = [NSError errorWithDomain:@"RNSSH" 
                                             code:500 
                                         userInfo:@{NSLocalizedDescriptionKey: exception.reason ?: @"Unknown error"}];
        reject(@"EXCEPTION", exception.reason ?: @"Unknown error occurred", error);
    }
}

@end
