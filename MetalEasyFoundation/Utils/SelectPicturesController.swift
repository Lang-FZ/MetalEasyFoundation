//
//  SelectPicturesController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/11.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SelectPicturesController: BaseViewController {
    
    public var selected_picture:((_ picture:String) -> ())?
    public var selected_index:((_ index:Int) -> ())?
    
    public var data_status:PictureDataTypeEnum = .normal {
        didSet {
            picture_table.reloadData()
        }
    }
    
    // MARK: - 懒加载
    private lazy var data: [String] = {
        
        var data: [String] = []
        let path = Bundle.main.bundlePath
        let file_manager = FileManager.default
        let dir_enum = file_manager.enumerator(atPath: path)
        
        while let file_name:String = dir_enum?.nextObject() as? String {
            
            if file_name.lowercased().contains(".jpg") || file_name.lowercased().contains(".jpeg") || file_name.lowercased().contains(".png") {
                if !file_name.lowercased().contains("lut_") && !file_name.contains("JGProgressHUD") && !file_name.contains("LaunchImage") && !file_name.contains("AppIcon") {
                    data.append(file_name)
                }
            }
        }
        data.sort()
        
        return data
    }()
    
    private lazy var ml_data: [String] = {
        let ml_data: [String] = ["mosaic",
                                 "the_scream",
                                 "udnie",
                                 "candy"]
        return ml_data
    }()
    
    lazy private var picture_table: ASTableNode = {
        
        let picture_table = ASTableNode.init(style: .plain)
        picture_table.frame = CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH)
        picture_table.delegate = self
        picture_table.dataSource = self
        picture_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        picture_table.view.separatorStyle = .none
        picture_table.view.scrollIndicatorInsets = .zero
        
        return picture_table
    }()
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizationTool.getStr("metal.select.picture.title")
        
        view.addSubnode(picture_table)
        picture_table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("SelectPictures-deinit")
    }
}

// MARK: - tableView 代理 数据源
extension SelectPicturesController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch data_status {
        case .normal:
            return data.count
        case .ml_model:
            return ml_data.count
        }
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = { [weak self] in
            let node = BaseListNode()
            switch self?.data_status ?? .normal {
            case .normal:
                node.title_text = self?.data[indexPath.row] ?? ""
            case .ml_model:
                node.title_text = self?.ml_data[indexPath.row] ?? ""
            }
            node.isLast = (indexPath.row == ((self?.data.count ?? 0)-1))
            return node
        }
        return block
    }
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        switch data_status {
        case .normal:
            selected_picture?(data[indexPath.row])
        case .ml_model:
            selected_index?(indexPath.row)
        }
    }
//    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
//        return true
//    }
//    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
//        context.beginBatchFetching()
//    }
}

enum PictureDataTypeEnum {
    case normal
    case ml_model
}
