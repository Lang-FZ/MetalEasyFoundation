//
//  TestCameraController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/8.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation

class TestCameraController: BaseViewController {
    
    // MARK: - 懒加载

    private lazy var camera: Camera = {
        let camera = try! Camera(sessionPreset: AVCaptureSession.Preset.hd1920x1080, location: PhysicalCameraLocation.backFacing, captureAsYUV: true)
        camera.delegate = self
        return camera
    }()
    private lazy var emboss: EmbossFilter = {
        let emboss = EmbossFilter()
        emboss.intensity = 3
        return emboss
    }()
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(40+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    
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
    private lazy var zoom_blur_fillter: MeatlZoomBlur = {
        let zoom_blur_fillter = MeatlZoomBlur.init()
        zoom_blur_fillter.blurSize = 0
        return zoom_blur_fillter
    }()
    
    private lazy var btn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("拍照", for: .normal)
        btn.setTitleColor(UIColor.purple, for: .normal)
        btn.titleLabel?.font = UIFont.custom(FontName.PFSC_Regular, 20)
        btn.backgroundColor = UIColor.orange
        btn.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        btn.center = CGPoint.init(x: kScreenW / 2, y: kScreenH - kTabBarBotH - 50)
        btn.addTarget(self, action: #selector(takePhoto), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
//        view.addSubview(btn)
        
        view.addSubview(zoom_blur_l)
        view.addSubview(zoom_blur_s)
        
        setUI()
        
//        camera --> emboss --> renderView
        camera --> zoom_blur_fillter --> renderView
        camera.startCapture()
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
    deinit {
        print("TestCamera-deinit")
    }
}

extension TestCameraController: CameraDelegate {
    
    func didCaptureBuffer(_ sampleBuffer: CMSampleBuffer) {
//        print("didCaptureBuffer")
    }
    
    @objc private func takePhoto() {
        print("takePhoto")
        camera.stopCapture()
    }
}

extension TestCameraController {
    
    @objc private func zoomBlurChanged(_ sender: UISlider) {
        zoom_blur_fillter.blurSize = sender.value
//        picture.processImage()
    }
}
