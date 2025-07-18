//
//  UIApplication+UIViewController.swift
//  Pods
//
//  Created by Thorsten Kehren on 18.07.25.
//


import Flutter
import UIKit
import QuickLook

extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
       
        return topViewController
    }
}