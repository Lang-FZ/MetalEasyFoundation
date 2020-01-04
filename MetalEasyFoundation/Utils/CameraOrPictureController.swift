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
    
    lazy private var metal_table: ASTableNode = {
        
        let metal_table = ASTableNode.init(style: .plain)
        metal_table.frame = CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH)
        metal_table.delegate = self
        metal_table.dataSource = self
        metal_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        metal_table.view.separatorStyle = .none
//        metal_table.estimatedRowHeight = 44.0
//        metal_table.rowHeight = UITableView.automaticDimension
        metal_table.view.scrollIndicatorInsets = UIEdgeInsets.zero
        
//        metal_table.register(BaseListCell.self, forCellReuseIdentifier: CameraOrPictureIdentifier)
        
        return metal_table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = LocalizationTool.getStr("metal.select.camera.picture.title")
        view.addSubnode(metal_table)
        metal_table.reloadData()
    }
    deinit {
        print("CameraOrPicture-deinit")
    }
}

extension CameraOrPictureController: ASTableDelegate, ASTableDataSource {

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

extension CameraOrPictureController {
    
    // MARK: 调用镜头
    private func selectedCameraVC() {
        
        selected_render_type?(.camera, "")
    }
    // MARK: 选取图片
    private func selectedPictureVC() {
        
        let picture = SelectPicturesController()
        picture.selected_picture = { [weak self] (picture_name) in
            self?.selected_render_type?(.picture, picture_name)
        }
        navigationController?.pushViewController(picture, animated: true)
    }
}
