import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_file_preview_platform_interface.dart';

/// An implementation of [NativeFilePreviewPlatform] that uses method channels.
class MethodChannelNativeFilePreview extends NativeFilePreviewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_file_preview');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> previewFile(String filePath) async {
    await methodChannel.invokeMethod<void>('previewFile', {'file': filePath});
  }
}
