# react-native-ssh-classic

[![npm version](https://badge.fury.io/js/react-native-ssh-classic.svg)](https://badge.fury.io/js/react-native-ssh-classic)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A modern, actively maintained library that enables React Native apps to execute commands over SSH. This is a fork of the unmaintained `react-native-ssh` package, updated for React Native 0.71+ and modern build systems.

## Features

- ✅ Execute remote commands via SSH
- ✅ Password authentication
- ✅ Private key authentication (with optional passphrase)
- ✅ Custom port support
- ✅ Configurable connection timeout (Android)
- ✅ TypeScript definitions included
- ✅ React Native 0.71+ support
- ✅ New Architecture ready
- ✅ EAS Build compatible

## Installation

```bash
npm install react-native-ssh-classic
# or
yarn add react-native-ssh-classic
```

### iOS Setup

For iOS, you need to install the CocoaPods dependency:

```bash
cd ios
pod install
```

The package will automatically link the required NMSSH pod.

### Android Setup

No additional setup required for Android. The package uses JSch for SSH functionality.

## Usage

### Basic Example (Password Authentication)

```javascript
import SSH from 'react-native-ssh-classic';

const config = {
  host: 'example.com',
  user: 'bob',
  password: 'p4$$w0rd',
};

const command = 'ls ~';

SSH.execute(config, command)
  .then(result => {
    console.log('Output:', result);
    // Output: ['file1.txt', 'server.py', 'script.sh']
  })
  .catch(error => {
    console.error('Error:', error);
  });
```

### Advanced Example (Private Key Authentication)

```javascript
import SSH from 'react-native-ssh-classic';

const config = {
  host: 'example.com',
  user: 'bob',
  port: 2222, // Custom port (default: 22)
  privateKey: `-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
-----END RSA PRIVATE KEY-----`,
  passphrase: 'optional-key-passphrase', // Optional
  timeout: 60000, // 60 seconds (Android only, default: 30000)
};

const command = 'uptime';

SSH.execute(config, command)
  .then(result => console.log('Uptime:', result[0]))
  .catch(error => console.error('Failed:', error));
```

### TypeScript

The package includes TypeScript definitions:

```typescript
import SSH, { SSHConfig } from 'react-native-ssh-classic';

const config: SSHConfig = {
  host: 'example.com',
  user: 'admin',
  password: 'secret',
};

async function executeCommand() {
  try {
    const output = await SSH.execute(config, 'whoami');
    console.log('User:', output[0]);
  } catch (error) {
    console.error('SSH Error:', error);
  }
}
```

## API Reference

### `SSH.execute(config, command)`

Executes a command over SSH and returns the output.

**Parameters:**

- `config` (SSHConfig): Connection configuration object
  - `host` (string, required): Hostname or IP address
  - `user` (string, required): Username for authentication
  - `port` (number, optional): Port number (default: 22)
  - `password` (string, optional): Password for authentication
  - `privateKey` (string, optional): Private key in PEM format
  - `passphrase` (string, optional): Passphrase for the private key
  - `timeout` (number, optional): Connection timeout in ms (Android only, default: 30000)
- `command` (string, required): The command to execute

**Returns:**

- `Promise<string[]>`: Resolves to an array of output lines

**Errors:**

- `INVALID_CONFIG`: Missing required configuration (host/user)
- `CONNECTION_FAILED`: Could not connect to the SSH server
- `AUTH_FAILED`: Authentication failed
- `EXECUTION_FAILED`: Command execution failed
- `SSH_ERROR`: General SSH error (Android)
- `EXCEPTION`: Unexpected error (iOS)

## Troubleshooting

### EAS Build Issues

If you encounter duplicate file errors during EAS builds, the packaging configuration in `android/build.gradle` handles META-INF conflicts automatically.

### iOS Build Issues

Make sure you've run `pod install` in the `ios` directory. If you're using an older React Native version, you may need to run `react-native link`.

### Authentication Issues

- Ensure your credentials are correct
- For private key auth, make sure the key is in PEM format
- Check that the SSH server allows the authentication method you're using

## Differences from Original react-native-ssh

- Updated dependencies (JSch 0.2.20, NMSSH 2.3.1)
- React Native 0.71+ peer dependency
- Added TypeScript definitions
- Added private key authentication support
- Added custom port and timeout configuration
- Better error handling and resource cleanup
- Modern Android Gradle configuration
- Proper CocoaPods integration
- EAS Build compatibility

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT

## Credits

This is a maintained fork of [react-native-ssh](https://github.com/shaqke/react-native-ssh) by shaqke, which is no longer maintained.
