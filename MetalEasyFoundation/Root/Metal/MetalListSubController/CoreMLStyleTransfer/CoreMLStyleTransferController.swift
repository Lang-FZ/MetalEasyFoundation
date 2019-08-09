//
//  CoreMLStyleTransferController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/12.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import CoreML

class CoreMLStyleTransferController: BaseViewController {

    let imageSize = 720

    private let models = [
        mosaic().model,
        the_scream().model,
        udnie().model,
        candy().model
    ]
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH-kTabBarBotH-frameMath(40)))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    private lazy var input_image: UIImage = {
        let input_image = UIImage.init()
        return input_image
    }()
    public var picture_name:String = "" {
        didSet {
            input_image = UIImage.init(named: picture_name) ?? UIImage.init()
            imageView.image = input_image
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor("F0F0F0")
        
        view.addSubview(imageView)
        view.addSubview(select_btn)
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
                
                self.dismissLoading()
                self.imageView.image = UIImage.init(cgImage: stylized)
            }
        }
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
        
        let outImage = outContext.makeImage()!
        CVPixelBufferUnlockBaseAddress(output, .readOnly)
        
        return outImage
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
    }
}
