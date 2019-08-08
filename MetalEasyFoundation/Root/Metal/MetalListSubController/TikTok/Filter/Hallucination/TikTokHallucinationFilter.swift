//
//  TikTokHallucinationFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class TikTokHallucinationFilter: BasicOperation {

    public var tikTokHallucinationTime: Float = 0.0 {
        didSet {
            uniformSettings["tikTokHallucinationTime"] = tikTokHallucinationTime
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "tikTokHallucinationFragment", numberOfInputs: 1)
        ({tikTokHallucinationTime = 0.0})()
    }
}

