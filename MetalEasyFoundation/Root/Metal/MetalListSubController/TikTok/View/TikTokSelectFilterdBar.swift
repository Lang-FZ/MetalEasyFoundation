//
//  TikTokSelectFilterdBar.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/17.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

private let filter_collection_identifier = "filter_collection_identifier"

class TikTokSelectFilterdBar: UIView {
    
    public var click_filter_item:((_ item:Int) -> ())?
    private var current:Int = 0
    
    private lazy var data: BaseListModel = {
        
        let dic = [
            "data":[
                [
                    "title"         :   LocalizationTool.getStr("metal.tiktok.filter.none"),
                    "index"         :   0,
                    "is_selected"   :   true
                ],[
                    "title"         :   LocalizationTool.getStr("metal.tiktok.filter.zoom"),
                    "index"         :   1,
                    "is_selected"   :   false
                ],[
                    "title"         :   LocalizationTool.getStr("metal.tiktok.filter.soulout"),
                    "index"         :   2,
                    "is_selected"   :   false
                ],[
                    "title"         :   LocalizationTool.getStr("metal.tiktok.filter.shake"),
                    "index"         :   3,
                    "is_selected"   :   false
                ],[
                    "title"         :   LocalizationTool.getStr("metal.tiktok.filter.flashwhite"),
                    "index"         :   4,
                    "is_selected"   :   false
                ],[
                    "title"         :   LocalizationTool.getStr("metal.tiktok.filter.burr"),
                    "index"         :   5,
                    "is_selected"   :   false
                ],[
                    "title"         :   LocalizationTool.getStr("metal.tiktok.filter.hallucination"),
                    "index"         :   6,
                    "is_selected"   :   false
                ]
            ]
        ]
        
        let data = BaseListModel.init(dic)
        return data
    }()
    
    /** 属性 */
    private lazy var filter_collection: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize.init(width: frameMath(80), height: frameMath(60+15))
        
        let filter_collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        filter_collection.backgroundColor = UIColor.clear
        filter_collection.showsVerticalScrollIndicator = false
        filter_collection.showsHorizontalScrollIndicator = false
        filter_collection.delegate = self
        filter_collection.dataSource = self
        filter_collection.isPagingEnabled = true
        
        filter_collection.register(TikTokSelectBarItem.self, forCellWithReuseIdentifier: filter_collection_identifier)
        
        return filter_collection
    }()
    
    
    // MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        createTikTokSelectFilterdBar()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TikTokSelectFilterdBar {
    
    private func createTikTokSelectFilterdBar() {
        backgroundColor = UIColor.white
        addSubview(filter_collection)
        
        setup_UI()
    }
    // MARK: - 约束
    private func setup_UI() {
        
        filter_collection.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(frameMath(60+15)+1)
        }
    }
}

extension TikTokSelectFilterdBar: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: filter_collection_identifier, for: indexPath) as? TikTokSelectBarItem
        
        item?.selected_item = { [weak self] (index) in
            self?.click_filter_item?(index)
        }
        item?.model = data.data[indexPath.item]
        
        return item!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if current != indexPath.item {
            
            data.data[current].is_selected = false
            data.data[indexPath.item].is_selected = true
            current = indexPath.item
            
            filter_collection.reloadData()
        }
        scrollToCenter()
    }
    
    private func scrollToCenter(_ animation:Bool = true) {
        
        let current_center = CGFloat(current) * frameMath(80) + frameMath(40)
        let center_max = CGFloat(data.data.count) * frameMath(80) - kScreenW / 2
        
        if current_center < kScreenW / 2 {
            filter_collection.setContentOffset(CGPoint(x: 0, y: 0), animated: animation)
        } else if current_center > center_max {
            filter_collection.setContentOffset(CGPoint(x: CGFloat(data.data.count) * frameMath(80) - kScreenW, y: 0), animated: animation)
        } else {
            filter_collection.setContentOffset(CGPoint(x: current_center - kScreenW / 2, y: 0), animated: animation)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = (((touches as NSSet).anyObject() as AnyObject) as! UITouch)
        if touch.view == filter_collection || touch.view == self {
            scrollToCenter(false)
        }
    }
}

