# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-07

### Added
- TypeScript definitions (index.d.ts)
- Private key authentication support (both Android and iOS)
- Custom port configuration
- Connection timeout configuration (Android)
- Proper resource cleanup in Android implementation
- Better error handling with specific error codes
- CocoaPods integration via podspec file
- Comprehensive README with examples
- MIT License
- .npmignore for cleaner npm packages

### Changed
- Updated JSch dependency from 0.2.17 to 0.2.20
- Updated NMSSH dependency from 2.2.5 to 2.3.1
- Modernized Android Gradle configuration
- Added namespace to Android build.gradle for AGP 7.0+
- Improved Android build.gradle with safe extension getters
- Updated to Java 11 source/target compatibility
- Added @NonNull annotations to Android code
- Modernized iOS imports to use React/ prefix
- Enhanced iOS error handling
- Updated peer dependencies to React Native 0.71+
- Bumped version to 1.1.0

### Fixed
- EAS Build duplicate META-INF file error
- Memory leaks from unclosed SSH sessions (Android)
- iOS build warnings with modern React Native versions
- Missing repository and license information in package.json

## [1.0.1] - Previous

### Changed
- Updated peer dependency to React Native >= 0.71.0

## [1.0.0] - Original

- Initial fork from react-native-ssh
