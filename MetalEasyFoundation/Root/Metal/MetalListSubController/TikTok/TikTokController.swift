//
//  TikTokController.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/17.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class TikTokController: BaseViewController {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init("#F0F0F0")
        view.addSubview(renderView)
        view.addSubview(select_filter_bar)
    }
}

// MARK: - 切换滤镜

extension TikTokController {
    
    private func choose_filter(_ index:Int) {
        
        switch index {
        case 0:
            normalRendering()
        case 1:
            zoomFilterRendering()
        case 2:
            soulOutFilterRendering()
        case 3:
            shakeFilterRendering()
        case 4:
            flashWhiteFilterRendering()
        case 5:
            burrFilterRendering()
        case 6:
            hallucinationFilterRendering()
        default:
            normalRendering()
        }
    }
    
    private func removeAllTargetSources() {
        picture.removeAllTargets()
        
//        zoom_blur_fillter.sources.sources = [:]
        renderView.sources.sources = [:]
    }
    
    //TODO: 无滤镜
    private func normalRendering() {
        removeAllTargetSources()
        picture --> renderView
        picture.processImage()
    }
    
    //TODO: 缩放滤镜
    private func zoomFilterRendering() {
        removeAllTargetSources()
        
    }
    
    //TODO: 灵魂出窍滤镜
    private func soulOutFilterRendering() {
        removeAllTargetSources()
        
    }
    
    //TODO: 抖动滤镜
    private func shakeFilterRendering() {
        removeAllTargetSources()
        
    }
    
    //TODO: 闪白滤镜
    private func flashWhiteFilterRendering() {
        removeAllTargetSources()
        
    }
    
    //TODO: 毛刺滤镜
    private func burrFilterRendering() {
        removeAllTargetSources()
        
    }
    
    //TODO: 幻觉滤镜
    private func hallucinationFilterRendering() {
        removeAllTargetSources()
        
    }
}

// MARK: - 滤镜动效

extension TikTokController {
    
    
}
