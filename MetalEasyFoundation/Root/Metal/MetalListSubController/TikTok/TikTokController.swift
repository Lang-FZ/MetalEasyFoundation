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
    
    //TODO: 滤镜
    private lazy var zoom_fillter: TikTokZoomFilter = {
        let zoom_fillter = TikTokZoomFilter.init()
        zoom_fillter.tikTokZoomTime = 0
        return zoom_fillter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init("#F0F0F0")
        view.addSubview(renderView)
        view.addSubview(select_filter_bar)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeFilterTime()
    }
    deinit {
        removeFilterTime()
    }
}

// MARK: - 切换滤镜

extension TikTokController {
    
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
    
    private func removeAllTargetSources() {
        picture.removeAllTargets()
        
        zoom_fillter.tikTokZoomTime = 0
        zoom_fillter.sources.sources = [:]
        zoom_fillter.removeAllTargets()
        
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
        picture.processImage()
        startFilterTime()
    }
    
    //TODO: 灵魂出窍滤镜
    private func soulOutFilterRendering() {
        
    }
    
    //TODO: 抖动滤镜
    private func shakeFilterRendering() {
        
    }
    
    //TODO: 闪白滤镜
    private func flashWhiteFilterRendering() {
        
    }
    
    //TODO: 毛刺滤镜
    private func burrFilterRendering() {
        
    }
    
    //TODO: 幻觉滤镜
    private func hallucinationFilterRendering() {
        
    }
}

// MARK: - 滤镜动效

extension TikTokController {
    
    
}

// MARK: - 定时器

extension TikTokController {
    
    //TODO: 刷新
    @objc private func filterDisplay() {
        
        if displayLink == nil {
            return
        }
        
        interval = Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate - startTime
        print("\(interval)")
        
        switch filterType {
            
        case .zoom:
            zoom_fillter.tikTokZoomTime = Float(interval)
        case .soulOut:
            print("soulOut")
        case .shake:
            print("shake")
        case .flashWhite:
            print("flashWhite")
        case .burr:
            print("burr")
        case .hallucination:
            print("hallucination")
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
