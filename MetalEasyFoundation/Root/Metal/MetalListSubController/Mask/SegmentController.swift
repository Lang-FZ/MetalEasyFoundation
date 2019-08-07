//
//  SegmentController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/13.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class SegmentController: BaseViewController {

    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(40+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private var mask: PictureInput!
    private var picture : PictureInput!
    private var material: PictureInput!
    
    private lazy var segment_l: UILabel = {
        let segment_l = UILabel.init()
        segment_l.textColor = UIColor.init("#323232")
        segment_l.font = UIFont.custom(FontName.PFSC_Regular, 15)
        segment_l.text = LocalizationTool.getStr("metal.mask.segment.slider.title")
        segment_l.textAlignment = .right
        return segment_l
    }()
    private lazy var segment_s: UISlider = {
        let segment_s = UISlider.init(frame: CGRect.zero)
        segment_s.maximumValue = 1
        segment_s.minimumValue = 0
        segment_s.value = 0
        segment_s.addTarget(self, action: #selector(alphaChanged(_:)), for: .valueChanged)
        return segment_s
    }()
    private lazy var segment_btn: UIButton = {
        let segment_btn = UIButton.init(type: .custom)
        segment_btn.setTitle(LocalizationTool.getStr("metal.mask.segment.slider.btn"), for: .normal)
        segment_btn.setTitleColor(UIColor.init("#323232"), for: .normal)
        segment_btn.titleLabel?.font = UIFont.custom(FontName.PFSC_Regular, 15)
        segment_btn.addTarget(self, action: #selector(pictureChanged), for: .touchUpInside)
        return segment_btn
    }()
    private lazy var segment_fillter: SegmentFilter = {
        let segment_fillter = SegmentFilter.init()
        return segment_fillter
    }()
    
    public var picture_name:String = "" {
        didSet {
            
            let image = UIImage.init(named: picture_name)!
            picture = PictureInput.init(image: image)
            mask = PictureInput.init(image: image.segmentation()!)
            material = PictureInput.init(imageName: "city_blue1.jpg")
            
            segment_fillter.maskImage = mask
            segment_fillter.materialImage = material
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(segment_l)
        view.addSubview(segment_s)
        view.addSubview(segment_btn)
        
        setUI()
        
        picture --> segment_fillter --> renderView
        picture.processImage()
    }
    
    private func setUI() {
        
        segment_l.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(frameMath(15))
            make.centerY.equalTo(view.snp.bottom).offset(-kTabBarBotH-frameMath(20))
        }
        segment_btn.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(frameMath(-15))
            make.centerY.equalTo(segment_l.snp.centerY)
        }
        segment_s.snp.makeConstraints { (make) in
            make.centerY.equalTo(segment_l.snp.centerY)
            make.left.equalTo(segment_l.snp.right).offset(frameMath(10))
            make.right.equalTo(segment_btn.snp.left).offset(-frameMath(10))
            make.height.equalTo(frameMath(40))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SegmentController {
    
    @objc private func alphaChanged(_ sender: UISlider) {
        segment_fillter.alpha = sender.value
        picture.processImage()
    }
    @objc private func pictureChanged() {
        
        let picture = SelectPicturesController()
        
        picture.selected_picture = { [weak self] (picture_name) in
            picture.navigationController?.popViewController(animated: true)
            self?.changePicture(picture_name)
        }
        
        navigationController?.pushViewController(picture, animated: true)
    }
    private func changePicture(_ image_name:String) {
        segment_fillter.materialImage = PictureInput.init(imageName: image_name)
        picture.processImage()
    }
}
