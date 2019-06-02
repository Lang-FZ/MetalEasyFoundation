//
//  LocalizationTool.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//  多国语言本地化

import UIKit

private let lang_key:String = "MetalDemoLanguage"
public let Language_Changed_Notification:Notification.Name = Notification.Name.init("MetalDemoLanguageChanged")

class LocalizationTool: NSObject {
    
    /// 获取不同语言下的String
    ///
    /// - Parameter identifier: 标识
    /// - Returns: 不同语言下的String
    public class func getStr(_ identifier:String) -> String {
        
        let path = Bundle.main.path(forResource: getCurrentLanguage(), ofType: "lproj")
        let bundle = Bundle(path: path ?? "")
        
        return bundle?.localizedString(forKey: identifier, value: "", table: nil) ?? ""
    }
    
    /// 获得当前语言
    ///
    /// - Returns: 语言 "en" or "zh-Hans"
    public class func getCurrentLanguage() -> String {
        
        if let language = UserDefaults.standard.value(forKey: lang_key) {
            return (language as? String ?? "zh-Hans")
        } else {
            return saveCurrentLanguage()
        }
    }
    /// 保存语言
    ///
    /// - Parameter language: 传入要保存的语言
    /// - Returns: 返回语言 "en" or "zh-Hans"
    public class func saveCurrentLanguage(_ language:String = "") -> String {
        
        var language_temp = language
        
        if language_temp == "" {
            
            let localizations = Bundle.main.localizations
            let currentLangCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String
            if( localizations.contains(currentLangCode)) {
                language_temp = currentLangCode
            }
            
            if language_temp == "" {
                language_temp = "zh-Hans"
            }
        }
        
        UserDefaults.standard.set(language_temp, forKey: lang_key)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Language_Changed_Notification, object: nil)
        
        return language_temp
    }
    /// 当前是否是中文
    ///
    /// - Returns: 是否是中文
    public class func isChinese() -> Bool {
        return getCurrentLanguage().lowercased().contains("zh") ? true : false
    }
}
