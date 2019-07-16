//
//  CyclePageController.swift
//  Base-UI-Utils
//
//  Created by LangFZ on 2019/4/4.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit

private let CyclePage_Identifier = "CyclePage_Identifier"
private let CyclePage_waterfall_Identifier = "CyclePage_waterfall_Identifier"

class CyclePageController: NoneBarController {
    
    public var click_index:((_ index:Int) -> ())?
    public var is_call_back:Bool = false
    
    private var cycle_style = CycleStyle.cover_flow     //显示类型
    private var isHadData:Bool = false      //已经赋值模型 可以触发 非初始化UI影响的 判断
    private var cycle_page_loop = false     //是否可循环
    
    public var is_page_loop = true          //外部控制可否循环
    public var current_page:Int = 0         //当前第几页
    public var before_after_add = 2         //可以循环时 前后各加几个
    
    private var collection_size = CGSize.zero
    public var direction:UICollectionView.ScrollDirection = .vertical {
        didSet {
            waterfallFlow.scrollDirection = direction
        }
    }
    
    public var item_size = CGSize.init(width: kScreenW - coverFlow_left_inset - (coverFlow_left_inset - coverFlow_between_cycle), height: frameMath(150))
    
    public var data: CyclePagePhotoModel = CyclePagePhotoModel.init() {
        didSet {
            
            switch cycle_style {
            case .cover_flow:
                collection_size = CGSize.init(width: kScreenW, height: frameMath(150))
                
            case .waterfall_flow:
                
                is_page_loop = false
                waterfallFlow.data = data
                
                if waterfallFlow.scrollDirection == .horizontal {
                    //横向滚动
                    collection_size = CGSize.init(width: kScreenW, height: frameMath(200))
                } else {
                    //纵向滚动
                    collection_size = CGSize.init(width: kScreenW, height: kScreenH-44-39)
                }
            }
            
            if data.photoData.count > 2 && data.photoData.count >= before_after_add && is_page_loop {
                //大于2 前后各加2 可循环

                cycle_page_loop = true

                for index in 1...before_after_add {
                    data.photoData.insert(data.photoData[data.photoData.count-index], at: 0)
                }
                for index in 0..<before_after_add {
                    data.photoData.append(data.photoData[index+before_after_add])
                }
                
                isHadData = false
                cycle_page.reloadData()
                
                let item_width = (cycle_page.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.width ?? 0
                isHadData = true
                cycle_page.setContentOffset(CGPoint.init(x: item_width*CGFloat.init(before_after_add)-cycle_page.contentInset.left, y: 0), animated: false)

            } else {
                //不大于2 不可循环

                cycle_page_loop = false
                isHadData = true
                cycle_page.reloadData()
            }
        }
    }
    
    // MARK: - 懒加载
    // cover_flow
    private lazy var coverFlow: CyclePageCoverFlow = {
        let coverFlow = CyclePageCoverFlow.init()
        coverFlow.scrollDirection = .horizontal
        coverFlow.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        coverFlow.minimumLineSpacing = 0
        coverFlow.minimumInteritemSpacing = 0
        coverFlow.itemSize = CGSize.init(width: kScreenW, height: 1)
        return coverFlow
    }()
    // waterfall_flow
    private lazy var waterfallFlow: CyclePageWaterfallFlow = {
        let waterfallFlow = CyclePageWaterfallFlow.init()
        waterfallFlow.scrollDirection = .horizontal
        waterfallFlow.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        waterfallFlow.minimumLineSpacing = waterfallFlow_between_line
        waterfallFlow.minimumInteritemSpacing = waterfallFlow_between_interitem
        return waterfallFlow
    }()
    
    private lazy var cycle_page: UICollectionView = {
        
        var flow_layout:UICollectionViewDelegateFlowLayout?
        var cycle_page:UICollectionView?
        
        switch cycle_style {
        case .cover_flow:
            
            item_size = CGSize.init(width: kScreenW - coverFlow_left_inset - (coverFlow_left_inset - coverFlow_between_cycle), height: frameMath(150))
            coverFlow.itemSize = item_size
            flow_layout = coverFlow
            
            cycle_page = UICollectionView.init(frame: CGRect.init(x: 0, y: 200, width: collection_size.width, height: collection_size.height), collectionViewLayout: flow_layout as! UICollectionViewLayout)
            cycle_page?.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)  //类似分页的减速效果
            cycle_page?.register(CyclePageCollectionCell.self, forCellWithReuseIdentifier: CyclePage_Identifier)
            
        case .waterfall_flow:
            
            if waterfallFlow.scrollDirection == .horizontal {
                //横向滚动
                waterfallFlow.estimatedItemSize = CGSize.init(width: CGFloat.leastNormalMagnitude, height: (collection_size.height-waterfallFlow_inset_top_bottom*2-waterfallFlow_between_line*CGFloat.init(waterfallFlow_section_count-1))/CGFloat(waterfallFlow_section_count))
                flow_layout = waterfallFlow
                let rect = CGRect.init(x: 0, y: 44, width: collection_size.width, height: collection_size.height)
                cycle_page = UICollectionView.init(frame: rect, collectionViewLayout: flow_layout as! UICollectionViewLayout)

            } else {
                //纵向滚动
                waterfallFlow.estimatedItemSize = CGSize.init(width: (collection_size.width-waterfallFlow_inset_left_right*2-waterfallFlow_between_line*CGFloat.init(waterfallFlow_section_count-1))/CGFloat(waterfallFlow_section_count), height: CGFloat.leastNormalMagnitude)
                flow_layout = waterfallFlow
                let rect = CGRect.init(x: 0, y: 44, width: collection_size.width, height: collection_size.height)
                cycle_page = UICollectionView.init(frame: rect, collectionViewLayout: flow_layout as! UICollectionViewLayout)
            }
            
            cycle_page?.register(CyclePageWaterfallCell.self, forCellWithReuseIdentifier: CyclePage_waterfall_Identifier)
        }
        
        cycle_page?.backgroundColor = UIColor.clear
        cycle_page?.showsVerticalScrollIndicator = false
        cycle_page?.showsHorizontalScrollIndicator = false
        cycle_page?.delegate = self
        cycle_page?.dataSource = self
        
        cycle_page?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissController)))
        
        switch cycle_style {
        case .cover_flow:
            cycle_page?.contentInset = UIEdgeInsets.init(top: 0, left: coverFlow_left_inset, bottom: 0, right: coverFlow_left_inset - coverFlow_between_cycle)
        case .waterfall_flow:
            
            if waterfallFlow.scrollDirection == .horizontal {
                //横向滚动
                cycle_page?.contentInset = UIEdgeInsets.init(top: 0, left: waterfallFlow_inset_left_right, bottom: 0, right: waterfallFlow_inset_left_right)
            } else {
                //纵向滚动
                cycle_page?.contentInset = UIEdgeInsets.init(top: waterfallFlow_inset_top_bottom, left: 0, bottom: waterfallFlow_inset_top_bottom, right: 0)
            }
        }
        
        return cycle_page ?? UICollectionView.init()
    }()
    
    init(_ style:CycleStyle) {
        super.init()
        cycle_style = style
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统方法
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(cycle_page)
        cycle_page.reloadData()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = (((touches as NSSet).anyObject() as AnyObject) as! UITouch)
        
        if touch.view == self.view {
            dismissController()
        } else if touch.view == cycle_page {
            dismissController()
        }
    }
    @objc private func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    private func clickCollectionView(_ index:Int) {
        
        click_index?(index)
        
        if is_call_back {
            dismissController()
        }
    }
}

// MARK: - tableView 代理 数据源
extension CyclePageController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.photoData.count
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch cycle_style {
        case .cover_flow:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CyclePage_Identifier, for: indexPath) as? CyclePageCollectionCell
            cell?.model = data.photoData[indexPath.item]
            
            return cell!
            
        case .waterfall_flow:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CyclePage_waterfall_Identifier, for: indexPath) as? CyclePageWaterfallCell
            
            if waterfallFlow.scrollDirection == .horizontal {
                //横向滚动
                data.photoData[indexPath.item].collection_width_height = collection_size.height
            } else {
                //纵向滚动
                data.photoData[indexPath.item].collection_width_height = collection_size.width
            }
            
            data.photoData[indexPath.item].indexPath = indexPath
            
            cell?.direction = waterfallFlow.scrollDirection
            cell?.created_image = { [weak self] (image,width_height,index) in
                self?.changeModelData(index ?? IndexPath.init(row: 0, section: 0), image, width_height)
            }
            cell?.click_item = { [weak self] in
                self?.clickCollectionView(indexPath.item)
            }
            
            cell?.model = data.photoData[indexPath.item]
            
            return cell!
        }
    }
    
    /// 修改瀑布流单个数据并刷新
    ///
    /// - Parameters:
    ///   - index: 索引
    ///   - image: 图片
    ///   - width_height: 图片 宽或高
    func changeModelData(_ index:IndexPath,_ image:UIImage,_ width_height:CGFloat) {
        
        self.data.photoData[index.item].image = image
        self.data.photoData[index.item].photo_width_height = CGFloat.init(width_height)
        self.waterfallFlow.data = self.data
        self.cycle_page.reloadItems(at: [index])
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if cycle_page_loop {
            if indexPath.item < before_after_add {
                //左侧添加的
                clickCollectionView(indexPath.item+(data.photoData.count-before_after_add*2)-before_after_add)
            } else if indexPath.item >= data.photoData.count+before_after_add {
                //右侧添加的
                clickCollectionView(indexPath.item-(data.photoData.count-before_after_add))
            } else {
                //中间的item
                clickCollectionView(indexPath.item-before_after_add)
            }
        } else {
            clickCollectionView(indexPath.item)
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isHadData {
            
            let item_width = ((scrollView as? UICollectionView)?.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.width ?? 0
            let real_offset_x = scrollView.contentOffset.x + scrollView.contentInset.left
            var current_index = 0
            
            if cycle_page_loop {
                
                if real_offset_x >= item_width*CGFloat.init(data.photoData.count-before_after_add) {
                    //大于 图片数组的最后一张 也就是加了四张图片之后的倒数第三张    (当前后各加2时)
                    cycle_page.setContentOffset(CGPoint.init(x: item_width*CGFloat.init(before_after_add)-cycle_page.contentInset.left, y: 0), animated: false)
                    
                } else if real_offset_x <= item_width*CGFloat.init(before_after_add-1) && real_offset_x != 0 {
                    //小于 图片最后一张 也就是加了四张图片之后的第二张     (当前后各加2时)
                    cycle_page.setContentOffset(CGPoint.init(x: item_width*CGFloat.init(data.photoData.count-before_after_add*2+before_after_add-1)-cycle_page.contentInset.left, y: 0), animated: false)
                }
                
                let temp_int_index = Int.init(real_offset_x/item_width)
                let temp_half_index = real_offset_x-CGFloat.init(temp_int_index)*item_width
                
                if real_offset_x < (item_width*CGFloat.init(before_after_add) - item_width/2) {
                    //显示 图片0 左侧
                    current_index = temp_int_index+(data.photoData.count-before_after_add*3) + Int.init(temp_half_index / (item_width/2))
                    
                } else if real_offset_x >= (item_width*CGFloat.init(data.photoData.count-before_after_add-1) + item_width/2) {
                    //显示 最后一张 右侧
                    current_index = temp_int_index-(data.photoData.count-before_after_add) + Int.init(temp_half_index / (item_width/2))
                    
                } else {
                    //中间真实显示图片数组的部分 0时 0+0 or -1+1
                    current_index = temp_int_index-before_after_add + Int.init(temp_half_index / (item_width/2))
                }
            } else {
                
                if real_offset_x < item_width/2 {
                    current_index = 0
                } else if real_offset_x > item_width*CGFloat.init(data.photoData.count-1) {
                    current_index = data.photoData.count-1
                } else {
                    let temp_int_index = Int.init(real_offset_x/item_width)
                    let temp_half_index = real_offset_x-CGFloat.init(temp_int_index)*item_width
                    current_index = temp_int_index + Int.init(temp_half_index / (item_width/2))
                }
            }
            
            current_page_index(current_index)
        }
    }
    
    /// 当前是第几页
    ///
    /// - Parameter index: 页码
    private func current_page_index(_ index:Int) {
        
        if index != current_page {
            current_page = index
            print("current_index \(index)")
        }
    }
}

public enum CycleStyle {
    case cover_flow
    case waterfall_flow
}
