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
    private lazy var separator: UIView = {
        let separator = UIView.init()
        separator.backgroundColor = UIColor.init("#D2D2D2")
        return separator
    }()
    lazy var sub_title: UILabel = {
        let sub_title = UILabel.init()
        sub_title.textColor = UIColor.init("#323232")
        sub_title.font = UIFont.custom(FontName.PFSC_Light, 15)
        sub_title.textAlignment = .right
        return sub_title
    }()
    
    public var isLast:Bool = false {
        didSet {
            if isLast {
                separator.alpha = 0
            } else {
                separator.alpha = 1
            }
        }
    }
    
    
    // MARK: - setModel
    public var model: BaseListModel = BaseListModel.init([:]) {
        didSet {
            title.text = LocalizationTool.getStr(model.title)
            sub_title.text = model.sub_title
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
        addSubview(sub_title)
        addSubview(separator)
        
        setup_UI()
    }
    // MARK: - 约束
    func setup_UI() {
        
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(frameMath(15))
            make.centerY.equalTo(self.snp.top).offset(frameMath(30))
            make.centerY.equalTo(self.snp.bottom).offset(frameMath(-30)).priority(600)
        }
        sub_title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(frameMath(15))
            make.centerY.equalTo(title.snp.centerY)
        }
        separator.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(frameMath(15))
            make.right.equalToSuperview().offset(frameMath(-15))
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
