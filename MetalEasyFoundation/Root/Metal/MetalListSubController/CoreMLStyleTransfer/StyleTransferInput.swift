//
//  StyleTransferInput.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/12.
//  Copyright © 2019 LFZ. All rights reserved.
//

import CoreML
import CoreVideo

class StyleTransferInput: MLFeatureProvider {

    var input: CVPixelBuffer
    var featureNames: Set<String> {
        get {
            return ["inputImage"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "inputImage" {
            return MLFeatureValue.init(pixelBuffer: input)
        }
        return nil
    }
    init(input: CVPixelBuffer) {
        self.input = input
    }
}
