//
//  MetalController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class MetalController: BaseViewController, HadTabBarProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizationTool.getStr("metal.root.title")
        self.navigationController?.tabBarItem.title = ""
    }
}

extension MetalController {
    
    public func changedLanguage() {
        
    }
}
