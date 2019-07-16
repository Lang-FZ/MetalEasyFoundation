//
//  BaseViewController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

@objc public protocol NoneInteractivePopGestureProtocol {}
@objc public protocol NoneNavigationBarProtocol {}
@objc public protocol HadTabBarProtocol {}

open class BaseViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func judgeTabBar() {
//        if self.conforms(to: HadTabBarProtocol.self) {
//            self.hidesBottomBarWhenPushed = false
//        } else {
//            self.hidesBottomBarWhenPushed = true
//        }
//    }
}

open class NoneBarController: BaseViewController, NoneNavigationBarProtocol {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

open class NoneBackController: UIViewController, NoneInteractivePopGestureProtocol {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}
