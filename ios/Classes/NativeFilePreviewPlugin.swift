import Flutter
import UIKit
import QuickLook

public class NativeFilePreviewPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "native_file_preview", binaryMessenger: registrar.messenger())
        let instance = NativeFilePreviewPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "previewFile":
            guard
                let args = call.arguments as? [String: Any],
                let filePath = args["file"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                return
            }
            
            // Convert file path to URL
            let fileURL: URL
            
            if filePath.hasPrefix("file://") {
                // Handle file:// URLs
                guard let url = URL(string: filePath) else {
                    result(FlutterError(code: "INVALID_FILE_URL", message: "Invalid file URL: \(filePath)", details: nil))
                    return
                }
                fileURL = url
            } else if filePath.hasPrefix("/") {
                // Handle absolute file paths
                fileURL = URL(fileURLWithPath: filePath)
            } else {
                // Try to parse as URL first, then fall back to file path
                if let url = URL(string: filePath), url.scheme != nil {
                    fileURL = url
                } else {
                    fileURL = URL(fileURLWithPath: filePath)
                }
            }
            
            // Validate file existence for local files
            if fileURL.isFileURL {
                
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: fileURL.path) {
                    result(FlutterError(code: "FILE_NOT_FOUND", message: "File does not exist: \(fileURL.path)", details: nil))
                    return
                }
                
                // Check if file is readable
                if !fileManager.isReadableFile(atPath: fileURL.path) {
                    result(FlutterError(code: "FILE_NOT_READABLE", message: "File is not readable: \(fileURL.path)", details: nil))
                    return
                }
            }
            
            let preview = NativeFileViewerPreview(file: fileURL)
            
            guard let activeViewController = UIApplication.shared.topViewController() else {
                result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "No view controller available", details: nil))
                return
            }
            
            var actuallyActiveViewController = activeViewController
            
            if activeViewController is NativeFileViewerPreviewViewController,
                let presentingViewController = activeViewController.presentingViewController {
                actuallyActiveViewController = presentingViewController
            }
            
            preview.show(viewController: actuallyActiveViewController, promise: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}






