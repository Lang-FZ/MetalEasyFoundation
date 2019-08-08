//
//  ToonController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/12.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class ToonController: BaseViewController {

    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(80+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private var picture : PictureInput!
    
    private lazy var toon_magtol_l: UILabel = {
        let toon_magtol_l = UILabel.init()
        toon_magtol_l.textColor = UIColor.init("#323232")
        toon_magtol_l.font = UIFont.custom(FontName.PFSC_Regular, 15)
        toon_magtol_l.text = LocalizationTool.getStr("metal.toon.magtol.slider.title")
        toon_magtol_l.textAlignment = .right
        return toon_magtol_l
    }()
    private lazy var toon_magtol_s: UISlider = {
        let toon_magtol_s = UISlider.init(frame: CGRect.zero)
        toon_magtol_s.maximumValue = 1
        toon_magtol_s.minimumValue = 0.15
        toon_magtol_s.value = 0.5
        toon_magtol_s.addTarget(self, action: #selector(toonMagtolChanged(_:)), for: .valueChanged)
        return toon_magtol_s
    }()
    private lazy var toon_quantize_l: UILabel = {
        let toon_quantize_l = UILabel.init()
        toon_quantize_l.textColor = UIColor.init("#323232")
        toon_quantize_l.font = UIFont.custom(FontName.PFSC_Regular, 15)
        toon_quantize_l.text = LocalizationTool.getStr("metal.toon.quantize.slider.title")
        toon_quantize_l.textAlignment = .right
        return toon_quantize_l
    }()
    private lazy var toon_quantize_s: UISlider = {
        let toon_quantize_s = UISlider.init(frame: CGRect.zero)
        toon_quantize_s.maximumValue = 20
        toon_quantize_s.minimumValue = 3
        toon_quantize_s.value = 10
        toon_quantize_s.addTarget(self, action: #selector(toonQuantizeChanged(_:)), for: .valueChanged)
        return toon_quantize_s
    }()
    private lazy var toon_fillter: MeatlToonFilter = {
        let toon_fillter = MeatlToonFilter.init()
        return toon_fillter
    }()
    
    public var picture_name:String = "" {
        didSet {
            picture = PictureInput.init(image: UIImage.init(named: picture_name)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(toon_magtol_l)
        view.addSubview(toon_magtol_s)
        view.addSubview(toon_quantize_l)
        view.addSubview(toon_quantize_s)
        
        setUI()
        
        picture --> toon_fillter --> renderView
        picture.processImage()
    }
    
    private func setUI() {
        
        toon_quantize_l.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(frameMath(10))
            make.centerY.equalTo(view.snp.bottom).offset(-kTabBarBotH-frameMath(20))
        }
        toon_quantize_s.snp.makeConstraints { (make) in
            make.centerY.equalTo(toon_quantize_l.snp.centerY)
            make.left.equalTo(toon_quantize_l.snp.right).offset(frameMath(15))
            make.right.equalTo(view.snp.right).offset(-frameMath(15))
            make.height.equalTo(frameMath(40))
        }
        toon_magtol_l.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(frameMath(10))
            make.centerY.equalTo(toon_quantize_s.snp.top).offset(-frameMath(20))
        }
        toon_magtol_s.snp.makeConstraints { (make) in
            make.centerY.equalTo(toon_magtol_l.snp.centerY)
            make.left.equalTo(toon_quantize_l.snp.right).offset(frameMath(15))
            make.right.equalTo(view.snp.right).offset(-frameMath(15))
            make.height.equalTo(frameMath(40))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ToonController {
    
    @objc private func toonMagtolChanged(_ sender: UISlider) {
        toon_fillter.magtol = sender.value
        picture.processImage()
    }
    @objc private func toonQuantizeChanged(_ sender: UISlider) {
        toon_fillter.quantize = sender.value
        picture.processImage()
    }
}
