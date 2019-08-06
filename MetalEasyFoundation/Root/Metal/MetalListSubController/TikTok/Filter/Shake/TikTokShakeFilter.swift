//
//  TikTokShakeFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class TikTokShakeFilter: BasicOperation {

    public var tikTokShakeTime: Float = 0.0 {
        didSet {
            uniformSettings[0] = tikTokShakeTime
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "tikTokShakeFragment", numberOfInputs: 1)
        uniformSettings.appendUniform(0)
    }
}
