//
//  TikTokController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/17.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

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
    
    //TODO: ImageView
    private lazy var renderView: RenderView = {
        let renderView = RenderView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH-kTabBarBotH-frameMath(60+15)))
        renderView.fillMode = FillMode.preserveAspectRatio
        return renderView
    }()
    private var picture : PictureInput!
    
    public var picture_name:String = "" {
        didSet {
            picture = PictureInput.init(image: UIImage.init(named: picture_name)!)
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
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeFilterTime()
        select_filter_bar.clickItem(0)
    }
    deinit {
        removeFilterTime()
        print("TikTok-deinit")
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
        
        picture.removeAllTargets()
        
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
        
        picture --> renderView
        picture.processImage()
    }
    //TODO: 缩放滤镜
    private func zoomFilterRendering() {
        
        picture --> zoom_fillter --> renderView
        filter_info.setObject(NSNumber(value: true), forKey: zoom_fillter)
        picture.processImage()
        startFilterTime()
    }
    //TODO: 灵魂出窍滤镜
    private func soulOutFilterRendering() {
        
        picture --> soulOut_fillter --> renderView
        filter_info.setObject(NSNumber(value: true), forKey: soulOut_fillter)
        picture.processImage()
        startFilterTime()
    }
    //TODO: 抖动滤镜
    private func shakeFilterRendering() {
        
        picture --> shake_fillter --> renderView
        filter_info.setObject(NSNumber(value: true), forKey: shake_fillter)
        picture.processImage()
        startFilterTime()
    }
    //TODO: 闪白滤镜
    private func flashWhiteFilterRendering() {
        
        picture --> flashWhite_fillter --> renderView
        filter_info.setObject(NSNumber(value: true), forKey: flashWhite_fillter)
        picture.processImage()
        startFilterTime()
    }
    //TODO: 毛刺滤镜
    private func burrFilterRendering() {
        
        picture --> burr_fillter --> renderView
        filter_info.setObject(NSNumber(value: true), forKey: burr_fillter)
        picture.processImage()
        startFilterTime()
    }
    //TODO: 幻觉滤镜
    private func hallucinationFilterRendering() {
        
        picture --> hallucination_fillter --> renderView
        filter_info.setObject(NSNumber(value: true), forKey: hallucination_fillter)
        picture.processImage()
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
        
        picture.processImage()
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
