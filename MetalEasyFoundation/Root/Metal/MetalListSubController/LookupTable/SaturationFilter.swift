//
//  SaturationFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/10.
//  Copyright © 2019 LFZ. All rights reserved.
//

public class SaturationFilter: BasicOperation {
    
    public var saturation: Float = 1.0 {
        didSet {
            uniformSettings[0] = saturation
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "saturationFragment", numberOfInputs: 1)
        uniformSettings.appendUniform(1.0)
    }
}
