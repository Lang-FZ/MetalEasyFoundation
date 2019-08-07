//
//  LanguageController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/3.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

private let LanguageListIdentifier = "LanguageListIdentifier"

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
    
    lazy private var language_table: UITableView = {
        
        let language_table = UITableView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH), style: .plain)
        language_table.delegate = self
        language_table.dataSource = self
        language_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        language_table.separatorStyle = .none
        language_table.estimatedRowHeight = 44.0
        language_table.rowHeight = UITableView.automaticDimension
        language_table.scrollIndicatorInsets = UIEdgeInsets.zero
        
        language_table.register(BaseListCell.self, forCellReuseIdentifier: LanguageListIdentifier)
        
        return language_table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(language_table)
    }
}

extension LanguageController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageListIdentifier) as! BaseListCell
        cell.model = model.data[indexPath.row]
        cell.isLast = (indexPath.row == (model.data.count-1))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
