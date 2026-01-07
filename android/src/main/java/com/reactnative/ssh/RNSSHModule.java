package com.reactnative.ssh;

import androidx.annotation.NonNull;

import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Properties;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;


public class RNSSHModule extends ReactContextBaseJavaModule {

  public RNSSHModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @NonNull
  @Override
  public String getName() {
    return "SSH";
  }

  @ReactMethod
  public void execute(final ReadableMap config, final String command, final Promise promise) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        Session session = null;
        ChannelExec channelExec = null;
        try {
          // Get an SSH session ready
          session = RNSSHModule.connect(config);

          // Execute the command and prepare to read the output
          channelExec = (ChannelExec) session.openChannel("exec");
          InputStream in = channelExec.getInputStream();
          channelExec.setCommand(command);
          channelExec.connect();

          // Put the result into a JS-readable array
          String line;
          BufferedReader reader = new BufferedReader(new InputStreamReader(in));
          WritableNativeArray filenames = new WritableNativeArray();
          while ((line = reader.readLine()) != null) {
            filenames.pushString(line);
          }

          // Pass the array of filenames back to JS
          promise.resolve(filenames);
        } catch (Exception e) {
          promise.reject("SSH_ERROR", e.getMessage(), e);
        } finally {
          // Cleanup resources
          if (channelExec != null && channelExec.isConnected()) {
            channelExec.disconnect();
          }
          if (session != null && session.isConnected()) {
            session.disconnect();
          }
        }
      }
    }).start();
  }

  private static Session connect(ReadableMap config) throws JSchException {
    // Prepare the SSH session with the provided credentials
    JSch jsch = new JSch();
    String host = config.getString("host");
    String user = config.getString("user");
    int port = config.hasKey("port") ? config.getInt("port") : 22;
    
    Session session = jsch.getSession(user, host, port);
    
    // Set password if provided
    if (config.hasKey("password")) {
      session.setPassword(config.getString("password"));
    }
    
    // Support for private key authentication
    if (config.hasKey("privateKey")) {
      String privateKey = config.getString("privateKey");
      if (config.hasKey("passphrase")) {
        jsch.addIdentity("key", privateKey.getBytes(), null, config.getString("passphrase").getBytes());
      } else {
        jsch.addIdentity("key", privateKey.getBytes(), null, null);
      }
    }

    // Ignore the checking of the key (configurable in future)
    Properties prop = new Properties();
    prop.put("StrictHostKeyChecking", "no");
    session.setConfig(prop);
    
    // Set connection timeout if provided
    int timeout = config.hasKey("timeout") ? config.getInt("timeout") : 30000;
    session.setTimeout(timeout);
    
    // Connect to the server
    session.connect();
    
    return session;
  }
}
