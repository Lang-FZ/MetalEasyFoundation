//
//  ZoomBlur.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/11.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation

public class MeatlZoomBlur: BasicOperation {
    
    public var blurSize: Float = 0.0 {
        didSet {
            uniformSettings["blurSize"] = blurSize
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "zoomBlurMetalFragment", numberOfInputs: 1)
        ({blurSize = 0.0})()
    }
}
