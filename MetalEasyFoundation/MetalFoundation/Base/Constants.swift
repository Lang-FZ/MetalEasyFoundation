//
//  Constants.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/4.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation
import Metal

public let standardImageVertices: [Float] = [-1, -1, 1, -1, -1, 1, 1, 1]
public let verticallyInvertedImageVertices: [Float] = [-1, 1, 1, 1, -1, -1, 1, -1]
public let standardTextureCoordinates: [Float] = [0, 0, 1, 0, 0, 1, 1, 1,]

enum FunctionName {
    
    static let OneInputVertex = "oneInputVertex"
    static let TwoInputVertex = "twoInputVertex"
    static let PassthroughFragment = "passthroughFragment"
    
    static func defaultVertexFunctionNameForInputs(_ inputCount: UInt) -> String {
        switch inputCount {
        case 1:
            return OneInputVertex
        case 2:
            return TwoInputVertex
        default:
            return OneInputVertex
        }
    }
}

public enum RenderColor {
    static let clearColor = MTLClearColorMake(0.85, 0.85, 0.85, 1)
}
