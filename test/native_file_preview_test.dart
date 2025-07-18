import 'package:flutter_test/flutter_test.dart';
import 'package:native_file_preview/native_file_preview.dart';
import 'package:native_file_preview/native_file_preview_platform_interface.dart';
import 'package:native_file_preview/native_file_preview_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeFilePreviewPlatform
    with MockPlatformInterfaceMixin
    implements NativeFilePreviewPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> previewFile(String filePath) {
    return Future.value();
  }
}

void main() {
  final NativeFilePreviewPlatform initialPlatform =
      NativeFilePreviewPlatform.instance;

  test('$MethodChannelNativeFilePreview is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeFilePreview>());
  });

  test('getPlatformVersion', () async {
    NativeFilePreview nativeFilePreviewPlugin = NativeFilePreview();
    MockNativeFilePreviewPlatform fakePlatform =
        MockNativeFilePreviewPlatform();
    NativeFilePreviewPlatform.instance = fakePlatform;

    expect(await nativeFilePreviewPlugin.getPlatformVersion(), '42');
  });
}
