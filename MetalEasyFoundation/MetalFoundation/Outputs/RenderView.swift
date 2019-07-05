//
//  RenderView.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/5.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation
import MetalKit

public class RenderView: UIView {

    public let sources = SourceContainer()
    public let maximumInputs: UInt = 1
    public var clearColor = RenderColor.clearColor
    public var fillMode = FillMode.preserveAspectRatio
    public var currentTexture: Texture?
    public var renderPipelineState: MTLRenderPipelineState!
    
    lazy var metalView: MTKView = {
       let metalView = MTKView.init(frame: self.bounds, device: sharedContext.device)
        metalView.isPaused = true
        return metalView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        renderPipelineState = generateRenderPipelineState(vertexFunctionName: FunctionName.OneInputVertex, fragmentFunctionName: FunctionName.PassthroughFragment)
        metalView.delegate = self
        addSubview(metalView)
    }
}

extension RenderView: ImageConsumer {
    
    public func newTextureAvailable(_ texture: Texture, fromSourceIndex: UInt) {
        currentTexture = texture
        metalView.draw()
    }
}

extension RenderView: MTKViewDelegate {
    
    public func draw(in view: MTKView) {
        guard let current_drawable = self.metalView.currentDrawable,
            let imageTexture = currentTexture else {
            debugPrint("Warning: Could update Current Drawable")
            return
        }
        
        let outputTexture = Texture.init(texture: current_drawable.texture)
        let scaledVertices = fillMode.transformVertices(verticallyInvertedImageVertices, fromInputSize: CGSize.init(width: imageTexture.texture.width, height: imageTexture.texture.height), toFitSize: metalView.drawableSize)
        
        let commandBuffer = sharedContext.commandQueue.makeCommandBuffer()!
        commandBuffer.renderQuad(pipelineState: renderPipelineState, inputTextures: [0 : imageTexture], outputTexture: outputTexture, clearColor: clearColor, imageVertices: scaledVertices)
        
        commandBuffer.present(current_drawable)
        commandBuffer.commit()
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
}
