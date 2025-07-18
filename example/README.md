# Native File Preview Example

This example demonstrates how to use the native_file_preview plugin to preview files using native viewers on iOS and Android.

## Features

- **Cross-platform file preview**: Uses QuickLook on iOS and Intent system on Android
- **Multiple file formats**: Supports text, HTML, CSV, JSON, PDF, images, documents, and more
- **Native experience**: Files open in the device's default apps for optimal viewing
- **Error handling**: Graceful handling of unsupported file types and errors

## What this demo shows

The example app creates several sample files and demonstrates:

1. **Text files (.txt)** - Simple text documents
2. **HTML files (.html)** - Web content with styling
3. **CSV files (.csv)** - Comma-separated data
4. **JSON files (.json)** - Structured data

## How it works

### iOS
- Uses the QuickLook framework (`QLPreviewController`)
- Provides a native preview experience within the app
- Supports a wide variety of file formats out of the box

### Android
- Uses the Intent system with `ACTION_VIEW`
- Opens files with the user's preferred apps
- Uses FileProvider for secure file sharing on Android 7.0+

## Usage

1. Run the app
2. Wait for sample files to be created
3. Tap on any file in the list to preview it
4. The file will open using your device's native viewer

## Implementation Details

### Flutter/Dart side
```dart
final nativeFilePreview = NativeFilePreview();
await nativeFilePreview.previewFile('/path/to/file.txt');
```

### iOS Implementation
- Integrates with QuickLook framework
- Presents files in a modal preview controller
- Handles various file types natively

### Android Implementation
- Uses Intent with ACTION_VIEW
- Leverages FileProvider for security
- Falls back gracefully when no app can handle the file type

## Requirements

- Flutter SDK 3.8.1 or later
- iOS 11.0+ / Android API level 16+
- Appropriate file viewer apps installed on the device

## Getting Started

1. Clone the repository
2. Navigate to the example directory
3. Run `flutter pub get`
4. Run `flutter run`

The app will automatically create sample files and display them in a list for preview testing.
