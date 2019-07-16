//
//  CyclePageCoverFlow.swift
//  Base-UI-Utils
//
//  Created by LangFZ on 2019/4/4.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit

public let coverFlow_left_inset = frameMath(45)    //左侧 contentInset
public let coverFlow_between_cycle = frameMath(0)  //两个cell的显示内容 间距

class CyclePageCoverFlow: UICollectionViewFlowLayout {
    //https://blog.csdn.net/u013410274/article/details/79925531
    override public init() {
        super.init()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CyclePageCoverFlow:UICollectionViewDelegateFlowLayout {
    
    /// 作用：在这个方法中做一些初始化操作
    /// 注意：子类重写prepareLayout，一定要调用[super prepareLayout]
    override open func prepare() {
        super.prepare()
        self.scrollDirection = UICollectionView.ScrollDirection.horizontal
    }
    /// 作用：决定cell的排布方式（frame等）
    ///
    /// - Parameter rect:
    /// - Returns:  这个方法的返回值是个数组
    ///             这个数组中存放的都是UICollectionViewLayoutAttributes对象
    ///             UICollectionViewLayoutAttributes对象决定了cell的排布方式（frame等）
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var temp_rect = rect
        
        // 闪屏现象解决参考 ：https://blog.csdn.net/u013282507/article/details/53103816
        // 扩大控制范围，防止出现闪屏现象
        temp_rect.size.width = temp_rect.size.width + (collectionView?.frame.width ?? 0)
        temp_rect.origin.x = temp_rect.origin.x - (collectionView?.frame.width ?? 0 ) / 2
        
        // 让父类布局好样式
        let layout_arr:[UICollectionViewLayoutAttributes] = NSArray.init(array: NSArray.init(array: super.layoutAttributesForElements(in: rect) ?? []) as? [Any] ?? [], copyItems: true) as? [UICollectionViewLayoutAttributes] ?? []
        
        for attributes in layout_arr {

            // cell 宽度
            let item_width = (collectionView?.frame.size.width ?? 0) - (collectionView?.contentInset.left ?? 0)*2 + coverFlow_between_cycle
            // cell 中心x
            let center_x = item_width / 2
            // 图片的中心x
            let image_center_x = attributes.center.x - coverFlow_between_cycle/2
            let relative_distance_x = image_center_x - (collectionView?.contentOffset.x ?? 0)
            
            // step 相对 中心显示位置的x距离   中心显示位置是图片的中心
            var step:CGFloat = 0
            var temp_left_offset_x:CGFloat = 0
            
            let temp_image_width = item_width-coverFlow_between_cycle
            
            if attributes.center.x < item_width {
                
                temp_left_offset_x = (collectionView?.contentOffset.x ?? 0) + (collectionView?.contentInset.left ?? 0)
                step = (abs(temp_left_offset_x) > item_width ? item_width : abs(temp_left_offset_x))
                
            } else {
                
                let temp_math = temp_image_width/2 - attributes.center.x + (collectionView?.contentInset.left ?? 0)*2.5
                if temp_math + coverFlow_between_cycle/2 > 0 {
                    //左侧的
                    temp_left_offset_x = center_x - relative_distance_x - (collectionView?.contentInset.left ?? 0) + coverFlow_between_cycle/2
                    step = (abs(temp_left_offset_x) > item_width ? item_width : abs(temp_left_offset_x))
                    
                } else {
                    //右侧的
                    temp_left_offset_x = center_x - relative_distance_x + (collectionView?.contentInset.left ?? 0) - coverFlow_between_cycle/2
                    step = (abs(temp_left_offset_x) > item_width ? item_width : abs(temp_left_offset_x))
                }
            }
            
            // 缩放比例公式
            let scale_x = CGFloat(fabsf(cosf(Float(step / center_x * CGFloat.init(Double.pi/5))))) / 5 + 4/5
            let scale_y = CGFloat(fabsf(cosf(Float(step / center_x * CGFloat.init(Double.pi/5))))) * 0.53641458 + 2/3
//            let scale = 1 - (step / item_width / 2)
            
            attributes.transform = CGAffineTransform.init(scaleX: scale_x, y: scale_y)
        }
        
        return layout_arr
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
    /// 作用：返回值决定了collectionView停止滚动时最终的偏移量（contentOffset）
    ///
    /// - Parameters:
    ///   - proposedContentOffset: 原本情况下，collectionView停止滚动时最终的偏移量
    ///   - velocity: 滚动速率，通过这个参数可以了解滚动的方向
    /// - Returns: 停止滚动时最终的偏移量
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // 保证滚动结束后视图的显示效果
        
        // 计算出最终显示的矩形框
        let rect = CGRect.init(x: proposedContentOffset.x, y: 0, width: collectionView?.frame.width ?? 0, height: collectionView?.frame.height ?? 0)
        
        // 获得 super 已经计算好的布局的属性
        let attributes_arr = super.layoutAttributesForElements(in: rect) ?? []
        
        let item_width = (collectionView?.frame.size.width ?? 0) - (collectionView?.contentInset.left ?? 0) * 2 + coverFlow_between_cycle
        let center_x = proposedContentOffset.x + (item_width/2 + (collectionView?.contentInset.left ?? 0))
        
        var min_delta = CGFloat.greatestFiniteMagnitude
        
        for attributes in attributes_arr {
            if abs(min_delta) > abs(attributes.center.x - center_x) {
                min_delta = attributes.center.x - center_x
            }
        }
        
        return CGPoint.init(x: proposedContentOffset.x + min_delta, y: proposedContentOffset.y)
    }
}

