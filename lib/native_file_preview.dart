import 'native_file_preview_platform_interface.dart';

class NativeFilePreview {
  Future<String?> getPlatformVersion() {
    return NativeFilePreviewPlatform.instance.getPlatformVersion();
  }

  Future<void> previewFile(String filePath) {
    return NativeFilePreviewPlatform.instance.previewFile(filePath);
  }
}
