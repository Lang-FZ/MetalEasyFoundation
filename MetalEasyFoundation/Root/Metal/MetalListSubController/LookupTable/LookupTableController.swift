//
//  LookupTableController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/9.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class LookupTableController: BaseViewController {
    
    // MARK: - 懒加载
    private lazy var camera: Camera = {
        let camera = try! Camera(sessionPreset: AVCaptureSession.Preset.hd1280x720, location: PhysicalCameraLocation.backFacing, captureAsYUV: true)
        camera.delegate = self
        return camera
    }()
    private var picture : PictureInput!
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(120+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    
    private lazy var btn: UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(takePhoto), for: UIControl.Event.touchUpInside)
        
        btn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        btn.center = CGPoint.init(x: kScreenW / 2, y: kScreenH - kNaviBarH - kTabBarBotH - frameMath(80) - 50)
        
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 40
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        btn.layer.transform = CATransform3DTranslate(btn.layer.transform, 0, 0, 10)
        
        return btn
    }()
    lazy var transfer_lens: UIImageView = {
        let transfer_lens = UIImageView(frame: CGRect(x: kScreenW-50, y: kNaviBarH+20, width: 30, height: 30))
        transfer_lens.image = UIImage.init(named: "transfer_lens")
        transfer_lens.isUserInteractionEnabled = true
        transfer_lens.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(transferLens)))
        return transfer_lens
    }()
    @objc private func transferLens() {
        
        if camera.location == .backFacing {
            camera.location = .frontFacing
        } else {
            camera.location = .backFacing
        }
    }
    
    // MARK: 饱和度
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
    
    // MARK: 亮度
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
    
    // MARK: 阿宝色
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
    
    public var type:CameraOrPictureType = .picture {
        didSet {
            if type == .camera {
                camera --> saturation_fillter --> brightness_fillter --> abao_fillter --> renderView
                camera.startCapture()
            } else {
                picture --> saturation_fillter --> brightness_fillter --> abao_fillter --> renderView
                picture.processImage()
            }
        }
    }
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(saturation_l)
        view.addSubview(saturation_s)
        view.addSubview(brightness_l)
        view.addSubview(brightness_s)
        view.addSubview(abao_intensity_l)
        view.addSubview(abao_intensity_s)
        
        if type == .camera {
            view.addSubview(btn)
            view.addSubview(transfer_lens)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        setUI()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if type == .camera {
            camera.stopCapture()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == .camera {
            camera.startCapture()
        }
    }
    @objc private func becomeActive() {
        if type == .camera {
            camera.startCapture()
        }
    }
    @objc private func resignActive() {
        if type == .camera {
            camera.stopCapture()
        }
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
    deinit {
        print("LUT-deinit")
        if type == .camera {
            camera.stopCapture()
        }
        NotificationCenter.default.removeObserver(self)
    }
}

extension LookupTableController {
    
    @objc private func saturationChanged(_ sender: UISlider) {
        saturation_fillter.saturation = sender.value
        if type == .picture {
            picture.processImage()
        }
    }
    @objc private func brightnessChanged(_ sender: UISlider) {
        brightness_fillter.brightness = sender.value
        if type == .picture {
            picture.processImage()
        }
    }
    @objc private func abaoIntensityChanged(_ sender: UISlider) {
        abao_fillter.intensity = sender.value
        if type == .picture {
            picture.processImage()
        }
    }
}

// MARK: - 镜头相关
extension LookupTableController: CameraDelegate {
    
    func didCaptureBuffer(_ sampleBuffer: CMSampleBuffer) {
        
    }
    
    // MARK: 点击拍照按钮
    @objc private func takePhoto() {
        camera.stopCapture()
        self.showLoading()
        
        let image = renderView.currentTexture?.texture.toUIImage() ?? UIImage()
        
        let oldStatus = PHPhotoLibrary.authorizationStatus()
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            
            if status == .denied {
                
                if oldStatus != .denied {
                    self?.showSuccessHud("请允许访问相册", have_words: true, seconds: 2, timeHidden: true, hasImage: false) {
                    }
                } else {
                    
                }
            } else if status == .authorized {
                
                self?.saveImageToPhotoCollection(image)
                
            } else if status == .restricted {
                
                self?.showSuccessHud("系统原因不能访问相册", have_words: true, seconds: 2, timeHidden: true, hasImage: false) {
                }
            }
        }
        
        DispatchQueue.main.async {
            self.dismissLoading()
            self.camera.startCapture()
        }
    }
    
    // MARK: 保存图片
    private func saveImageToPhotoCollection(_ image:UIImage) {
        
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            }
        } catch {
            fatalError("保存图片出错")
        }
        
        DispatchQueue.main.async {
            self.dismissLoading()
            self.camera.startCapture()
        }
    }
}

