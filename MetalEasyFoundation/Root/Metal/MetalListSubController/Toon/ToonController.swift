//
//  ToonController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/12.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ToonController: BaseViewController {

    private lazy var camera: Camera = {
        let camera = try! Camera(sessionPreset: AVCaptureSession.Preset.hd1280x720, location: PhysicalCameraLocation.backFacing, captureAsYUV: true)
        camera.delegate = self
        return camera
    }()
    private var picture : PictureInput!
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(80+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    
    private lazy var btn: UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(takePhoto), for: UIControl.Event.touchUpInside)
        
        btn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        btn.center = CGPoint.init(x: kScreenW / 2, y: kScreenH - kNaviBarH - kTabBarBotH - frameMath(40) - 50)
        
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
    
    public var type:CameraOrPictureType = .picture {
        didSet {
            if type == .camera {
                camera --> toon_fillter --> renderView
                camera.startCapture()
            } else {
                picture --> toon_fillter --> renderView
                picture.processImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(toon_magtol_l)
        view.addSubview(toon_magtol_s)
        view.addSubview(toon_quantize_l)
        view.addSubview(toon_quantize_s)
        
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
    deinit {
        print("Toon-deinit")
        if type == .camera {
            camera.stopCapture()
        }
        NotificationCenter.default.removeObserver(self)
    }
}

extension ToonController {
    
    @objc private func toonMagtolChanged(_ sender: UISlider) {
        toon_fillter.magtol = sender.value
        if type == .picture {
            picture.processImage()
        }
    }
    @objc private func toonQuantizeChanged(_ sender: UISlider) {
        toon_fillter.quantize = sender.value
        if type == .picture {        
            picture.processImage()
        }
    }
}

// MARK: - 镜头相关
extension ToonController: CameraDelegate {
    
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
