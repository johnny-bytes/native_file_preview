package com.johnnybytes.native_file_preview

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/** NativeFilePreviewPlugin */
class NativeFilePreviewPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var binding: ActivityPluginBinding? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "native_file_preview")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "previewFile" -> {
        val arguments = call.arguments as? Map<String, Any>
        val filePath = arguments?.get("file") as? String

        if (filePath == null) {
          result.error("INVALID_FILE_PATH", "Invalid file path", null)
          return
        }

        try {
          previewFile(filePath, result)
        } catch (e: Exception) {
          result.error("PREVIEW_ERROR", "Failed to preview file: ${e.message}", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun previewFile(filePath: String, result: Result) {
    val activity = binding?.activity
    if (activity == null) {
      result.error("NO_ACTIVITY", "No activity available", null)
      return
    }

    try {
      var uri: Uri
      val mimeType: String?

      when {
        filePath.startsWith("content://") -> {
          // Handle content URI
          uri = Uri.parse(filePath)
          
          // Validate that the content URI is accessible
          if (!isContentUriAccessible(uri)) {
            result.error("CONTENT_URI_INACCESSIBLE", "Content URI is not accessible: $filePath", null)
            return
          }
          
          // Get MIME type from ContentResolver
          mimeType = activity.contentResolver.getType(uri)
        }
        filePath.startsWith("file://") -> {
          // Handle file URI
          uri = Uri.parse(filePath)
          val file = File(uri.path ?: "")
          
          if (!file.exists()) {
            result.error("FILE_NOT_FOUND", "File does not exist: $filePath", null)
            return
          }
          
          // Use FileProvider for security on Android 7.0+
          val fileProviderUri = FileProvider.getUriForFile(
            activity,
            "${activity.packageName}.fileprovider",
            file
          )
          uri = fileProviderUri
          mimeType = getMimeTypeFromFile(file)
        }
        else -> {
          // Handle regular file path
          val file = File(filePath)
          
          if (!file.exists()) {
            result.error("FILE_NOT_FOUND", "File does not exist: $filePath", null)
            return
          }
          
          // Use FileProvider for security on Android 7.0+
          uri = FileProvider.getUriForFile(
            activity,
            "${activity.packageName}.fileprovider",
            file
          )
          mimeType = getMimeTypeFromFile(file)
        }
      }

      val intent = Intent(Intent.ACTION_VIEW).apply {
        setDataAndType(uri, mimeType ?: "*/*")
        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      }

      activity.startActivity(intent)

      // Check if there's an app that can handle this intent
      result.success(null)
    } catch(e: ActivityNotFoundException) {
      result.error("NO_APP_FOUND", "No app found to preview this file type", e)
    }
    catch (e: Exception) {
      result.error("INTENT_ERROR", "Failed to create preview intent: ${e.message}", e)
    }
  }

  private fun isContentUriAccessible(uri: Uri): Boolean {
    val activity = binding?.activity ?: return false
    
    return try {
      // Try to query the content URI to see if it's accessible
      activity.contentResolver.query(uri, null, null, null, null)?.use { cursor ->
        cursor.count >= 0 // If we can query it, it's accessible
      } ?: false
    } catch (e: Exception) {
      false
    }
  }

  private fun getMimeTypeFromFile(file: File): String? {
    val extension = file.extension.lowercase()
    
    // First try MimeTypeMap for more comprehensive mapping
    val mimeTypeFromMap = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
    if (mimeTypeFromMap != null) {
      return mimeTypeFromMap
    }
    
    // Fallback to custom mappings for common types
    return when (extension) {
      "pdf" -> "application/pdf"
      "doc" -> "application/msword"
      "docx" -> "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "xls" -> "application/vnd.ms-excel"
      "xlsx" -> "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "ppt" -> "application/vnd.ms-powerpoint"
      "pptx" -> "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "txt" -> "text/plain"
      "jpg", "jpeg" -> "image/jpeg"
      "png" -> "image/png"
      "gif" -> "image/gif"
      "mp4" -> "video/mp4"
      "mp3" -> "audio/mpeg"
      "zip" -> "application/zip"
      else -> "*/*"
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.binding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.binding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.binding = binding
  }

  override fun onDetachedFromActivity() {
    this.binding = null
  }
}
