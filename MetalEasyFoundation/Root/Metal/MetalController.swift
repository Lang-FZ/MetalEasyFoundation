//
//  MetalController.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class MetalController: BaseViewController, HadTabBarProtocol {

    lazy private var model: BaseListModel = {
        
        let model = BaseListModel.init([:])
        
        let model1 = BaseListModel.init([:])
        model1.title = "metal.list.title.lut"
        model1.action = { [weak self] (title) in
            self?.pushLUT(title)
        }
        model.data.append(model1)
        
        let model2 = BaseListModel.init([:])
        model2.title = "metal.list.title.zoom.blur"
        model2.action = { [weak self] (title) in
            self?.pushZoomBlur(title)
        }
        model.data.append(model2)
        
        let model3 = BaseListModel.init([:])
        model3.title = "metal.list.title.toon"
        model3.action = { [weak self] (title) in
            self?.pushToon(title)
        }
        model.data.append(model3)
        
        let model4 = BaseListModel.init([:])
        model4.title = "metal.list.title.style.transfer"
        model4.action = { [weak self] (title) in
            self?.pushStyleTransfer(title)
        }
        model.data.append(model4)
        
        let model5 = BaseListModel.init([:])
        model5.title = "metal.list.title.heap"
        model5.action = { [weak self] (title) in
            self?.pushMTLHeap(title)
        }
        model.data.append(model5)
        
        let model6 = BaseListModel.init([:])
        model6.title = "metal.list.title.mask"
        model6.action = { [weak self] (title) in
            self?.pushMask(title)
        }
        model.data.append(model6)
        
        let model7 = BaseListModel.init([:])
        model7.title = "metal.list.title.tiktok"
        model7.action = { [weak self] (title) in
            self?.tiktok(title)
        }
        model.data.append(model7)
        
        return model
    }()
    
    lazy private var metal_table: ASTableNode = {
        
        let metal_table = ASTableNode.init(style: .plain)
        metal_table.frame = CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH-kTabBarH)
        metal_table.delegate = self
        metal_table.dataSource = self
        metal_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        metal_table.view.separatorStyle = .none
        metal_table.view.scrollIndicatorInsets = UIEdgeInsets.zero
        
        return metal_table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizationTool.getStr("metal.root.title")
        navigationController?.tabBarItem.title = ""
        
        view.addSubnode(metal_table)
        metal_table.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedLanguage), name: Language_Changed_Notification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("MetalController-deinit")
    }
}

extension MetalController {
    
    @objc public func changedLanguage() {
        metal_table.reloadData()
        title = LocalizationTool.getStr("metal.root.title")
        navigationController?.tabBarItem.title = ""
    }
}

extension MetalController: ASTableDelegate, ASTableDataSource {
    
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
        model.data[indexPath.row].action?(LocalizationTool.getStr(model.data[indexPath.row].title))
    }
}

// MARK: - 跳转

extension MetalController {

    // MARK: LookupTable 阿宝色
    private func pushLUT(_ title:String) {
        
        let camera_picture = CameraOrPictureController()
        camera_picture.selected_render_type = { [weak self] (type, picture_name) in
            
            let lut = LookupTableController()
            lut.title = title
            if type == .picture {
                lut.picture_name = picture_name
            }
            lut.type = type
            self?.navigationController?.pushViewController(lut, animated: true)
        }
        navigationController?.pushViewController(camera_picture, animated: true)
    }
    // MARK: ZoomBlur 缩放模糊
    private func pushZoomBlur(_ title:String) {
        
        let camera_picture = CameraOrPictureController()
        camera_picture.selected_render_type = { [weak self] (type, picture_name) in
            
            let zoom_blur = ZoomBlurController()
            zoom_blur.title = title
            if type == .picture {
                zoom_blur.picture_name = picture_name
            }
            zoom_blur.type = type
            self?.navigationController?.pushViewController(zoom_blur, animated: true)
        }
        navigationController?.pushViewController(camera_picture, animated: true)
    }
    // MARK: 描边、颜色丰富度
    private func pushToon(_ title:String) {
        
        let camera_picture = CameraOrPictureController()
        camera_picture.selected_render_type = { [weak self] (type, picture_name) in
            
            let toon = ToonController()
            toon.title = title
            if type == .picture {
                toon.picture_name = picture_name
            }
            toon.type = type
            self?.navigationController?.pushViewController(toon, animated: true)
        }
        navigationController?.pushViewController(camera_picture, animated: true)
    }
    // MARK: 机器学习风格滤镜
    private func pushStyleTransfer(_ title:String) {
        
        let camera_picture = CameraOrPictureController()
        camera_picture.selected_render_type = { [weak self] (type, picture_name) in
            
            let transfer = CoreMLStyleTransferController()
            transfer.title = title
            if type == .picture {
                transfer.picture_name = picture_name
            }
            transfer.type = type
            self?.navigationController?.pushViewController(transfer, animated: true)
        }
        navigationController?.pushViewController(camera_picture, animated: true)
    }
    // MARK: 拉伸
    private func pushMTLHeap(_ title:String) {
        
        let camera_picture = CameraOrPictureController()
        camera_picture.selected_render_type = { [weak self] (type, picture_name) in
            
            let stretch = StretchController()
            stretch.title = title
            if type == .picture {
                stretch.picture_name = picture_name
            }
            stretch.type = type
            self?.navigationController?.pushViewController(stretch, animated: true)
        }
        navigationController?.pushViewController(camera_picture, animated: true)
    }
    // MARK: 抠图
    private func pushMask(_ title:String) {
        
        let camera_picture = CameraOrPictureController()
        camera_picture.selected_render_type = { [weak self] (type, picture_name) in
            
            let segment = SegmentController()
            segment.title = title
            if type == .picture {
                segment.picture_name = picture_name
            }
            segment.type = type
            self?.navigationController?.pushViewController(segment, animated: true)
        }
        navigationController?.pushViewController(camera_picture, animated: true)
    }
    // MARK: 抖音特效
    private func tiktok(_ title:String) {
        
        let camera_picture = CameraOrPictureController()
        camera_picture.selected_render_type = { [weak self] (type, picture_name) in
            
            let tiktok = TikTokController()
            tiktok.title = title
            if type == .picture {
                tiktok.picture_name = picture_name
            }
            tiktok.type = type
            self?.navigationController?.pushViewController(tiktok, animated: true)
        }
        navigationController?.pushViewController(camera_picture, animated: true)
    }
}
