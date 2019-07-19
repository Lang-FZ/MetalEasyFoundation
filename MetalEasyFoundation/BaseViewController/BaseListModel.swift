//
//  BaseListModel.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/3.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

// MARK: -
@objcMembers
class BaseListModel: NSObject {
    
    /** 属性 */
    public var data:[BaseListModel] = []
    
    public var title:String = ""
    public var sub_title:String = ""
    public var action:((_ title:String) -> ())?
    public var is_selected:Bool = false
    public var index:Int = 0
    
    
    /** 自定义构造函数 */
    override init() {
        super.init()
    }
    init(_ dict : [String: Any]){
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "data" {
            
            for dic in value as? [Any] ?? [] {
             
                let model = BaseListModel(dic as? [String : Any] ?? [:])
                data.append(model)
             }
        } else {
            super.setValue(value, forKey: key)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
