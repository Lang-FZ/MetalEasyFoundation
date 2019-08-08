import Foundation
import MetalKit

public class RenderView: MTKView, ImageConsumer {
    
    public let sources = SourceContainer()
    public let maximumInputs: UInt = 1
    var currentTexture: Texture?
    var renderPipelineState:MTLRenderPipelineState!
    
    public var fillMode = FillMode.preserveAspectRatio
    
    public override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: sharedMetalRenderingDevice.device)
        
        commonInit()
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        framebufferOnly = false
        autoResizeDrawable = true
        
        self.device = sharedMetalRenderingDevice.device
        
        let (pipelineState, _, _) = generateRenderPipelineState(device:sharedMetalRenderingDevice, vertexFunctionName:"oneInputVertex", fragmentFunctionName:"passthroughFragment", operationName:"RenderView")
        self.renderPipelineState = pipelineState
        
        enableSetNeedsDisplay = false
        isPaused = true
    }
    
    public func newTextureAvailable(_ texture:Texture, fromSourceIndex:UInt) {
        self.drawableSize = CGSize(width: texture.texture.width, height: texture.texture.height)
        currentTexture = texture
        self.draw()
    }
    
    public override func draw(_ rect:CGRect) {
        if let currentDrawable = self.currentDrawable, let imageTexture = currentTexture {
            
            let outputTexture = Texture(orientation: .portrait, texture: currentDrawable.texture)
            let scaledVertices = fillMode.transformVertices(standardImageVertices, fromInputSize:CGSize(width: imageTexture.texture.width, height: imageTexture.texture.height), toFitSize:self.frame.size)
            
            let commandBuffer = sharedMetalRenderingDevice.commandQueue.makeCommandBuffer()
            commandBuffer?.renderQuad(pipelineState: renderPipelineState, inputTextures: [0:imageTexture], imageVertices: scaledVertices, outputTexture: outputTexture)
            
            commandBuffer?.present(currentDrawable)
            commandBuffer?.commit()
        }
    }
}


