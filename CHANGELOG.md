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
