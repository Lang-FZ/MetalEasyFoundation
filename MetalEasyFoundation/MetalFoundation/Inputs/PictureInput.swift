//
//  PictureInput.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/5.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import MetalKit

public class PictureInput: ImageSource {
    
    public let targets = TargetContainer()
    var internalTexture : Texture?
    var hasProcessedImage: Bool = false
    var internalImage: CGImage?
    
    public init(image: CGImage) {
        internalImage = image
    }
    
    public convenience init(image:UIImage) {
        self.init(image: image.cgImage!)
    }
    
    public convenience init(imageName: String) {
        guard let image = UIImage.init(named: imageName) else {
            fatalError("No such image named: \(imageName) in your application bundle")
        }
        self.init(image: image)
    }
    
    public func processImage(synchronously: Bool = false) {
        if let texture = internalTexture {
            if synchronously {
                updateTargetsWithTexture(texture)
                hasProcessedImage = true
            } else {
                DispatchQueue.global().async {
                    self.updateTargetsWithTexture(texture)
                    self.hasProcessedImage = true
                }
            }
        } else {
            let textureLoader = sharedContext.textureLoader
            if synchronously {
                do {
                    let imageTexture = try textureLoader.newTexture(cgImage: internalImage!, options: [MTKTextureLoader.Option.SRGB : false])
                    internalImage = nil
                    internalTexture = Texture.init(texture: imageTexture)
                    updateTargetsWithTexture(internalTexture!)
                    hasProcessedImage = true
                } catch {
                    fatalError("Failed loading image texture")
                }
            } else {
                textureLoader.newTexture(cgImage: internalImage!, options: [MTKTextureLoader.Option.SRGB : false]) { (possibleTexture, error) in
                    guard error == nil else {
                        fatalError("Error in loading texture: \(error!)")
                    }
                    guard let texture = possibleTexture else {
                        fatalError("Nil texture received")
                    }
                    self.internalImage = nil
                    self.internalTexture = Texture.init(texture: texture)
                    DispatchQueue.global().async {
                        self.updateTargetsWithTexture(self.internalTexture!)
                        self.hasProcessedImage = true
                    }
                }
            }
        }
    }
    
    public func transmitPreviousImage(to target: ImageConsumer, atIndex: UInt) {
        if hasProcessedImage {
            target.newTextureAvailable(self.internalTexture!, fromSourceIndex: atIndex)
        }
    }
}
