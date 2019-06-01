//
//  Extension+UIFont.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

/*
 PingFangSC-Medium
 PingFangSC-Semibold
 PingFangSC-Regular
 PingFangSC-Light
 PingFangSC-Ultralight
 PingFangSC-Thin
 
 HelveticaNeue
 HelveticaNeue-UltraLightItalic
 HelveticaNeue-Medium
 HelveticaNeue-MediumItalic
 HelveticaNeue-UltraLight
 HelveticaNeue-Italic
 HelveticaNeue-Light
 HelveticaNeue-ThinItalic
 HelveticaNeue-LightItalic
 HelveticaNeue-Bold
 HelveticaNeue-Thin
 HelveticaNeue-CondensedBlack
 HelveticaNeue-CondensedBold
 HelveticaNeue-BoldItalic
 */

public enum FontName:String {
    
    case PFSC_Medium        = "PingFangSC-Medium"
    case PFSC_Semibold      = "PingFangSC-Semibold"
    case PFSC_Regular       = "PingFangSC-Regular"
    case PFSC_Light         = "PingFangSC-Light"
    case PFSC_Ultralight    = "PingFangSC-Ultralight"
    case PFSC_Thin          = "PingFangSC-Thin"
    
    case HT_Neue            = "Helvetica Neue"
    case HT_Italic          = "HelveticaNeue-Italic"
    case HT_Medium          = "HelveticaNeue-Medium"
    case HT_MediumItalic    = "HelveticaNeue-MediumItalic"
    case HT_Bold            = "HelveticaNeue-Bold"
    case HT_BoldItalic      = "HelveticaNeue-BoldItalic"
    case HT_CondensedBlack  = "HelveticaNeue-CondensedBlack"
    case HT_CondensedBold   = "HelveticaNeue-CondensedBold"
    case HT_UltraLight      = "HelveticaNeue-UltraLight"
    case HT_UltraLightItalic    = "HelveticaNeue-UltraLightItalic"
    case HT_Light           = "HelveticaNeue-Light"
    case HT_LightItalic     = "HelveticaNeue-LightItalic"
    case HT_Thin            = "HelveticaNeue-Thin"
    case HT_ThinItalic      = "HelveticaNeue-ThinItalic"

    case OpenSansSemibold   = "OpenSans-Semibold"
    
    func isBold() -> Bool {
        
        switch self {
            
        case .PFSC_Medium,
             .PFSC_Semibold,
             .HT_Medium,
             .OpenSansSemibold :
            return true
        default:
            return false
        }
    }
}

public extension UIFont {
    
    class func custom(_ customFontName:FontName, _ size:CGFloat) -> UIFont {
        
        if let font:UIFont = UIFont.init(name: customFontName.rawValue, size: frameMath(size)) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    class func customFont_real(_ customFontName: FontName, _ size: CGFloat) -> UIFont {
        
        if let customFont = UIFont(name: customFontName.rawValue, size: size) {
            return customFont
        } else {
            if customFontName.isBold() {
                return UIFont.boldSystemFont(ofSize: size)
            } else {
                return UIFont.systemFont(ofSize: size)
            }
        }
    }
}
