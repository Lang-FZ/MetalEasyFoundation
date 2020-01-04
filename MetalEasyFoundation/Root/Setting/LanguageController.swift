//
//  LanguageController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/3.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class LanguageController: BaseViewController {

    lazy private var model: BaseListModel = {
        
        let model = BaseListModel.init([:])
        
        let model1 = BaseListModel.init([:])
        model1.title = "setting.language.chinese"
        model1.action = { [weak self] (title) in
            self?.saveLanguage("zh-Hans")
        }
        let model2 = BaseListModel.init([:])
        model2.title = "setting.language.english"
        model2.action = { [weak self] (title) in
            self?.saveLanguage("en")
        }
        
        model.data.append(model1)
        model.data.append(model2)
        
        return model
    }()
    
    lazy private var language_table: ASTableNode = {
        
        let language_table = ASTableNode.init(style: .plain)
        language_table.frame = CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH)
        language_table.delegate = self
        language_table.dataSource = self
        language_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        language_table.view.separatorStyle = .none
        language_table.view.scrollIndicatorInsets = UIEdgeInsets.zero
        
        return language_table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubnode(language_table)
        language_table.reloadData()
    }
    deinit {
        print("Language-deinit")
    }
}

extension LanguageController: ASTableDelegate, ASTableDataSource {

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

extension LanguageController {
    
    private func saveLanguage(_ language:String) {
        
        if language != LocalizationTool.getCurrentLanguage() {
            let _ = LocalizationTool.saveCurrentLanguage(language)
        }
        navigationController?.popViewController(animated: true)
    }
}
