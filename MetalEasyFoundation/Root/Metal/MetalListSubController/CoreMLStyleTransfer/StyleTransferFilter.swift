//
//  StyleTransferFilter.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/13.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

class StyleTransferFilter: BasicOperation {
    
    public var modelTexture: PictureInput? {
        didSet {
            modelTexture?.addTarget(self, atTargetIndex: 1)
            modelTexture?.processImage()
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "styleTransferFragment", numberOfInputs: 2)
    }
}
