//
//  SegmentController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/13.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class SegmentController: BaseViewController {

    private lazy var camera: Camera = {
        let camera = try! Camera(sessionPreset: AVCaptureSession.Preset.hd1280x720, location: PhysicalCameraLocation.backFacing, captureAsYUV: true)
        camera.delegate = self
        return camera
    }()
    private var picture : PictureInput!
    private var mask: PictureInput!
    private var material: PictureInput!
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
    
    public var type:CameraOrPictureType = .picture {
        didSet {
            
            material = PictureInput.init(imageName: "city_blue1.jpg")
            segment_fillter.materialImage = material
            
            if type == .camera {
                camera --> segment_fillter --> renderView
                camera.startCapture()
            } else {
                picture --> segment_fillter --> renderView
                picture.processImage()
            }
        }
    }
    
    public var picture_name:String = "" {
        didSet {
            
            let image = UIImage.init(named: picture_name)!
            picture = PictureInput.init(image: image)
            
            mask = PictureInput.init(image: image.segmentation()!)
            segment_fillter.maskImage = mask
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(segment_l)
        view.addSubview(segment_s)
        view.addSubview(segment_btn)
        
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
    deinit {
        print("Segment-deinit")
        if type == .camera {
            camera.stopCapture()
        }
        NotificationCenter.default.removeObserver(self)
    }
}

extension SegmentController {
    
    @objc private func alphaChanged(_ sender: UISlider) {
        segment_fillter.alpha = sender.value
        if type == .picture {
            picture.processImage()
        }
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
        if type == .picture {
            picture.processImage()
        }
    }
}

// MARK: - 镜头相关
extension SegmentController: CameraDelegate {
    
    func didCaptureBuffer(_ sampleBuffer: CMSampleBuffer) {
        
        var image = UIImage()
        let cvbuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        guard cvbuffer != nil else {
            fatalError("cvbuffer nil")
        }
        let ciimage = CIImage.init(cvImageBuffer: cvbuffer!).oriented(CGImagePropertyOrientation.right)
        let context = CIContext.init()
        let cgimage = context.createCGImage(ciimage, from: ciimage.extent)
        
        guard cgimage != nil else {
            fatalError("cgimage nil")
        }
        image = UIImage.init(cgImage: cgimage!)
        
        mask = PictureInput.init(image: image.segmentation()!)
        segment_fillter.maskImage = mask
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

