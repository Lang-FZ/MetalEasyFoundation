//
//  FillMode.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/5.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

public enum FillMode {
    case stretch
    case preserveAspectRatio
    case preserveAspectRatioAndFill
    
    func transformVertices(_ vertices: [Float], fromInputSize: CGSize, toFitSize: CGSize) -> [Float] {
        guard vertices.count == 8 else {
            fatalError("Attempted to transform a non-quad to account for fill mode.")
        }
        
        let aspectRatio = Float.init(fromInputSize.height) / Float.init(fromInputSize.width)
        let targetAspectRatio = Float.init(toFitSize.height) / Float.init(toFitSize.width)
        
        let yRatio: Float
        let xRatio: Float
        
        switch self {
        case .stretch:
            return vertices
        case .preserveAspectRatio:
            if aspectRatio > targetAspectRatio {
                yRatio = 1
                xRatio = (Float.init(fromInputSize.width) / Float.init(toFitSize.width)) * (Float.init(toFitSize.height) / Float.init(fromInputSize.height))
            } else {
                xRatio = 1
                yRatio = (Float.init(fromInputSize.height) / Float.init(toFitSize.height)) * (Float.init(toFitSize.width) / Float.init(fromInputSize.width))
            }
        case .preserveAspectRatioAndFill:
            if aspectRatio > targetAspectRatio {
                xRatio = 1
                yRatio = (Float.init(fromInputSize.height) / Float.init(toFitSize.height)) * (Float.init(toFitSize.width) / Float.init(fromInputSize.width))
            } else {
                yRatio = 1
                xRatio = (Float.init(toFitSize.height) / Float.init(fromInputSize.height)) * (Float.init(fromInputSize.width) / Float.init(toFitSize.width))
            }
        }
        
        let xConversionRatio: Float = xRatio * Float.init(toFitSize.width) / 2
        let xConversionDivisor: Float = Float.init(toFitSize.width) / 2
        let yConversionRatio: Float = yRatio * Float.init(toFitSize.height) / 2
        let yConversionDivisor: Float = Float.init(toFitSize.height) / 2
        
        let value1: Float = Float.init(round(Double.init(vertices[0] * xConversionRatio))) / xConversionDivisor
        let value2: Float = Float.init(round(Double.init(vertices[1] * yConversionRatio))) / yConversionDivisor
        let value3: Float = Float.init(round(Double.init(vertices[2] * xConversionRatio))) / xConversionDivisor
        let value4: Float = Float.init(round(Double.init(vertices[3] * yConversionRatio))) / yConversionDivisor
        let value5: Float = Float.init(round(Double.init(vertices[4] * xConversionRatio))) / xConversionDivisor
        let value6: Float = Float.init(round(Double.init(vertices[5] * yConversionRatio))) / yConversionDivisor
        let value7: Float = Float.init(round(Double.init(vertices[6] * xConversionRatio))) / xConversionDivisor
        let value8: Float = Float.init(round(Double.init(vertices[7] * yConversionRatio))) / yConversionDivisor
        
        return [value1, value2, value3, value4, value5, value6, value7, value8]
    }
}
