//
//  CyclePagePhotoModel.swift
//  Base-UI-Utils
//
//  Created by LangFZ on 2019/4/12.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit

// MARK: -
@objcMembers
open class CyclePagePhotoModel: NSObject {
    
    /** 属性 */
    public var collection_width_height:CGFloat = 0
    
    public var photoData:[CyclePagePhotoModel] = []
    
    public var photoName:String = ""
    public var photoUrl:URL?
    
    public var indexPath:IndexPath?
    public var image:UIImage?
    public var photo_width_height:CGFloat = 1
    
    override public init() {
        super.init()
    }
}
