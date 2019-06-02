//
//  BaseListCell.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/3.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

// MARK: -

class BaseListCell: UITableViewCell {
    
    /** 属性 */
    lazy var title: UILabel = {
        let title = UILabel.init()
        title.textColor = UIColor.init("#323232")
        title.font = UIFont.custom(FontName.PFSC_Light, 15)
        return title
    }()

    
    
    // MARK: - setModel
    public var model: BaseListModel = BaseListModel.init([:]) {
        didSet {
            title.text = LocalizationTool.getStr(model.title) 
        }
    }
    
    // MARK: - 系统方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createBaseListCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseListCell {
    
    func createBaseListCell() {
        selectionStyle = .none
        backgroundColor = UIColor.white
        
        addSubview(title)
        
        setup_UI()
    }
    // MARK: - 约束
    func setup_UI() {
        
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(frameMath(15))
            make.centerY.equalTo(self.snp.top).offset(frameMath(30))
            make.centerY.equalTo(self.snp.bottom).offset(frameMath(-30)).priority(600)
        }
    }
}
