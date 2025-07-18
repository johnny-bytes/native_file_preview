//
//  NativeFileViewerPreviewViewController.swift
//  Pods
//
//  Created by Thorsten Kehren on 18.07.25.
//


import Flutter
import UIKit
import QuickLook

class NativeFileViewerPreviewViewController: QLPreviewController {
    
    var promise: FlutterResult?
    
    func presentModal(viewController: UIViewController, promise: @escaping FlutterResult) {
        self.promise = promise
        viewController.present(self, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        promise?(nil)
        super.viewWillDisappear(animated)
    }
}