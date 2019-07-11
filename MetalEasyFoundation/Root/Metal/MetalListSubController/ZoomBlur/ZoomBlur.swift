//
//  ZoomBlur.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/11.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation

public class ZoomBlur: BasicOperation {
    
    public var blurSize: Float = 0.0 {
        didSet {
            uniformSettings[0] = blurSize
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "zoomBlurFragment", numberOfInputs: 1)
        uniformSettings.appendUniform(0)
    }
}
