//
//  CameraOrPictureController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/9.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

enum CameraOrPictureType {
    case camera
    case picture
}

private let CameraOrPictureIdentifier = "CameraOrPictureIdentifier"

class CameraOrPictureController: BaseViewController {

    public var selected_render_type:((_ type:CameraOrPictureType, _ picture:String) -> ())?
    
    lazy private var model: BaseListModel = {
        
        let model = BaseListModel.init([:])
        
        let model1 = BaseListModel.init([:])
        model1.title = "metal.select.camera.title"
        model1.action = { [weak self] (title) in
            self?.selectedCameraVC()
        }
        model.data.append(model1)
        
        let model2 = BaseListModel.init([:])
        model2.title = "metal.select.picture.title"
        model2.action = { [weak self] (title) in
            self?.selectedPictureVC()
        }
        model.data.append(model2)
        
        return model
    }()
    
    lazy private var metal_table: UITableView = {
        
        let metal_table = UITableView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH), style: .plain)
        metal_table.delegate = self
        metal_table.dataSource = self
        metal_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        metal_table.separatorStyle = .none
        metal_table.estimatedRowHeight = 44.0
        metal_table.rowHeight = UITableView.automaticDimension
        metal_table.scrollIndicatorInsets = UIEdgeInsets.zero
        
        metal_table.register(BaseListCell.self, forCellReuseIdentifier: CameraOrPictureIdentifier)
        
        return metal_table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = LocalizationTool.getStr("metal.select.camera.picture.title")
        view.addSubview(metal_table)
        metal_table.reloadData()
    }
}

extension CameraOrPictureController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CameraOrPictureIdentifier) as! BaseListCell
        cell.model = model.data[indexPath.row]
        cell.isLast = (indexPath.row == (model.data.count-1))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.data[indexPath.row].action?("")
    }
}

extension CameraOrPictureController {
    
    //TODO: 调用镜头
    private func selectedCameraVC() {
        
        selected_render_type?(.camera, "")
    }
    //TODO: 选取图片
    private func selectedPictureVC() {
        
        let picture = SelectPicturesController()
        picture.selected_picture = { [weak self] (picture_name) in
            self?.selected_render_type?(.picture, picture_name)
        }
        navigationController?.pushViewController(picture, animated: true)
    }
}
