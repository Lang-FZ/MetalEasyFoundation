//
//  StretchController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/13.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class StretchController: BaseViewController {

    private lazy var camera: Camera = {
        let camera = try! Camera(sessionPreset: .hd1280x720, location: .backFacing, captureAsYUV: true)
        camera.delegate = self
        return camera
    }()
    private var picture : PictureInput!
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(40+15)))
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
    
    public var type:CameraOrPictureType = .picture {
        didSet {
            if type == .camera {
                camera --> stretch_fillter --> renderView
                camera.startCapture()
            } else {
                picture --> stretch_fillter --> renderView
                picture.processImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(stretch_l)
        view.addSubview(stretch_s)
        
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
    deinit {
        print("Stretch-deinit")
        if type == .camera {
            camera.stopCapture()
        }
        NotificationCenter.default.removeObserver(self)
    }
}

extension StretchController {
    
    @objc private func stretchChanged(_ sender: UISlider) {
        stretch_fillter.heightFactor = sender.value
        if type == .picture {
            picture.processImage()
        }
    }
}

// MARK: - 镜头相关
extension StretchController: CameraDelegate {
    
    func didCaptureBuffer(_ sampleBuffer: CMSampleBuffer) {
        
    }
    
    //TODO: 点击拍照按钮
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
    
    //TODO: 保存图片
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

