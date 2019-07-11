//
//  SelectPicturesController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/11.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

let selecte_picture_identifier = "selecte_picture_identifier"

class SelectPicturesController: BaseViewController {
    
    public var selected_picture:((_ picture:String) -> ())?
    
    // MARK: - 懒加载
    private lazy var data: [String] = {
        
        var data: [String] = []
        let path = Bundle.main.bundlePath
        let file_manager = FileManager.default
        let dir_enum = file_manager.enumerator(atPath: path)
        
        while let file_name:String = dir_enum?.nextObject() as? String {
            
            if file_name.lowercased().contains(".jpg") || file_name.lowercased().contains(".jpeg") || file_name.lowercased().contains(".png") {
                if !file_name.lowercased().contains("lut_") {
                    data.append(file_name)
                }
            }
        }
        data.sort()
        
        return data
    }()
    
    lazy private var picture_table: UITableView = {
        
        let picture_table = UITableView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH), style: .plain)
        picture_table.delegate = self
        picture_table.dataSource = self
        picture_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        picture_table.separatorStyle = .none
        picture_table.estimatedRowHeight = 44.0
        picture_table.rowHeight = UITableView.automaticDimension
        picture_table.scrollIndicatorInsets = UIEdgeInsets.zero
        
        picture_table.register(BaseListCell.self, forCellReuseIdentifier: selecte_picture_identifier)
        
        return picture_table
    }()
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = LocalizationTool.getStr("metal.select.picture.title")
        
        view.addSubview(picture_table)
        picture_table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - tableView 代理 数据源
extension SelectPicturesController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: selecte_picture_identifier) as! BaseListCell
        cell.title.text = data[indexPath.row]
        cell.isLast = (indexPath.row == (data.count-1))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selected_picture?(data[indexPath.row])
    }
}
