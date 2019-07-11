//
//  NormalImageController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/9.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class NormalImageController: UIViewController {
    
    // MARK: - 懒加载
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private lazy var picture : PictureInput = {
        let picture = PictureInput.init(image: UIImage.init(named: "natural_light_purple1.jpg")!)
        return picture
    }()
    
    
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
