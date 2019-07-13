//
//  SettingController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

private let SettingListIdentifier = "SettingListIdentifier"

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
    
    lazy private var setting_table: UITableView = {
        
        let setting_table = UITableView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH-kTabBarH), style: .plain)
        setting_table.delegate = self
        setting_table.dataSource = self
        setting_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        setting_table.separatorStyle = .none
        setting_table.estimatedRowHeight = 44.0
        setting_table.rowHeight = UITableView.automaticDimension
        setting_table.scrollIndicatorInsets = UIEdgeInsets.zero
        
        setting_table.register(BaseListCell.self, forCellReuseIdentifier: SettingListIdentifier)
        
        return setting_table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizationTool.getStr("setting.root.title")
        navigationController?.tabBarItem.title = ""
        
        view.addSubview(setting_table)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedLanguage), name: Language_Changed_Notification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension SettingController {
    
    @objc public func changedLanguage() {
        setting_table.reloadData()
        title = LocalizationTool.getStr("setting.root.title")
        navigationController?.tabBarItem.title = ""
    }
}

extension SettingController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingListIdentifier) as! BaseListCell
        cell.model = model.data[indexPath.row]
        cell.isLast = (indexPath.row == (model.data.count-1))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
