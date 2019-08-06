//
//  TikTokFlashWhiteFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class TikTokFlashWhiteFilter: BasicOperation {
    
    public var tikTokFlashWhiteTime: Float = 0.0 {
        didSet {
            uniformSettings[0] = tikTokFlashWhiteTime
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "tikTokFlashWhiteFragment", numberOfInputs: 1)
        uniformSettings.appendUniform(0)
    }
}
