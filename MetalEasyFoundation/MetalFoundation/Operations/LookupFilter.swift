//
//  LookupFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/8.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

public class LookupFilter: BasicOperation {

    public var intensity: Float = 1.0 {
        didSet {
            uniformSettings[0] = intensity
        }
    }
    
    public var lookupImage: PictureInput? {
        didSet {
            lookupImage?.addTarget(self, atTargetIndex: 1)
            lookupImage?.processImage()
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "lookupFragment", numberOfInputs: 2)
        uniformSettings.appendUniform(1)
    }
}
