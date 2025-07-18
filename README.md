# native_file_preview

[![pub package](https://img.shields.io/pub/v/native_file_preview.svg)](https://pub.dev/packages/native_file_preview)

A Flutter plugin that enables native file preview functionality across iOS and Android platforms. Preview files using the operating system's built-in viewers with a simple, cross-platform API.

## Features

✨ **Cross-platform compatibility** - Works seamlessly on iOS and Android  
📱 **Native UI integration** - Uses QuickLook on iOS and Intent system on Android  
📄 **Multiple file format support** - Preview PDFs, images, documents, and more  
🔗 **Flexible file path handling** - Supports local paths, file:// URLs, and content:// URIs  
⚡ **Simple API** - One method call to preview any supported file  
🛡️ **Comprehensive error handling** - Detailed error messages for troubleshooting  
🔒 **Secure file access** - Uses FileProvider on Android for secure file sharing  

## Supported File Types

The plugin supports a wide variety of file formats through native system viewers:

| Category | Formats |
|----------|---------|
| **Documents** | PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX, TXT |
| **Images** | JPG, JPEG, PNG, GIF, BMP, TIFF |
| **Audio** | MP3, AAC, WAV, M4A |
| **Video** | MP4, MOV, AVI, MKV |
| **Archives** | ZIP, RAR, 7Z |
| **Web** | HTML, CSS, JSON, XML |

*Note: Actual support depends on apps installed on the user's device.*

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  native_file_preview: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Platform Setup

### iOS Setup

No additional setup required. The plugin uses the QuickLook framework which is available by default.

### Android Setup

Add a FileProvider configuration to your `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <!-- Your existing configuration -->
    
    <provider
        android:name="androidx.core.content.FileProvider"
        android:authorities="${applicationId}.fileprovider"
        android:exported="false"
        android:grantUriPermissions="true">
        <meta-data
            android:name="android.support.FILE_PROVIDER_PATHS"
            android:resource="@xml/file_paths" />
    </provider>
</application>
```

Create `android/app/src/main/res/xml/file_paths.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-path name="external_files" path="."/>
    <files-path name="files" path="."/>
    <cache-path name="cache" path="."/>
    <external-cache-path name="external_cache" path="."/>
</paths>
```

## Usage

### Basic Example

```dart
import 'package:native_file_preview/native_file_preview.dart';

class FilePreviewExample extends StatelessWidget {
  final _nativeFilePreview = NativeFilePreview();

  Future<void> _previewFile(String filePath) async {
    try {
      await _nativeFilePreview.previewFile(filePath);
    } on PlatformException catch (e) {
      print('Error previewing file: ${e.message}');
      // Handle error (show dialog, snackbar, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Preview Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _previewFile('/path/to/your/file.pdf'),
          child: Text('Preview File'),
        ),
      ),
    );
  }
}
```

### Advanced Example with File Selection

```dart
import 'package:native_file_preview/native_file_preview.dart';
import 'package:file_picker/file_picker.dart';

class AdvancedFilePreview extends StatefulWidget {
  @override
  _AdvancedFilePreviewState createState() => _AdvancedFilePreviewState();
}

class _AdvancedFilePreviewState extends State<AdvancedFilePreview> {
  final _nativeFilePreview = NativeFilePreview();

  Future<void> _pickAndPreviewFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      
      if (result != null) {
        String filePath = result.files.single.path!;
        await _nativeFilePreview.previewFile(filePath);
      }
    } on PlatformException catch (e) {
      _showErrorDialog('Preview Error', e.message ?? 'Unknown error');
    } catch (e) {
      _showErrorDialog('Unexpected Error', e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced File Preview')),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickAndPreviewFile,
          child: Text('Pick and Preview File'),
        ),
      ),
    );
  }
}
```

## File Path Formats

The plugin supports multiple file path formats:

### Local File Paths
```dart
// Absolute path
await nativeFilePreview.previewFile('/storage/emulated/0/Download/document.pdf');

// Using path_provider
final directory = await getApplicationDocumentsDirectory();
await nativeFilePreview.previewFile('${directory.path}/my_file.txt');
```

### File URLs
```dart
// File URL format
await nativeFilePreview.previewFile('file:///storage/emulated/0/Download/image.jpg');
```

### Content URIs (Android)
```dart
// Content URI from Android content providers
await nativeFilePreview.previewFile('content://com.android.providers.downloads.documents/document/123');
```

## Error Handling

The plugin provides detailed error codes for different scenarios:

| Error Code | Description | Platform |
|------------|-------------|----------|
| `INVALID_ARGUMENTS` | Invalid method arguments | Both |
| `FILE_NOT_FOUND` | File doesn't exist at specified path | Both |
| `FILE_NOT_READABLE` | File exists but isn't readable | iOS |
| `NO_VIEW_CONTROLLER` | No view controller available | iOS |
| `NO_ACTIVITY` | No activity available | Android |
| `NO_APP_FOUND` | No app can handle the file type | Android |
| `CONTENT_URI_INACCESSIBLE` | Content URI cannot be accessed | Android |

### Handling Errors

```dart
try {
  await nativeFilePreview.previewFile(filePath);
} on PlatformException catch (e) {
  switch (e.code) {
    case 'FILE_NOT_FOUND':
      // Handle file not found
      break;
    case 'NO_APP_FOUND':
      // Handle no suitable app available
      break;
    default:
      // Handle other errors
      break;
  }
}
```

## Platform-Specific Behavior

### iOS
- Uses **QuickLook framework** for native file preview
- Provides consistent UI across all file types
- Supports 3D Touch/Haptic Touch for peek and pop
- Automatic dark mode support

### Android
- Uses **Intent system** with `ACTION_VIEW`
- Depends on apps installed on the device
- Uses FileProvider for secure file access on Android 7.0+
- Respects system theme and user preferences

## API Reference

### Methods

#### `previewFile(String filePath)`

Opens the specified file using the platform's native preview functionality.

**Parameters:**
- `filePath` (String): Path to the file to preview. Supports local paths, file:// URLs, and content:// URIs.

**Returns:** `Future<void>`

**Throws:** `PlatformException` with specific error codes for different failure scenarios.

## Example App

The plugin includes a comprehensive example app demonstrating various usage scenarios. To run the example:

```bash
cd example
flutter run
```

The example app includes:
- Sample files of different types
- Error handling demonstrations
- Platform-specific behavior examples

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this plugin helpful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 📖 Improving documentation

For support, please open an issue on GitHub.

---

Made with ❤️ by Johnny Bytes for the Flutter community

