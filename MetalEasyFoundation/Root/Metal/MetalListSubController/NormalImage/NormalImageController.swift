//
//  NormalImageController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/9.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class NormalImageController: BaseViewController {
    
    // MARK: - 懒加载
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private var picture : PictureInput!
    public var picture_name:String = "" {
        didSet {
            picture = PictureInput.init(image: UIImage.init(named: picture_name)!)
        }
    }
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(renderView)
        
        picture --> renderView
        picture.processImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
