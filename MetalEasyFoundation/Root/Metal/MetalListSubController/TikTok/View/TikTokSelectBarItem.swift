//
//  TikTokSelectBarItem.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/17.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class TikTokSelectBarItem: UICollectionViewCell {
    
    public var selected_item:((_ index:Int) -> ())?
    
    /** 属性 */
    private lazy var item_background: UIView = {
        let item_background = UIView.init()
        item_background.addSubview(title)
        item_background.layer.cornerRadius = frameMath(15)
        item_background.layer.masksToBounds = true
        return item_background
    }()
    private lazy var title: UILabel = {
        let title = UILabel.init()
        title.textColor = UIColor.black
        title.font = UIFont.custom(FontName.PFSC_Medium, 13)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    // MARK: - setModel
    public var model: BaseListModel = BaseListModel.init([:]) {
        didSet {
            if model.is_selected {
                selectedType()
                selected_item?(model.index)
            } else {
                normalType()
            }
            title.text = model.title
        }
    }
    
    
    // MARK: - 系统方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createTikTokSelectBarItem()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TikTokSelectBarItem {
    
    private func createTikTokSelectBarItem() {
        backgroundColor = UIColor.clear
        addSubview(item_background)
        
        setup_UI()
    }
    // MARK: - 约束
    private func setup_UI() {
        
        item_background.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: frameMath(60), height: frameMath(60)))
            make.left.equalToSuperview().offset(frameMath(10))
            make.top.equalTo(self.snp.top).offset(frameMath(10))
//            make.bottom.equalToSuperview().priority(600)
//            make.right.equalTo(self.snp.right).offset(frameMath(-10)).priority(600)
        }
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(item_background.snp.centerX)
            make.centerY.equalTo(item_background.snp.centerY)
        }
    }
    
    private func normalType() {
        item_background.backgroundColor = UIColor.clear
        title.textColor = UIColor.black
    }
    private func selectedType() {
        item_background.backgroundColor = UIColor.black
        title.textColor = UIColor.white
    }
}
