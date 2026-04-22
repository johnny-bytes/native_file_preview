//
//  NativeFileViewerPreview.swift
//  Pods
//
//  Created by Thorsten Kehren on 18.07.25.
//


import Flutter
import UIKit
import QuickLook

class NativeFileViewerPreview: QLPreviewControllerDataSource {
    
    private let file: URL
    
    init(file: URL) {
        self.file = file
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return file as QLPreviewItem
    }
    
    func show(viewController: UIViewController, promise: @escaping FlutterResult) {
        let previewViewController = NativeFileViewerPreviewViewController()
        previewViewController.dataSource = self
        previewViewController.presentModal(viewController: viewController, promise: promise)
    }
}