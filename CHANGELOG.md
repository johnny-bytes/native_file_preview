# [1.1.0](https://github.com/johnny-bytes/native_file_preview/compare/v1.0.1...v1.1.0) (2026-04-27)


### Features

* add swift package manager support ([ca7d168](https://github.com/johnny-bytes/native_file_preview/commit/ca7d168594c4cd755f5c4e93580bf585b6bd12bd))

## 1.0.1

* Fixed deprecated code in example app.
* Updated Flutter and Dart SDK constraints in `pubspec.yaml` for broader compatibility.

## 1.0.0

* Initial release of native_file_preview plugin
* Added support for native file preview on iOS and Android platforms
* Implemented `previewFile(String filePath)` method to open files using platform-native preview capabilities
* iOS implementation uses QuickLook framework for seamless file viewing
* Android implementation provides native file preview functionality
* Support for multiple file path formats:
  - Local file paths (absolute paths)
  - File URLs (`file://` scheme)
  - Remote URLs (where supported by platform)
* Comprehensive error handling:
  - File not found validation
  - File readability checks
  - Invalid file URL detection
* Cross-platform API with consistent behavior across iOS and Android
