//
//  TikTokSoulOutFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class TikTokSoulOutFilter: BasicOperation {

    public var tikTokSoulOutTime: Float = 0.0 {
        didSet {
            uniformSettings["tikTokSoulOutTime"] = tikTokSoulOutTime
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "tikTokSoulOutFragment", numberOfInputs: 1)
        ({tikTokSoulOutTime = 0.0})()
    }
}
