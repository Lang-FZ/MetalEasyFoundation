//
//  SegmentFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/13.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation

public class SegmentFilter: BasicOperation {

    public var alpha: Float = 0.0 {
        didSet {
            uniformSettings["alpha"] = alpha
        }
    }
    
    public var maskImage: PictureInput? {
        didSet {
            maskImage?.addTarget(self, atTargetIndex: 1)
            maskImage?.processImage()
        }
    }
    
    public var materialImage: PictureInput? {
        didSet {
            materialImage?.addTarget(self, atTargetIndex: 2)
            materialImage?.processImage()
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "segmentFragment", numberOfInputs: 3)
        ({alpha = 0.0})()
    }
}
