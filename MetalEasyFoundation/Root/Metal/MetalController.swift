//
//  MetalController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

private let MetalListIdentifier = "MetalListIdentifier"

class MetalController: BaseViewController, HadTabBarProtocol {

    lazy private var model: BaseListModel = {
        
        let model = BaseListModel.init([:])
        
        let model1 = BaseListModel.init([:])
        model1.title = "metal.list.title.normal"
        model1.action = { [weak self] in
            self?.pushNormal()
        }
        model.data.append(model1)
        
        let model2 = BaseListModel.init([:])
        model2.title = "metal.list.title.lut"
        model2.action = { [weak self] in
            self?.pushLUT()
        }
        model.data.append(model2)
        
        let model3 = BaseListModel.init([:])
        model3.title = "metal.list.title.zoom.blur"
        model3.action = { [weak self] in
            self?.pushZoomBlur()
        }
        model.data.append(model3)
        
        let model4 = BaseListModel.init([:])
        model4.title = "metal.list.title.toon"
        model4.action = { [weak self] in
            self?.pushToon()
        }
        model.data.append(model4)
        
        let model5 = BaseListModel.init([:])
        model5.title = "metal.list.title.style.transfer"
        model5.action = { [weak self] in
            self?.pushStyleTransfer()
        }
        model.data.append(model5)
        
        let model6 = BaseListModel.init([:])
        model6.title = "metal.list.title.heap"
        model6.action = { [weak self] in
            self?.pushMTLHeap()
        }
        model.data.append(model6)
        
        let model7 = BaseListModel.init([:])
        model7.title = "metal.list.title.mask"
        model7.action = { [weak self] in
            self?.pushMask()
        }
        model.data.append(model7)
        
        return model
    }()
    
    lazy private var metal_table: UITableView = {
        
        let metal_table = UITableView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH-kTabBarH), style: .plain)
        metal_table.delegate = self
        metal_table.dataSource = self
        metal_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        metal_table.separatorStyle = .none
        metal_table.estimatedRowHeight = 44.0
        metal_table.rowHeight = UITableView.automaticDimension
        metal_table.scrollIndicatorInsets = UIEdgeInsets.zero
        
        metal_table.register(BaseListCell.self, forCellReuseIdentifier: MetalListIdentifier)
        
        return metal_table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizationTool.getStr("metal.root.title")
        navigationController?.tabBarItem.title = ""
        
        view.addSubview(metal_table)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedLanguage), name: Language_Changed_Notification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension MetalController {
    
    @objc public func changedLanguage() {
        metal_table.reloadData()
        title = LocalizationTool.getStr("metal.root.title")
        navigationController?.tabBarItem.title = ""
    }
}

extension MetalController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MetalListIdentifier) as! BaseListCell
        cell.model = model.data[indexPath.row]
        cell.isLast = (indexPath.row == (model.data.count-1))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.data[indexPath.row].action?()
    }
}

extension MetalController {
    
    private func pushNormal() {
        print("pushNormal")
    }
    private func pushLUT() {
        print("pushLUT")
    }
    private func pushZoomBlur() {
        print("pushZoomBlur")
    }
    private func pushToon() {
        print("pushToon")
    }
    private func pushStyleTransfer() {
        print("pushStyleTransfer")
    }
    private func pushMTLHeap() {
        print("pushMTLHeap")
    }
    private func pushMask() {
        print("pushMask")
    }
}
