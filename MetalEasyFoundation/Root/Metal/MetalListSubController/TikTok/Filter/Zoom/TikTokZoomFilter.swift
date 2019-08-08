//
//  TikTokZoomFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/18.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

public class TikTokZoomFilter: BasicOperation {

    public var tikTokZoomTime: Float = 0.0 {
        didSet {
            vertexUniformSettings["tikTokZoomTime"] = tikTokZoomTime
        }
    }
    
    public init() {
        super.init(vertexFunctionName: "tikTokZoomVertex", fragmentFunctionName: "tikTokZoomFragment", numberOfInputs: 1)
        ({tikTokZoomTime = 0.0})()
    }
}
