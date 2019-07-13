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
        model1.action = { [weak self] (title) in
            self?.pushNormal(title)
        }
        model.data.append(model1)
        
        let model2 = BaseListModel.init([:])
        model2.title = "metal.list.title.lut"
        model2.action = { [weak self] (title) in
            self?.pushLUT(title)
        }
        model.data.append(model2)
        
        let model3 = BaseListModel.init([:])
        model3.title = "metal.list.title.zoom.blur"
        model3.action = { [weak self] (title) in
            self?.pushZoomBlur(title)
        }
        model.data.append(model3)
        
        let model4 = BaseListModel.init([:])
        model4.title = "metal.list.title.toon"
        model4.action = { [weak self] (title) in
            self?.pushToon(title)
        }
        model.data.append(model4)
        
        let model5 = BaseListModel.init([:])
        model5.title = "metal.list.title.style.transfer"
        model5.action = { [weak self] (title) in
            self?.pushStyleTransfer(title)
        }
        model.data.append(model5)
        
        let model6 = BaseListModel.init([:])
        model6.title = "metal.list.title.heap"
        model6.action = { [weak self] (title) in
            self?.pushMTLHeap(title)
        }
        model.data.append(model6)
        
        let model7 = BaseListModel.init([:])
        model7.title = "metal.list.title.mask"
        model7.action = { [weak self] (title) in
            self?.pushMask(title)
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
        model.data[indexPath.row].action?(LocalizationTool.getStr(model.data[indexPath.row].title))
    }
}

// MARK: - 跳转

extension MetalController {

    //TODO: 渲染图片
    private func pushNormal(_ title:String) {
        
        let picture = SelectPicturesController()
        picture.selected_picture = { [weak self] (picture_name) in
            
            let normal = NormalImageController()
            normal.title = title
            normal.picture_name = picture_name
            self?.navigationController?.pushViewController(normal, animated: true)
        }
        
        navigationController?.pushViewController(picture, animated: true)
    }
    //TODO: LookupTable 阿宝色
    private func pushLUT(_ title:String) {
        
        let picture = SelectPicturesController()
        picture.selected_picture = { [weak self] (picture_name) in
            
            let lut = LookupTableController()
            lut.picture_name = picture_name
            lut.title = title
            self?.navigationController?.pushViewController(lut, animated: true)
        }
        
        navigationController?.pushViewController(picture, animated: true)
    }
    //TODO: ZoomBlur 径向模糊
    private func pushZoomBlur(_ title:String) {
        
        let picture = SelectPicturesController()
        picture.selected_picture = { [weak self] (picture_name) in
            
            let zoom_blur = ZoomBlurController()
            zoom_blur.picture_name = picture_name
            zoom_blur.title = title
            self?.navigationController?.pushViewController(zoom_blur, animated: true)
        }
        
        navigationController?.pushViewController(picture, animated: true)
    }
    private func pushToon(_ title:String) {
        
        let picture = SelectPicturesController()
        picture.selected_picture = { [weak self] (picture_name) in
            
            let toon = ToonController()
            toon.picture_name = picture_name
            toon.title = title
            self?.navigationController?.pushViewController(toon, animated: true)
        }
        
        navigationController?.pushViewController(picture, animated: true)
    }
    private func pushStyleTransfer(_ title:String) {
        print("pushStyleTransfer")
    }
    private func pushMTLHeap(_ title:String) {
        
        let picture = SelectPicturesController()
        picture.selected_picture = { [weak self] (picture_name) in
            
            let stretch = StretchController()
            stretch.picture_name = picture_name
            stretch.title = title
            self?.navigationController?.pushViewController(stretch, animated: true)
        }
        
        navigationController?.pushViewController(picture, animated: true)
    }
    private func pushMask(_ title:String) {
        
        let picture = SelectPicturesController()
        picture.selected_picture = { [weak self] (picture_name) in
            
            let segment = SegmentController()
            segment.picture_name = picture_name
            segment.title = title
            self?.navigationController?.pushViewController(segment, animated: true)
        }
        
        navigationController?.pushViewController(picture, animated: true)
    }
}
