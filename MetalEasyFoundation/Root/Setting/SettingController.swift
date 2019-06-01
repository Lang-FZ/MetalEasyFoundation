//
//  SettingController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class SettingController: BaseViewController, HadTabBarProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizationTool.getStr("setting.root.title")
        self.navigationController?.tabBarItem.title = ""
    }
}

extension SettingController {
    
    public func changedLanguage() {
        
    }
}
