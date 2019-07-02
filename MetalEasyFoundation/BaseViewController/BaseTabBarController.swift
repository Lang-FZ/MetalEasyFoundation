//
//  BaseTabBarController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.addObserver(self, forKeyPath: "frame", options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let tabBar = object as? UITabBar,
            keyPath == "frame" {
            
            if let oldFrame = change?[.oldKey] as? CGRect,
                let newFrame = change?[.newKey] as? CGRect {
                
                if oldFrame.size != newFrame.size {
                    
                    if oldFrame.height > newFrame.height {
                        tabBar.frame = oldFrame
                    } else {
                        tabBar.frame = newFrame
                    }
                }
            }
        }
    }
    
    deinit {
        tabBar.removeObserver(self, forKeyPath: "frame")
    }
}
