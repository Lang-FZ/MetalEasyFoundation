//
//  TikTokController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/17.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum TikTokFilterType: Int {
    case normal = 0
    case zoom = 1
    case soulOut = 2
    case shake = 3
    case flashWhite = 4
    case burr = 5
    case hallucination = 6
}

class TikTokController: BaseViewController {

    private lazy var filterType:TikTokFilterType = .normal
    private lazy var startTime:TimeInterval = 0
    private lazy var interval:TimeInterval = 0
    private var displayLink: CADisplayLink?
    
    private lazy var camera: Camera = {
        let camera = try! Camera(sessionPreset: AVCaptureSession.Preset.hd1280x720, location: PhysicalCameraLocation.backFacing, captureAsYUV: true)
        camera.delegate = self
        return camera
    }()
    private var picture : PictureInput!
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH-kTabBarBotH-frameMath(60+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    
    private lazy var btn: UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(takePhoto), for: UIControl.Event.touchUpInside)
        
        btn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        btn.center = CGPoint.init(x: kScreenW / 2, y: kScreenH - kNaviBarH - kTabBarBotH - frameMath(20) - 50)
        
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
    
    public var picture_name:String = "" {
        didSet {
            picture = PictureInput.init(image: UIImage.init(named: picture_name)!)
        }
    }
    
    public var type:CameraOrPictureType = .picture {
        didSet {
        }
    }
    
    //TODO: 选择滤镜Bar
    private lazy var select_filter_bar: TikTokSelectFilterdBar = {
        let select_filter_bar = TikTokSelectFilterdBar.init(frame: CGRect.init(x: 0, y: kScreenH-kTabBarBotH-frameMath(60+15), width: kScreenW, height: kTabBarBotH+frameMath(60+15)))
        select_filter_bar.backgroundColor = UIColor.white
        select_filter_bar.click_filter_item = { [weak self] (index) in
            self?.choose_filter(index)
        }
        return select_filter_bar
    }()
    
    //TODO: 维护 滤镜 是否被引用的表
    private lazy var filter_info: NSMapTable<AnyObject, NSNumber> = {
        let filter_info = NSMapTable<AnyObject, NSNumber>.init(keyOptions: [.weakMemory, .objectPointerPersonality], valueOptions: [.weakMemory, .objectPointerPersonality])
        return filter_info
    }()
    
    //TODO: Zoom 滤镜
    private lazy var zoom_fillter: TikTokZoomFilter = {
        let zoom_fillter = TikTokZoomFilter.init()
        zoom_fillter.tikTokZoomTime = 0
        return zoom_fillter
    }()
    
    //TODO: SoulOut 滤镜
    private lazy var soulOut_fillter: TikTokSoulOutFilter = {
        let soulOut_fillter = TikTokSoulOutFilter.init()
        soulOut_fillter.tikTokSoulOutTime = 0
        return soulOut_fillter
    }()
    
    //TODO: Shake 滤镜
    private lazy var shake_fillter: TikTokShakeFilter = {
        let shake_fillter = TikTokShakeFilter.init()
        shake_fillter.tikTokShakeTime = 0
        return shake_fillter
    }()
    
    //TODO: FlashWhite 滤镜
    private lazy var flashWhite_fillter: TikTokFlashWhiteFilter = {
        let flashWhite_fillter = TikTokFlashWhiteFilter.init()
        flashWhite_fillter.tikTokFlashWhiteTime = 0
        return flashWhite_fillter
    }()
    
    //TODO: Burr 滤镜
    private lazy var burr_fillter: TikTokBurrFilter = {
        let burr_fillter = TikTokBurrFilter.init()
        burr_fillter.tikTokBurrTime = 0
        return burr_fillter
    }()
    
    //TODO: Hallucination 滤镜
    private lazy var hallucination_fillter: TikTokHallucinationFilter = {
        let hallucination_fillter = TikTokHallucinationFilter.init()
        hallucination_fillter.tikTokHallucinationTime = 0
        return hallucination_fillter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(renderView)
        view.addSubview(select_filter_bar)
        
        if type == .camera {
            view.addSubview(btn)
            view.addSubview(transfer_lens)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeFilterTime()
        select_filter_bar.clickItem(0)
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
    deinit {
        print("TikTok-deinit")
        removeFilterTime()
        if type == .camera {
            camera.stopCapture()
        }
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 切换滤镜

extension TikTokController {
    
    //TODO: 切换滤镜
    private func choose_filter(_ index:Int) {
        
        removeFilterTime()
        removeAllTargetSources()
        
        switch index {
            
        case TikTokFilterType.normal.rawValue:
            filterType = .normal
            normalRendering()
        case TikTokFilterType.zoom.rawValue:
            filterType = .zoom
            zoomFilterRendering()
        case TikTokFilterType.soulOut.rawValue:
            filterType = .soulOut
            soulOutFilterRendering()
        case TikTokFilterType.shake.rawValue:
            filterType = .shake
            shakeFilterRendering()
        case TikTokFilterType.flashWhite.rawValue:
            filterType = .flashWhite
            flashWhiteFilterRendering()
        case TikTokFilterType.burr.rawValue:
            filterType = .burr
            burrFilterRendering()
        case TikTokFilterType.hallucination.rawValue:
            filterType = .hallucination
            hallucinationFilterRendering()
        default:
            filterType = .normal
            normalRendering()
        }
    }
    //TODO: 删除被引用的滤镜 sources、targets
    private func removeAllTargetSources() {
        
        if type == .camera {
            camera.removeAllTargets()
        } else {
            picture.removeAllTargets()
        }
        
        if filter_info.object(forKey: zoom_fillter)?.boolValue ?? false {
            zoom_fillter.tikTokZoomTime = 0
            zoom_fillter.sources.sources = [:]
            zoom_fillter.removeAllTargets()
            filter_info.setObject(NSNumber(value: false), forKey: zoom_fillter)
        }
        
        if filter_info.object(forKey: soulOut_fillter)?.boolValue ?? false {
            soulOut_fillter.tikTokSoulOutTime = 0
            soulOut_fillter.sources.sources = [:]
            soulOut_fillter.removeAllTargets()
            filter_info.setObject(NSNumber(value: false), forKey: soulOut_fillter)
        }
        
        if filter_info.object(forKey: shake_fillter)?.boolValue ?? false {
            shake_fillter.tikTokShakeTime = 0
            shake_fillter.sources.sources = [:]
            shake_fillter.removeAllTargets()
            filter_info.setObject(NSNumber(value: false), forKey: shake_fillter)
        }
        
        if filter_info.object(forKey: flashWhite_fillter)?.boolValue ?? false {
            flashWhite_fillter.tikTokFlashWhiteTime = 0
            flashWhite_fillter.sources.sources = [:]
            flashWhite_fillter.removeAllTargets()
            filter_info.setObject(NSNumber(value: false), forKey: flashWhite_fillter)
        }
        
        if filter_info.object(forKey: burr_fillter)?.boolValue ?? false {
            burr_fillter.tikTokBurrTime = 0
            burr_fillter.sources.sources = [:]
            burr_fillter.removeAllTargets()
            filter_info.setObject(NSNumber(value: false), forKey: burr_fillter)
        }
        
        if filter_info.object(forKey: hallucination_fillter)?.boolValue ?? false {
            hallucination_fillter.tikTokHallucinationTime = 0
            hallucination_fillter.sources.sources = [:]
            hallucination_fillter.removeAllTargets()
            filter_info.setObject(NSNumber(value: false), forKey: hallucination_fillter)
        }
        
        renderView.sources.sources = [:]
    }
    //TODO: 无滤镜
    private func normalRendering() {
        
        if type == .camera {
            camera --> renderView
            camera.startCapture()
        } else {
            picture --> renderView
            picture.processImage()
        }
    }
    //TODO: 缩放滤镜
    private func zoomFilterRendering() {
        
        filter_info.setObject(NSNumber(value: true), forKey: zoom_fillter)
        
        if type == .camera {
            camera --> zoom_fillter --> renderView
            camera.startCapture()
        } else {
            picture --> zoom_fillter --> renderView
            picture.processImage()
        }
        startFilterTime()
    }
    //TODO: 灵魂出窍滤镜
    private func soulOutFilterRendering() {
        
        filter_info.setObject(NSNumber(value: true), forKey: soulOut_fillter)
        
        if type == .camera {
            camera --> soulOut_fillter --> renderView
            camera.startCapture()
        } else {
            picture --> soulOut_fillter --> renderView
            picture.processImage()
        }
        startFilterTime()
    }
    //TODO: 抖动滤镜
    private func shakeFilterRendering() {
        
        filter_info.setObject(NSNumber(value: true), forKey: shake_fillter)
        
        if type == .camera {
            camera --> shake_fillter --> renderView
            camera.startCapture()
        } else {
            picture --> shake_fillter --> renderView
            picture.processImage()
        }
        startFilterTime()
    }
    //TODO: 闪白滤镜
    private func flashWhiteFilterRendering() {
        
        filter_info.setObject(NSNumber(value: true), forKey: flashWhite_fillter)
        
        if type == .camera {
            camera --> flashWhite_fillter --> renderView
            camera.startCapture()
        } else {
            picture --> flashWhite_fillter --> renderView
            picture.processImage()
        }
        startFilterTime()
    }
    //TODO: 毛刺滤镜
    private func burrFilterRendering() {
        
        filter_info.setObject(NSNumber(value: true), forKey: burr_fillter)
        
        if type == .camera {
            camera --> burr_fillter --> renderView
            camera.startCapture()
        } else {
            picture --> burr_fillter --> renderView
            picture.processImage()
        }
        startFilterTime()
    }
    //TODO: 幻觉滤镜
    private func hallucinationFilterRendering() {
        
        filter_info.setObject(NSNumber(value: true), forKey: hallucination_fillter)
        
        if type == .camera {
            camera --> hallucination_fillter --> renderView
            camera.startCapture()
        } else {
            picture --> hallucination_fillter --> renderView
            picture.processImage()
        }
        startFilterTime()
    }
}

// MARK: - 定时器

extension TikTokController {
    
    //TODO: 刷新
    @objc private func filterDisplay() {
        
        if displayLink == nil {
            return
        }
        
        interval = Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate - startTime
        
        switch filterType {
            
        case .zoom:
            zoom_fillter.tikTokZoomTime = Float(interval)
        case .soulOut:
            soulOut_fillter.tikTokSoulOutTime = Float(interval)
        case .shake:
            shake_fillter.tikTokShakeTime = Float(interval)
        case .flashWhite:
            flashWhite_fillter.tikTokFlashWhiteTime = Float(interval)
        case .burr:
            burr_fillter.tikTokBurrTime = Float(interval)
        case .hallucination:
            hallucination_fillter.tikTokHallucinationTime = Float(interval)
        case .normal:
            normalRendering()
        }
        
        if type == .picture {
            picture.processImage()
        }
    }
    //TODO: 开启
    private func startFilterTime() {
        startTime = Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate
        interval = 0
        
        displayLink = CADisplayLink.init(target: self, selector: #selector(filterDisplay))
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    //TODO: 移除
    private func removeFilterTime() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
        displayLink = nil
        
        startTime = 0
        interval = 0
    }
}

// MARK: - 镜头相关
extension TikTokController: CameraDelegate {
    
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

