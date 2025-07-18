import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_file_preview_method_channel.dart';

abstract class NativeFilePreviewPlatform extends PlatformInterface {
  /// Constructs a NativeFilePreviewPlatform.
  NativeFilePreviewPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeFilePreviewPlatform _instance = MethodChannelNativeFilePreview();

  /// The default instance of [NativeFilePreviewPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeFilePreview].
  static NativeFilePreviewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeFilePreviewPlatform] when
  /// they register themselves.
  static set instance(NativeFilePreviewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> previewFile(String filePath) {
    throw UnimplementedError('previewFile() has not been implemented.');
  }
}
