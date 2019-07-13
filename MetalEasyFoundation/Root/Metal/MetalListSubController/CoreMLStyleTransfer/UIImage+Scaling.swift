//
//  UIImage+Scaling.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/12.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

extension UIImage {

    enum ScalingMode {
        
        case aspectFill
        case aspectFit
        
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            
            let aspectWidth = size.width / otherSize.width
            let aspectHeight = size.height / otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y = (newSize.height - size.height * aspectRatio) / 2.0
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage.init()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
