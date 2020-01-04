//
//  SettingController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class SettingController: BaseViewController, HadTabBarProtocol {

    lazy private var model: BaseListModel = {
        
        let model = BaseListModel.init([:])
        
        let model1 = BaseListModel.init([:])
        model1.title = "setting.language.list.title"
        model1.action = { [weak self] (title) in
            self?.pushToLanguageVC(LocalizationTool.getStr(model1.title))
        }
        
        model.data.append(model1)
        
        return model
    }()
    
    lazy private var setting_table: ASTableNode = {
        
        let setting_table = ASTableNode.init(style: .plain)
        setting_table.frame = CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH-kTabBarH)
        setting_table.delegate = self
        setting_table.dataSource = self
        setting_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        setting_table.view.separatorStyle = .none
        setting_table.view.scrollIndicatorInsets = UIEdgeInsets.zero
        
        return setting_table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizationTool.getStr("setting.root.title")
        navigationController?.tabBarItem.title = ""
        
        view.addSubnode(setting_table)
        setting_table.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedLanguage), name: Language_Changed_Notification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Setting-deinit")
    }
}

extension SettingController {
    
    @objc public func changedLanguage() {
        setting_table.reloadData()
        title = LocalizationTool.getStr("setting.root.title")
        navigationController?.tabBarItem.title = ""
    }
}

extension SettingController: ASTableDelegate, ASTableDataSource {
   
   func numberOfSections(in tableNode: ASTableNode) -> Int {
       return 1
   }
   func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
       return model.data.count
   }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = { [weak self] in
            let node = BaseListNode()
            node.model = self?.model.data[indexPath.row] ?? BaseListModel.init([:])
            node.isLast = (indexPath.row == ((self?.model.data.count ?? 0)-1))
            return node
        }
        return block
    }
   func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
       tableNode.deselectRow(at: indexPath, animated: true)
       model.data[indexPath.row].action?("")
   }
}

extension SettingController {
    
    public func pushToLanguageVC(_ title:String) {
        
        let languageVC = LanguageController()
        languageVC.title = title
        self.navigationController?.pushViewController(languageVC, animated: true)
    }
}
