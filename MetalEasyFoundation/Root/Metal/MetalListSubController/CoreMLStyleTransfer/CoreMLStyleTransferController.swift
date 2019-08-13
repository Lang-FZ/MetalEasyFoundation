//
//  CoreMLStyleTransferController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/12.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import CoreML
import AVFoundation
import Photos

class CoreMLStyleTransferController: BaseViewController {

    let imageSize = 720
    var model_index = 10

    private let models = [
        mosaic().model,
        the_scream().model,
        udnie().model,
        candy().model
    ]
    
    private lazy var camera: Camera = {
        let camera = try! Camera(sessionPreset: AVCaptureSession.Preset.hd1280x720, location: PhysicalCameraLocation.backFacing, captureAsYUV: true)
        camera.delegate = self
        return camera
    }()
    private var picture : PictureInput!
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH - kNaviBarH - kTabBarBotH - frameMath(40)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private lazy var styleTransfer_fillter: StyleTransferFilter = {
        let styleTransfer_fillter = StyleTransferFilter.init()
        return styleTransfer_fillter
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
    
    private lazy var select_btn: UIButton = {
        let select_btn = UIButton.init(type: .custom)
        select_btn.frame = CGRect.init(x: 0, y: kScreenH-kTabBarBotH-frameMath(40), width: kScreenW, height: frameMath(40)+kTabBarBotH)
        select_btn.setTitle(LocalizationTool.getStr("metal.style.transfer.btn.title"), for: .normal)
        select_btn.setTitleColor(UIColor.init("#969696"), for: .normal)
        select_btn.titleLabel?.font = UIFont.custom(FontName.PFSC_Regular, 15)
        select_btn.backgroundColor = UIColor.white
        select_btn.addTarget(self, action: #selector(select_ml_model), for: .touchUpInside)
        return select_btn
    }()
    
    private lazy var input_image: UIImage = {
        let input_image = UIImage.init()
        return input_image
    }()
    public var picture_name:String = "" {
        didSet {
            input_image = UIImage.init(named: picture_name) ?? UIImage.init()
            picture = PictureInput.init(image: input_image)
        }
    }
    
    public var type:CameraOrPictureType = .picture {
        didSet {
            
            if type == .camera {
                styleTransfer_fillter.modelTexture = PictureInput.init(image: UIImage.createImageWithColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0), renderView.frame))
                camera --> styleTransfer_fillter --> renderView
                camera.startCapture()
            } else {
                styleTransfer_fillter.modelTexture = PictureInput.init(image: input_image)
                picture --> styleTransfer_fillter --> renderView
                picture.processImage()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor("F0F0F0")
        
        view.addSubview(renderView)
        view.addSubview(select_btn)
        if type == .camera {
            view.addSubview(btn)
            view.addSubview(transfer_lens)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive), name: UIApplication.willResignActiveNotification, object: nil)
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
    @objc private func select_ml_model() {
        
        let cyclePageModel = CyclePagePhotoModel.init()
        
        let model1 = CyclePagePhotoModel()
        model1.photoName = "mosaic.jpg"
        
        let model2 = CyclePagePhotoModel()
        model2.photoName = "the_scream.jpg"
        
        let model3 = CyclePagePhotoModel()
        model3.photoName = "udnie.jpg"
        
        let model4 = CyclePagePhotoModel()
        model4.photoName = "candy.jpg"
        
        cyclePageModel.photoData.append(model1)
        cyclePageModel.photoData.append(model2)
        cyclePageModel.photoData.append(model3)
        cyclePageModel.photoData.append(model4)
        
        let cyclePageVC:CyclePageController = CyclePageController.init(.waterfall_flow)
        cyclePageVC.is_call_back = true
        cyclePageVC.direction = .vertical
        cyclePageVC.data = cyclePageModel
        cyclePageVC.modalPresentationStyle = UIModalPresentationStyle.custom
        
        cyclePageVC.click_index = { [weak self] (index) in
            self?.model_index = index
            self?.replace_image(index)
        }
        
        self.present(cyclePageVC, animated: true, completion: nil)
    }
    
    private func replace_image(_ index:Int) {
        
        guard let image = input_image.scaled(to: CGSize.init(width: imageSize, height: imageSize), scalingMode: UIImage.ScalingMode.aspectFit).cgImage else {
            print("CGImage Error")
            return
        }
        
        self.showLoading()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let stylized = self.stylizeImage(cgImage: image, model: self.models[index])
            
            DispatchQueue.main.async {
                
                self.renderingWithImage(stylized)
            }
        }
    }
    
    private func renderingWithImage(_ cgimage:CGImage) {
        
        styleTransfer_fillter.modelTexture = PictureInput.init(image: UIImage.init(cgImage: cgimage))
        if type == .picture {
            picture.processImage()
        }
        dismissLoading()
    }
    
    private func stylizeImage(cgImage: CGImage, model: MLModel) -> CGImage {
        
        let input = StyleTransferInput.init(input: pixelBuffer(cgImage: cgImage, width: imageSize, height: imageSize))
        let outFeatures = try! model.prediction(from: input)
        let output = outFeatures.featureValue(for: "outputImage")!.imageBufferValue!
        
        CVPixelBufferLockBaseAddress(output, .readOnly)
        
        let width = CVPixelBufferGetWidth(output)
        let height = CVPixelBufferGetHeight(output)
        let data = CVPixelBufferGetBaseAddress(output)!
        
        let outContext = CGContext.init(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(output), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)!
        
        var image_rect:CGRect = CGRect.zero
        
        if input_image.size.height / input_image.size.width >= CGFloat(height) / CGFloat(width) {
            image_rect = CGRect(x: (CGFloat(height) - input_image.size.width / input_image.size.height * CGFloat(height)) / 2, y: 0, width: (input_image.size.width / input_image.size.height * CGFloat(height)), height: CGFloat(height))
        } else {
            image_rect = CGRect(x: 0, y: ( CGFloat(height) - (input_image.size.height / input_image.size.width * CGFloat(width)) )/2, width: CGFloat(width), height: input_image.size.height / input_image.size.width * CGFloat(width))
        }
        
        let outImage = outContext.makeImage()!
        CVPixelBufferUnlockBaseAddress(output, .readOnly)
        let new_out = outImage.cropping(to: image_rect)!
        
        return new_out
    }
    
    private func pixelBuffer(cgImage: CGImage, width: Int, height: Int) -> CVPixelBuffer {
        
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            fatalError("Cannot create pixel buffer for image")
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)
        let context = CGContext.init(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        
        return pixelBuffer!
    }
    
    deinit {
        print("CoreMLStyleTransfer-deinit")
        if type == .camera {
            camera.stopCapture()
        }
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 镜头相关
extension CoreMLStyleTransferController: CameraDelegate {
    
    func didCaptureBuffer(_ sampleBuffer: CMSampleBuffer) {
        
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
        input_image = UIImage.init(cgImage: cgimage!)
        
        if model_index < 10 {
            DispatchQueue.main.async {
                self.replace_image(self.model_index)
            }
        }
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

