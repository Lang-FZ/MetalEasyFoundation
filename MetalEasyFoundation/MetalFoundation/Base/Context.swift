//
//  Context.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/4.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation
import MetalKit

public let sharedContext = Context()

public class Context {

    public let device: MTLDevice
    public let commandQueue: MTLCommandQueue
    public let defaultLibrary: MTLLibrary
    
    public let textureLoader: MTKTextureLoader
    
    init() {
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Metal Device")
        }
        self.device = device
        
        guard let queue = self.device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        self.commandQueue = queue
        
        do {
            let frameworkBundle = Bundle.init(for: Context.self)
            let metalLibratyPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!
            
            self.defaultLibrary = try device.makeLibrary(filepath: metalLibratyPath)
        } catch {
            fatalError("Could not load library")
        }
        
        self.textureLoader = MTKTextureLoader.init(device: self.device)
    }
}
