//
//  ZoomBlurController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/11.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ZoomBlurController: BaseViewController {
    
    // MARK: - 懒加载
    private var picture : PictureInput!
    private lazy var camera: Camera = {
        let camera = try! Camera(sessionPreset: AVCaptureSession.Preset.hd4K3840x2160, location: PhysicalCameraLocation.backFacing, captureAsYUV: true)
        camera.delegate = self
        return camera
    }()
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
        btn.center = CGPoint.init(x: kScreenW / 2, y: kScreenH - kNaviBarH - kTabBarBotH - 50)
        
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 40
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        btn.layer.transform = CATransform3DTranslate(btn.layer.transform, 0, 0, 10)
        
        return btn
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
    
    public var picture_name:String = "" {
        didSet {
            picture = PictureInput.init(image: UIImage.init(named: picture_name)!)
        }
    }
    
    public var type:CameraOrPictureType = .picture {
        didSet {
            if type == .camera {
                camera --> zoom_blur_fillter --> renderView
                camera.startCapture()
            } else {
                picture --> zoom_blur_fillter --> renderView
                picture.processImage()
            }
        }
    }
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(renderView)
        
        view.addSubview(zoom_blur_l)
        view.addSubview(zoom_blur_s)
        
        if type == .camera {
            view.addSubview(btn)
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
        print("ZoomBlur-deinit")
        if type == .camera {
            camera.stopCapture()
        }
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 滤镜改参数
extension ZoomBlurController {
    
    @objc private func zoomBlurChanged(_ sender: UISlider) {
        zoom_blur_fillter.blurSize = sender.value
        if type == .picture {
            picture.processImage()
        }
    }
}

// MARK: - 镜头相关
extension ZoomBlurController: CameraDelegate {
    
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

/*
@objc private func takePhoto() {
    camera.stopCapture()
    self.showLoading()
    
    guard temp_buffer != nil else {
        fatalError("CMSampleBuffer nil")
    }
    
    var image = UIImage()
    let cvbuffer = CMSampleBufferGetImageBuffer(temp_buffer!)
    
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
    
    let oldStatus = PHPhotoLibrary.authorizationStatus()
    PHPhotoLibrary.requestAuthorization { (status) in
        
        if status == .denied {
            
            if oldStatus != .denied {
                self.showSuccessHud("请允许访问相册", have_words: true, seconds: 2, timeHidden: true, hasImage: false) {
                }
            } else {
                
            }
        } else if status == .authorized {
            
            self.saveImageToPhotoCollection(image)
            
        } else if status == .restricted {
            
            self.showSuccessHud("系统原因不能访问相册", have_words: true, seconds: 2, timeHidden: true, hasImage: false) {
            }
        }
    }
}

private func getCollection() -> PHAssetCollection {
    
    var created_collection:PHAssetCollection? = nil
    let collectionResult:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
    let app_name = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    
    collectionResult.enumerateObjects { (collection, index, bool) in
        if collection.localizedTitle == app_name {
            created_collection = collection
        }
    }
    
    if created_collection != nil {
        return created_collection!
    }
    
    var collection_id:String? = nil
    do {
        try PHPhotoLibrary.shared().performChangesAndWait {
            collection_id = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: app_name).placeholderForCreatedAssetCollection.localIdentifier
        }
    } catch {
        fatalError("保存图片出错")
    }
    
    return PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collection_id ?? ""], options: nil).firstObject!
}
 */
