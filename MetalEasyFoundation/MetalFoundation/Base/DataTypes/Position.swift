//
//  Position.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/4.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

public struct Position {

    public let x: Float
    public let y: Float
    public let z: Float
    public let w: Float
    
    public init(_ x: Float, _ y: Float, _ z: Float = 0.0, _ w: Float = 0.0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    public init(point: CGPoint) {
        self.x = Float.init(point.x)
        self.y = Float.init(point.y)
        self.z = 0
        self.w = 0
    }
    
    public static let center = Position.init(0.5, 0.5)
    public static let zero = Position.init(0, 0)
}
