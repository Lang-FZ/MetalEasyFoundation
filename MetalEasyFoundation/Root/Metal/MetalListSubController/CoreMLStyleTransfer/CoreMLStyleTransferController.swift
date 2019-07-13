//
//  CoreMLStyleTransferController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/12.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import CoreML

class CoreMLStyleTransferController: BaseViewController {

    let imageSize = 720

    private let models = [
        mosaic().model,
        the_scream().model,
        udnie().model,
        candy().model
    ]
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    public var picture_name:String = "" {
        didSet {
            imageView.image = UIImage.init(named: picture_name)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(imageView)
    }
}
