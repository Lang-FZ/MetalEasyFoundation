//
//  ProgressHUD.swift
//  igola
//
//  Created by LangFZ on 2018/6/21.
//  Copyright © 2018 www.igola.com. All rights reserved.
//

import UIKit
import JGProgressHUD

let LoadingTag: Int = 99999
let SuccessTag: Int = 99998

private var callbackIdentifier = "hiddenHUDCallback"

extension UIView:JGProgressHUDDelegate {
    
    private var hiddenHUDCallback: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &callbackIdentifier) as? (() -> ())
        }
        set {
            objc_setAssociatedObject(self, &callbackIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func creatShowLoading(_ text:String = "Loading", have_words:Bool = true, seconds:TimeInterval = 2.0, timeHidden:Bool = false, style:JGProgressHUDStyle = .dark) -> JGProgressHUD {
        
        let hud = JGProgressHUD(style: style)
        
        if timeHidden {
            hud.dismiss(afterDelay: seconds)
            hud.isUserInteractionEnabled = true
        } else {
            hud.isUserInteractionEnabled = false
        }
        
        if have_words {
            hud.textLabel.text = text
        }
        
        return hud
    }
    
    func showLoading(_ text:String = "Loading", have_words:Bool = true, seconds:TimeInterval = 2.0, timeHidden:Bool = false, style:JGProgressHUDStyle = .dark, callback: (()->())? = nil) {
        
        if let _:JGProgressHUD = self.viewWithTag(LoadingTag) as? JGProgressHUD {
            return
        }
        
        let hud = self.creatShowLoading(text, have_words: have_words, seconds: seconds, timeHidden: timeHidden, style: style)
        hud.tag = LoadingTag
        hud.delegate = self
        hiddenHUDCallback = callback
        
        hud.show(in: self)
    }
    
    func dismissLoading() {
        
        if let hud:JGProgressHUD = self.viewWithTag(LoadingTag) as? JGProgressHUD {
            hud.dismiss()
            hud.removeFromSuperview()
        }
    }
    
    func showSuccessHud(_ text:String = "Seccess!", have_words:Bool = true, seconds:TimeInterval = 2.0, timeHidden:Bool = false, style:JGProgressHUDStyle = .dark, hasImage:Bool = true, callback: (()->())? = nil) {
        
        if let _:JGProgressHUD = self.viewWithTag(SuccessTag) as? JGProgressHUD {
            return
        }
        
        let hud = self.creatShowLoading(text, have_words: have_words, seconds: seconds, timeHidden: timeHidden, style: style)
        hud.tag = SuccessTag
        hud.delegate = self
        hiddenHUDCallback = callback
        
        if hasImage {
            
            if style == .dark {
                hud.indicatorView = JGProgressHUDIndicatorView.init(contentView: UIImageView.init(image: UIImage.init(named: "iGola_Hud_Success_White")))
            } else {
                hud.indicatorView = JGProgressHUDIndicatorView.init(contentView: UIImageView.init(image: UIImage.init(named: "iGola_Hud_Success_Black")))
            }
        } else {
            hud.indicatorView = nil
        }
        
        hud.show(in: self)
    }
    
    func dismissSeccessLoading() {
        
        if let hud:JGProgressHUD = self.viewWithTag(SuccessTag) as? JGProgressHUD {
            hud.dismiss()
            hud.removeFromSuperview()
        }
    }
    
    public func progressHUD(_ progressHUD: JGProgressHUD, didDismissFrom view: UIView) {
        hiddenHUDCallback?()
    }
}

extension UIViewController:JGProgressHUDDelegate {
    
    private var hiddenHUDCallback: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &callbackIdentifier) as? (() -> ())
        }
        set {
            objc_setAssociatedObject(self, &callbackIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoading(_ text:String = "Loading", have_words:Bool = true, seconds:TimeInterval = 2.0, timeHidden:Bool = false, style:JGProgressHUDStyle = .dark, callback: (()->())? = nil) {
        
        if let _:JGProgressHUD = self.view.viewWithTag(LoadingTag) as? JGProgressHUD {
            return
        }
        
        let hud = self.view.creatShowLoading(text, have_words: have_words, seconds: seconds, timeHidden: timeHidden, style: style)
        hud.tag = LoadingTag
        hud.delegate = self
        hiddenHUDCallback = callback
        
        hud.show(in: self.view)
    }
    
    func dismissLoading() {
        
        if let hud:JGProgressHUD = self.view.viewWithTag(LoadingTag) as? JGProgressHUD {
            hud.dismiss()
            hud.removeFromSuperview()
        }
    }
    
    /// toast提示
    ///
    /// - Parameters:
    ///   - text: 文字描述
    ///   - have_words: 是否有文字描述
    ///   - seconds: 需要显示几秒
    ///   - timeHidden: 是否几秒之后隐藏
    ///   - style: 样式
    ///   - hasImage: 是否需要图片
    ///   - bgColor: hud背景色 UIColor
    ///   - textFont: 提示文字字体
    func showSuccessHud(_ text:String = "Seccess!", have_words:Bool = true, seconds:TimeInterval = 2.0, timeHidden:Bool = false, style:JGProgressHUDStyle = .dark, hasImage:Bool = true, bgColor : UIColor? = nil, textFont : UIFont? = nil, callback: (()->())? = nil) {
        
        if let _:JGProgressHUD = self.view.viewWithTag(SuccessTag) as? JGProgressHUD {
            return
        }
        
        let hud = self.view.creatShowLoading(text, have_words: have_words, seconds: seconds, timeHidden: timeHidden, style: style)
        hud.layer.transform = CATransform3DTranslate(hud.layer.transform, 0, 0, 200)
        hud.tag = SuccessTag
        hud.delegate = self
        hiddenHUDCallback = callback
        
        if hasImage {
            
            if style == .dark {
                hud.indicatorView = JGProgressHUDIndicatorView.init(contentView: UIImageView.init(image: UIImage.init(named: "iGola_Hud_Success_White")))
            } else {
                hud.indicatorView = JGProgressHUDIndicatorView.init(contentView: UIImageView.init(image: UIImage.init(named: "iGola_Hud_Success_Black")))
            }
        } else {
            
            hud.indicatorView = nil
        }
        
        if let color = bgColor {
            hud.contentView.backgroundColor = color
        }
        
        if let font = textFont {
            hud.textLabel.font = font
        }
        
        hud.show(in: self.view)
    }
    
    func dismissSeccessLoading() {
        
        if let hud:JGProgressHUD = self.view.viewWithTag(SuccessTag) as? JGProgressHUD {
            hud.dismiss()
            hud.removeFromSuperview()
        }
    }
    
    public func progressHUD(_ progressHUD: JGProgressHUD, didDismissFrom view: UIView) {
        hiddenHUDCallback?()
    }
}
