//
//  BasicOperation.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/8.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation
import Metal

open class BasicOperation: ImageProcessingOperation {
    
    public var maximumInputs: UInt
    public var targets = TargetContainer()
    public var sources = SourceContainer()
    public var uniformSettings = ShaderUniformSettings()
    
    let renderPipelineState: MTLRenderPipelineState
    var inputTextures = [UInt : Texture]()
    let textureInputSemaphore = DispatchSemaphore.init(value: 1)
    
    init(vertexFunctionName: String? = nil, fragmentFunctionName: String, numberOfInputs: UInt = 1) {
        
        self.maximumInputs = numberOfInputs
        let concreteVertexFunctionName = vertexFunctionName ?? FunctionName.defaultVertexFunctionNameForInputs(numberOfInputs)
        
        renderPipelineState = generateRenderPipelineState(vertexFunctionName: concreteVertexFunctionName, fragmentFunctionName: fragmentFunctionName)
    }
    
    public func newTextureAvailable(_ texture: Texture, fromSourceIndex: UInt) {
        
        let _ = textureInputSemaphore.wait(timeout: DispatchTime.distantFuture)
        defer {
            textureInputSemaphore.signal()
        }
        
        inputTextures[fromSourceIndex] = texture
        
        if UInt.init(inputTextures.count) >= maximumInputs {
            let outputWidth: Int
            let outputHeight: Int
            
            let firstInputTexture = inputTextures[0]!
            outputWidth = firstInputTexture.texture.width
            outputHeight = firstInputTexture.texture.height
            
            guard let commandBuffer = sharedContext.commandQueue.makeCommandBuffer() else {
                return
            }
            
            let outputTexture = Texture.init(width: outputWidth, height: outputHeight)
            
            commandBuffer.renderQuad(pipelineState: renderPipelineState, uniformSettings: uniformSettings, inputTextures: inputTextures, outputTexture: outputTexture)
            commandBuffer.commit()
            updateTargetsWithTexture(outputTexture)
        }
    }
    
    
    public func transmitPreviousImage(to target: ImageConsumer, atIndex: UInt) {

    }
}
