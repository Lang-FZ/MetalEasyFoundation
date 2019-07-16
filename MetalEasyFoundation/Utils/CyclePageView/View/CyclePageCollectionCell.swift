//
//  CyclePageCollectionCell.swift
//  Base-UI-Utils
//
//  Created by LFZ on 2019/4/7.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - CyclePageCollectionCell

class CyclePageCollectionCell: UICollectionViewCell {
    
    private var cycle_style = CycleStyle.cover_flow
    
    // MARK: - 属性
    private lazy var image: UIImageView = {
        let image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width-coverFlow_between_cycle, height: self.bounds.height))
        return image
    }()
    //loading
    private lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.whiteLarge)
        loading.hidesWhenStopped = true
        loading.center = CGPoint.init(x: self.image.frame.size.width/2, y: self.image.frame.size.height/2)
        return loading
    }()
    
    // MARK: - setModel
    public var model: CyclePagePhotoModel = CyclePagePhotoModel.init() {
        didSet {
            
            image.image = UIImage.init(named: "")
            
            if model.photoName != "" {
                
                DispatchQueue.global().async {
                    let temp_image = UIImage.init(named: self.model.photoName)
                    DispatchQueue.main.async {
                        self.image.image = temp_image
                    }
                }
            } else if model.photoUrl != nil {
                
                loading.startAnimating()
                image.sd_setImage(with: model.photoUrl) { (url_image, error, cacheType, url) in
                    self.loading.stopAnimating()
                }
            }
        }
    }
    
    convenience public init(frame: CGRect, style:CycleStyle) {
        self.init(frame: frame)
        cycle_style = style
        
        switch style {
        case .cover_flow:
            image.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width-coverFlow_between_cycle, height: self.bounds.height)
        default:
            image.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width-coverFlow_between_cycle, height: self.bounds.height)
        }
    }
    
    // MARK: - 初始化
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.createCyclePageCollectionCell()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CyclePageCollectionCell {
    
    private func createCyclePageCollectionCell() {
        backgroundColor = UIColor.clear
        
        addSubview(image)
        addSubview(loading)
    }
}

