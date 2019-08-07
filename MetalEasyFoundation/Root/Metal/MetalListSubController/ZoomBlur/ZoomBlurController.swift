//
//  ZoomBlurController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/11.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class ZoomBlurController: BaseViewController {
    
    // MARK: - 懒加载
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(40+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private var picture : PictureInput!
    
    private lazy var zoom_blur_l: UILabel = {
        let zoom_blur_l = UILabel.init()
        zoom_blur_l.textColor = UIColor.init("#323232")
        zoom_blur_l.font = UIFont.custom(FontName.PFSC_Regular, 15)
        zoom_blur_l.text = LocalizationTool.getStr("metal.zoom.blur.slider.title")
        zoom_blur_l.textAlignment = .right
        return zoom_blur_l
    }()
    private lazy var zoom_blur_s: UISlider = {
        let zoom_blur_s = UISlider.init(frame: CGRect.zero)
        zoom_blur_s.maximumValue = 5
        zoom_blur_s.minimumValue = 0
        zoom_blur_s.value = 0
        zoom_blur_s.addTarget(self, action: #selector(zoomBlurChanged(_:)), for: .valueChanged)
        return zoom_blur_s
    }()
    private lazy var zoom_blur_fillter: ZoomBlur = {
        let zoom_blur_fillter = ZoomBlur.init()
        zoom_blur_fillter.blurSize = 0
        return zoom_blur_fillter
    }()
    
    public var picture_name:String = "" {
        didSet {
            picture = PictureInput.init(image: UIImage.init(named: picture_name)!)
        }
    }
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(zoom_blur_l)
        view.addSubview(zoom_blur_s)
        
        setUI()
        
        picture --> zoom_blur_fillter --> renderView
        picture.processImage()
    }
    
    private func setUI() {
        
        zoom_blur_l.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(frameMath(10))
            make.centerY.equalTo(view.snp.bottom).offset(-kTabBarBotH-frameMath(20))
        }
        zoom_blur_s.snp.makeConstraints { (make) in
            make.centerY.equalTo(zoom_blur_l.snp.centerY)
            make.left.equalTo(zoom_blur_l.snp.right).offset(frameMath(15))
            make.right.equalTo(view.snp.right).offset(-frameMath(15))
            make.height.equalTo(frameMath(40))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ZoomBlurController {
    
    @objc private func zoomBlurChanged(_ sender: UISlider) {
        zoom_blur_fillter.blurSize = sender.value
        picture.processImage()
    }
}
