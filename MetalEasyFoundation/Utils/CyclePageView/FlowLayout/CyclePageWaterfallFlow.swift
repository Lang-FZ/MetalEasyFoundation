//
//  CyclePageWaterfallFlow.swift
//  Base-UI-Utils
//
//  Created by LangFZ on 2019/4/15.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit

public let waterfallFlow_section_count = 2                  //一共几列
public let waterfallFlow_between_line = frameMath(8)        //最小行间距
public let waterfallFlow_between_interitem = frameMath(5)   //同一列中间隔的cell最小间距
public let waterfallFlow_inset_left_right = frameMath(20)   //inset 左右
public let waterfallFlow_inset_top_bottom = frameMath(10)   //inset 上下

class CyclePageWaterfallFlow: UICollectionViewFlowLayout {
    
    public var data: CyclePagePhotoModel = CyclePagePhotoModel.init()
    
    lazy private var column_width_height:CGFloat = {
        
        var column_width_height:CGFloat = 0
        
        if self.scrollDirection == .horizontal {
            //横向滚动
            let temp_column_all_height = (self.collectionView?.frame.size.height ?? 0) - waterfallFlow_inset_top_bottom*2
            let column_all_height = temp_column_all_height - waterfallFlow_between_line*CGFloat.init(waterfallFlow_section_count-1)
            column_width_height = column_all_height/CGFloat.init(waterfallFlow_section_count)
            
        } else {
            //纵向滚动
            let temp_column_all_width = (self.collectionView?.frame.size.width ?? 0) - waterfallFlow_inset_left_right*2
            let column_all_width = temp_column_all_width - waterfallFlow_between_line*CGFloat.init(waterfallFlow_section_count-1)
            column_width_height = column_all_width/CGFloat.init(waterfallFlow_section_count)
        }
        
        return column_width_height
    } ()
    
    lazy private var temp_column_widths_heights:[CGFloat] = []
    lazy private var column_widths_heights:[CGFloat] = {
        var column_widths_heights:[CGFloat] = []
        for i in 0..<waterfallFlow_section_count {
            column_widths_heights.append(0)
        }
        return column_widths_heights
    } ()
    
    override public init() {
        super.init()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CyclePageWaterfallFlow:UICollectionViewDelegateFlowLayout {
    
    /// 作用：在这个方法中做一些初始化操作
    /// 注意：子类重写prepareLayout，一定要调用[super prepareLayout]
    override open func prepare() {
        super.prepare()
        
        temp_column_widths_heights = []
        for _ in 0..<waterfallFlow_section_count {
            temp_column_widths_heights.append(0)
        }
    }
    
    /// 返回indexPath位置cell对应的布局属性
    ///
    /// - Parameter indexPath: 位置
    /// - Returns: 返回indexPath位置cell对应的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let layout_arr:UICollectionViewLayoutAttributes? = super.layoutAttributesForItem(at: indexPath)
        let shortest = temp_column_widths_heights.sorted(by: <).first ?? 0
        let shortCol = NSArray.init(array: temp_column_widths_heights).index(of: shortest)
        
        if scrollDirection == .horizontal {
            //横向滚动
            let x = (shortest == 0 ? shortest : shortest + waterfallFlow_between_interitem)
            let y = CGFloat.init(shortCol)*column_width_height+waterfallFlow_inset_top_bottom+waterfallFlow_between_line*CGFloat.init(shortCol)
            
            //获取cell宽度
            let width = data.photoData[indexPath.item].photo_width_height
            
            layout_arr?.frame = CGRect.init(x: x, y: y, width: width, height: column_width_height)
            temp_column_widths_heights[shortCol] = x + width
            
        } else {
            //纵向滚动
            let x = CGFloat.init(shortCol)*column_width_height+waterfallFlow_inset_left_right+waterfallFlow_between_line*CGFloat.init(shortCol)
            let y = (shortest == 0 ? shortest : shortest + waterfallFlow_between_interitem)
            
            //获取cell高度
            let height = data.photoData[indexPath.item].photo_width_height
            
            layout_arr?.frame = CGRect.init(x: x, y: y, width: column_width_height, height: height)
            temp_column_widths_heights[shortCol] = y + height
        }
        
        return layout_arr
    }
    
    /// 作用：决定cell的排布方式（frame等）
    ///
    /// - Parameter rect:
    /// - Returns:  这个方法的返回值是个数组
    ///             这个数组中存放的都是UICollectionViewLayoutAttributes对象
    ///             UICollectionViewLayoutAttributes对象决定了cell的排布方式（frame等）
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        temp_column_widths_heights = []
        for _ in 0..<waterfallFlow_section_count {
            temp_column_widths_heights.append(0)
        }
        
        var temp_arr:[UICollectionViewLayoutAttributes] = []
        let items = collectionView?.numberOfItems(inSection: 0) ?? 0

        for i in 0..<items {

            let att = self.layoutAttributesForItem(at: IndexPath.init(row: i, section: 0)) ?? UICollectionViewLayoutAttributes.init()
            temp_arr.append(att)
        }
        column_widths_heights = temp_column_widths_heights
        
        return temp_arr
    }
    
    override var collectionViewContentSize: CGSize {
        
        let longest = self.column_widths_heights.sorted(by: >).first ?? 0
        var size:CGSize = CGSize.zero
        
        if scrollDirection == .horizontal {
            //横向滚动
            size = CGSize.init(width: longest, height: self.collectionView?.frame.size.height ?? 0)
        } else {
            //纵向滚动
            size = CGSize.init(width: (collectionView?.frame.size.width ?? 0), height: longest)
        }
        
        return size
    }
    
    /// 作用：如果返回YES，那么collectionView显示的范围发生改变时，就会重新刷新布局
    ///
    /// - Parameter newBounds:
    /// - Returns:  如果返回YES，那么collectionView显示的范围发生改变时，就会重新刷新布局
    ///             一旦重新刷新布局，就会按顺序调用下面的方法：
    ///                 prepare
    ///                 layoutAttributesForElementsInRect:
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
