package com.johnnybytes.native_file_preview

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.Mockito

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

internal class NativeFilePreviewPluginTest {
  @Test
  fun onMethodCall_unknownMethod_isNotImplemented() {
    val plugin = NativeFilePreviewPlugin()

    val call = MethodCall("someUnknownMethod", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).notImplemented()
  }

  @Test
  fun onMethodCall_previewFileWithoutArguments_returnsInvalidFilePath() {
    val plugin = NativeFilePreviewPlugin()

    val call = MethodCall("previewFile", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).error("INVALID_FILE_PATH", "Invalid file path", null)
  }

  @Test
  fun onMethodCall_previewFileWithoutActivity_returnsNoActivity() {
    val plugin = NativeFilePreviewPlugin()

    val call = MethodCall("previewFile", mapOf("file" to "/some/file.pdf"))
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).error("NO_ACTIVITY", "No activity available", null)
  }
}
