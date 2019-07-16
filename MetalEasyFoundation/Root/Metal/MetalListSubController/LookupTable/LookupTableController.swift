//
//  LookupTableController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/9.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class LookupTableController: BaseViewController {
    
    // MARK: - 懒加载
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(120+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private var picture : PictureInput!
    
    //TODO: 饱和度
    private lazy var saturation_l: UILabel = {
        let saturation_l = UILabel.init()
        saturation_l.textColor = UIColor.init("#323232")
        saturation_l.font = UIFont.custom(FontName.PFSC_Regular, 15)
        saturation_l.text = LocalizationTool.getStr("metal.lut.saturation")
        saturation_l.textAlignment = .right
        return saturation_l
    }()
    private lazy var saturation_s: UISlider = {
        let saturation_s = UISlider.init(frame: CGRect.zero)
        saturation_s.maximumValue = 2
        saturation_s.minimumValue = 0
        saturation_s.value = 1
        saturation_s.addTarget(self, action: #selector(saturationChanged(_:)), for: .valueChanged)
        return saturation_s
    }()
    private lazy var saturation_fillter: SaturationFilter = {
        let saturation_fillter = SaturationFilter.init()
        saturation_fillter.saturation = 1
        return saturation_fillter
    }()
    
    //TODO: 亮度
    private lazy var brightness_l: UILabel = {
        let brightness_l = UILabel.init()
        brightness_l.textColor = UIColor.init("#323232")
        brightness_l.font = UIFont.custom(FontName.PFSC_Regular, 15)
        brightness_l.text = LocalizationTool.getStr("metal.lut.brightness")
        brightness_l.textAlignment = .right
        return brightness_l
    }()
    private lazy var brightness_s: UISlider = {
        let brightness_s = UISlider.init(frame: CGRect.zero)
        brightness_s.maximumValue = 1
        brightness_s.minimumValue = -1
        brightness_s.value = 0
        brightness_s.addTarget(self, action: #selector(brightnessChanged(_:)), for: .valueChanged)
        return brightness_s
    }()
    private lazy var brightness_fillter: BrightnessFilter = {
        let brightness_fillter = BrightnessFilter.init()
        brightness_fillter.brightness = 0
        return brightness_fillter
    }()
    
    //TODO: 阿宝色
    private lazy var abao_intensity_l: UILabel = {
        let abao_intensity_l = UILabel.init()
        abao_intensity_l.textColor = UIColor.init("#323232")
        abao_intensity_l.font = UIFont.custom(FontName.PFSC_Regular, 15)
        abao_intensity_l.text = LocalizationTool.getStr("metal.lut.abao.intensity")
        abao_intensity_l.textAlignment = .right
        return abao_intensity_l
    }()
    private lazy var abao_intensity_s: UISlider = {
        let abao_intensity_s = UISlider.init(frame: CGRect.zero)
        abao_intensity_s.maximumValue = 5
        abao_intensity_s.minimumValue = 0
        abao_intensity_s.value = 0
        abao_intensity_s.addTarget(self, action: #selector(abaoIntensityChanged(_:)), for: .valueChanged)
        return abao_intensity_s
    }()
    private lazy var abao_fillter: LookupFilter = {
        let abao_fillter = LookupFilter.init()
        abao_fillter.lookupImage = PictureInput.init(image: UIImage.init(named: "lut_abao.png")!)
        abao_fillter.intensity = 0
        return abao_fillter
    }()
    
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
        
        view.addSubview(saturation_l)
        view.addSubview(saturation_s)
        view.addSubview(brightness_l)
        view.addSubview(brightness_s)
        view.addSubview(abao_intensity_l)
        view.addSubview(abao_intensity_s)
        
        setUI()
        
        picture --> saturation_fillter --> brightness_fillter --> abao_fillter --> renderView
        picture.processImage()
    }
    
    private func setUI() {
        
        abao_intensity_l.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(frameMath(10))
            make.centerY.equalTo(view.snp.bottom).offset(-kTabBarBotH-frameMath(20))
        }
        abao_intensity_s.snp.makeConstraints { (make) in
            make.centerY.equalTo(abao_intensity_l.snp.centerY)
            make.left.equalTo(abao_intensity_l.snp.right).offset(frameMath(15))
            make.right.equalTo(view.snp.right).offset(-frameMath(15))
            make.height.equalTo(frameMath(40))
        }
        brightness_l.snp.makeConstraints { (make) in
            make.right.equalTo(abao_intensity_l.snp.right)
            make.centerY.equalTo(abao_intensity_s.snp.top).offset(-frameMath(20))
        }
        brightness_s.snp.makeConstraints { (make) in
            make.centerY.equalTo(brightness_l.snp.centerY)
            make.left.equalTo(abao_intensity_l.snp.right).offset(frameMath(15))
            make.right.equalTo(view.snp.right).offset(-frameMath(15))
            make.height.equalTo(frameMath(40))
        }
        saturation_l.snp.makeConstraints { (make) in
            make.right.equalTo(abao_intensity_l.snp.right)
            make.centerY.equalTo(brightness_s.snp.top).offset(-frameMath(20))
        }
        saturation_s.snp.makeConstraints { (make) in
            make.centerY.equalTo(saturation_l.snp.centerY)
            make.left.equalTo(abao_intensity_l.snp.right).offset(frameMath(15))
            make.right.equalTo(view.snp.right).offset(-frameMath(15))
            make.height.equalTo(frameMath(40))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LookupTableController {
    
    @objc private func saturationChanged(_ sender: UISlider) {
        saturation_fillter.saturation = sender.value
        picture.processImage()
    }
    @objc private func brightnessChanged(_ sender: UISlider) {
        brightness_fillter.brightness = sender.value
        picture.processImage()
    }
    @objc private func abaoIntensityChanged(_ sender: UISlider) {
        abao_fillter.intensity = sender.value
        picture.processImage()
    }
}
