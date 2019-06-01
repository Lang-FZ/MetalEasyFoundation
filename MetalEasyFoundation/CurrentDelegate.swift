//
//  CurrentDelegate.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class CurrentDelegate: NSObject {

    @objc class public var rootTabBar:RootTabBarController {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).rootTabBar
        }
    }
    
    class public func currentViewController() -> UIViewController {
        return rootTabBar.currentViewController()
    }
    
    class public func currentRootViewController() -> UIViewController {
        return rootTabBar.currentRootViewController()
    }
    
    class public func currentNavigationController() -> BaseNavigationController {
        return rootTabBar.currentNavigationController()
    }
}
