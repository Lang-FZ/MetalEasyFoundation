//
//  StretchController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/13.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class StretchController: BaseViewController {

    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(40+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private var picture : PictureInput!
    
    private lazy var stretch_l: UILabel = {
        let stretch_l = UILabel.init()
        stretch_l.textColor = UIColor.init("#323232")
        stretch_l.font = UIFont.custom(FontName.PFSC_Regular, 15)
        stretch_l.text = LocalizationTool.getStr("metal.stretch.slider.title")
        stretch_l.textAlignment = .right
        return stretch_l
    }()
    private lazy var stretch_s: UISlider = {
        let stretch_s = UISlider.init(frame: CGRect.zero)
        stretch_s.maximumValue = 1.5
        stretch_s.minimumValue = 0.5
        stretch_s.value = 1
        stretch_s.addTarget(self, action: #selector(stretchChanged(_:)), for: .valueChanged)
        return stretch_s
    }()
    private lazy var stretch_fillter: StretchFilter = {
        let stretch_fillter = StretchFilter.init()
        return stretch_fillter
    }()
    
    public var picture_name:String = "" {
        didSet {
            picture = PictureInput.init(image: UIImage.init(named: picture_name)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(stretch_l)
        view.addSubview(stretch_s)
        
        setUI()
        
        picture --> stretch_fillter --> renderView
        picture.processImage()
    }
    
    private func setUI() {
        
        stretch_l.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(frameMath(10))
            make.centerY.equalTo(view.snp.bottom).offset(-kTabBarBotH-frameMath(20))
        }
        stretch_s.snp.makeConstraints { (make) in
            make.centerY.equalTo(stretch_l.snp.centerY)
            make.left.equalTo(stretch_l.snp.right).offset(frameMath(15))
            make.right.equalTo(view.snp.right).offset(-frameMath(15))
            make.height.equalTo(frameMath(40))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension StretchController {
    
    @objc private func stretchChanged(_ sender: UISlider) {
        stretch_fillter.heightFactor = sender.value
        picture.processImage()
    }
}
