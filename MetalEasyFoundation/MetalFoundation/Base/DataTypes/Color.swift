//
//  Color.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/4.
//  Copyright © 2019 LFZ. All rights reserved.
//

public struct Color {

    public let redComponent: Float
    public let greenComponent: Float
    public let blueComponent: Float
    public let alphaComponent: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.redComponent = red
        self.greenComponent = green
        self.blueComponent = blue
        self.alphaComponent = alpha
    }
    
    public static let black = Color.init(red: 0, green: 0, blue: 0, alpha: 1)
    public static let white = Color.init(red: 1, green: 1, blue: 1, alpha: 1)
    public static let red = Color.init(red: 1, green: 0, blue: 0, alpha: 1)
    public static let green = Color.init(red: 0, green: 1, blue: 0, alpha: 1)
    public static let blue = Color.init(red: 0, green: 0, blue: 1, alpha: 1)
    public static let transparent = Color.init(red: 0, green: 0, blue: 0, alpha: 0)
}
