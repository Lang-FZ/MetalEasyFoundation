//
//  TikTokBurrFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class TikTokBurrFilter: BasicOperation {
    
    public var tikTokBurrTime: Float = 0.0 {
        didSet {
            uniformSettings[0] = tikTokBurrTime
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "tikTokBurrFragment", numberOfInputs: 1)
        uniformSettings.appendUniform(0)
    }
}
