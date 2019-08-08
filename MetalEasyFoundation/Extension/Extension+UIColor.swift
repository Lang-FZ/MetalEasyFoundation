//
//  Extension+UIColor.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

public extension UIColor {
    
    convenience init(_ hex:String, alpha:CGFloat = 1) {
        
        var color_str = (hex.contains("#") == true ? hex : "#"+hex) as NSString
        
        if color_str.length != 7 {
            self.init(white: 1, alpha: 1)
            return
        }
        color_str = color_str.substring(from: 1) as NSString
        
        self.init(red:      CGFloat.init(Int(color_str.substring(to: 2), radix: 16) ?? 0) / 255.0,
                  green:    CGFloat.init(Int(color_str.substring(with: NSRange.init(location: 2, length: 2)), radix: 16) ?? 0) / 255.0,
                  blue:     CGFloat.init(Int(color_str.substring(with: NSRange.init(location: 4, length: 2)), radix: 16) ?? 0) / 255.0,
                  alpha:    alpha)
    }
}
