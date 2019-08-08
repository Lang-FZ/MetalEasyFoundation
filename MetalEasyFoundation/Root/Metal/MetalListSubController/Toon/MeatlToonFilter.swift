//
//  ToonFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/12.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation

public class MeatlToonFilter: BasicOperation {

    public var magtol: Float = 0.5 {
        didSet {
            uniformSettings["magtol"] = magtol
        }
    }
    public var quantize: Float = 10.0 {
        didSet {
            uniformSettings["quantize"] = quantize
        }
    }
    
    
    public init() {
        super.init(fragmentFunctionName: "toonMetalFragment", numberOfInputs: 1)
        
        ({magtol = 0.5})()
        ({quantize = 10.0})()
    }
}
