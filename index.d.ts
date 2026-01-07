declare module 'react-native-ssh-classic' {
  export interface SSHConfig {
    /**
     * The hostname or IP address of the SSH server
     */
    host: string;
    
    /**
     * The username for authentication
     */
    user: string;
    
    /**
     * The port number (default: 22)
     */
    port?: number;
    
    /**
     * Password for authentication
     */
    password?: string;
    
    /**
     * Private key for authentication (PEM format)
     */
    privateKey?: string;
    
    /**
     * Passphrase for the private key
     */
    passphrase?: string;
    
    /**
     * Connection timeout in milliseconds (default: 30000)
     * Android only
     */
    timeout?: number;
  }

  export interface SSH {
    /**
     * Execute a command over SSH
     * @param config - SSH connection configuration
     * @param command - The command to execute
     * @returns A promise that resolves to an array of strings (output lines)
     */
    execute(config: SSHConfig, command: string): Promise<string[]>;
  }

  const SSH: SSH;
  export default SSH;
}
