//
//  ShaderUniformSettings.swift
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/4.
//  Copyright © 2019 LFZ. All rights reserved.
//

import Foundation
import Metal

public class ShaderUniformSettings {

    private var uniformValues: [Float] = []
    private var uniformValueOffsets: [Int] = []
    public var colorUniformsUseAlpha: Bool = false
    let shaderUniformSettingsQueue = DispatchQueue.init(label: "me.CodeSet.shaderUniformSettings", attributes: [])
    
    private func internalIndex(for index: Int) -> Int {
        if index == 0 {
            return 0
        } else {
            return uniformValueOffsets[index - 1]
        }
    }
    
    public subscript(index: Int) -> Float {
        get { return uniformValues[internalIndex(for: index)] }
        set(newValue) {
            shaderUniformSettingsQueue.async {
                self.uniformValues[self.internalIndex(for: index)] = newValue
            }
        }
    }
    
    public subscript(index: Int) -> Color {
        
        get {
            return Color.init(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        set(newValue) {
            
            shaderUniformSettingsQueue.async {
                
                let floatArray: [Float]
                let startingIndex = self.internalIndex(for: index)
                
                if self.colorUniformsUseAlpha {
                    floatArray = newValue.toFloatArrayWithAlpha()
                    self.uniformValues[startingIndex] = floatArray[0]
                    self.uniformValues[startingIndex + 1] = floatArray[1]
                    self.uniformValues[startingIndex + 2] = floatArray[2]
                    self.uniformValues[startingIndex + 3] = floatArray[3]
                } else {
                    floatArray = newValue.toFloatArray()
                    self.uniformValues[startingIndex] = floatArray[0]
                    self.uniformValues[startingIndex + 1] = floatArray[1]
                    self.uniformValues[startingIndex + 2] = floatArray[2]
                }
            }
        }
    }
    
    public subscript(index: Int) -> Position {
        get {
            return Position.init(0, 0)
        }
        set(newValue) {
            shaderUniformSettingsQueue.async {
                let floatArray = newValue.toFloatArray()
                var currentIndex = self.internalIndex(for: index)
                for floatValue in floatArray {
                    self.uniformValues[currentIndex] = floatValue
                    currentIndex += 1
                }
            }
        }
    }
    
    public subscript(index: Int) -> Matrix3x3 {
        get {
            return Matrix3x3.identity
        }
        set(newValue) {
            shaderUniformSettingsQueue.async {
                let floatArray = newValue.toFloatArray()
                var currentIndex = self.internalIndex(for: index)
                for floatValue in floatArray {
                    self.uniformValues[currentIndex] = floatValue
                    currentIndex += 1
                }
            }
        }
    }
    
    public subscript(index: Int) -> Matrix4x4 {
        get {
            return Matrix4x4.identity
        }
        set(newValue) {
            shaderUniformSettingsQueue.async {
                let floatArray = newValue.toFloatArray()
                var currentIndex = self.internalIndex(for: index)
                for floatValue in floatArray {
                    self.uniformValues[currentIndex] = floatValue
                    currentIndex += 1
                }
            }
        }
    }
    
    func alignPackingForOffset(uniformSize: Int, lastOffset: Int) -> Int {
        let floatAlignment = lastOffset % 4
        if uniformSize > 1 && floatAlignment != 0 {
            let paddingToAlignment = 4 - floatAlignment
            uniformValues.append(contentsOf: [Float](repeating: 0, count: paddingToAlignment))
            uniformValueOffsets[uniformValueOffsets.count - 1] = lastOffset + paddingToAlignment
            return lastOffset + paddingToAlignment
        } else {
            return lastOffset
        }
    }
    
    public func appendUniform(_ value: UniformConvertible) {
        let lastOffset = alignPackingForOffset(uniformSize: value.uniformSize(), lastOffset: uniformValueOffsets.last ?? 0)
        
        uniformValues.append(contentsOf: value.toFloatArray())
        uniformValueOffsets.append(lastOffset + value.uniformSize())
    }
    
    public func appendUniform(_ value: Color) {
        let colorSize = 4
        let lastOffset = alignPackingForOffset(uniformSize: colorSize, lastOffset: uniformValueOffsets.last ?? 0)
        
        if colorUniformsUseAlpha {
            uniformValues.append(contentsOf: value.toFloatArrayWithAlpha())
        } else {
            uniformValues.append(contentsOf: value.toFloatArray())
        }
        uniformValueOffsets.append(lastOffset + colorSize)
    }
    
    public func restoreShaderSettings(renderEncoder: MTLRenderCommandEncoder) {
        shaderUniformSettingsQueue.sync {
            guard self.uniformValues.count > 0 else { return }
            let uniformBuffer = sharedContext.device.makeBuffer(bytes: uniformValues, length: uniformValues.count * MemoryLayout<Float>.size, options: [])!
            renderEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)
        }
    }
    public func restoreVertexShaderSettings(renderEncoder: MTLRenderCommandEncoder, index:Int = 2) {
        shaderUniformSettingsQueue.sync {
            guard self.uniformValues.count > 0 else { return }
            let uniformBuffer = sharedContext.device.makeBuffer(bytes: uniformValues, length: uniformValues.count * MemoryLayout<Float>.size, options: [])!
            renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: index)
        }
    }
}

public protocol UniformConvertible {
    func toFloatArray() -> [Float]
    func uniformSize() -> Int
}

extension Float: UniformConvertible {
    public func toFloatArray() -> [Float] {
        return [self]
    }
    public func uniformSize() -> Int {
        return 1
    }
}

extension Double: UniformConvertible {
    public func toFloatArray() -> [Float] {
        return [Float.init(self)]
    }
    public func uniformSize() -> Int {
        return 1
    }
}

extension Color {
    func toFloatArray() -> [Float] {
        return [self.redComponent, self.greenComponent, self.blueComponent, 0]
    }
    func toFloatArrayWithAlpha() -> [Float] {
        return [self.redComponent, self.greenComponent, self.blueComponent, self.alphaComponent]
    }
}

extension Position: UniformConvertible {
    public func toFloatArray() -> [Float] {
        return [self.x, self.y, self.z, self.w]
    }
    public func uniformSize() -> Int {
        return 4
    }
}

extension Matrix3x3: UniformConvertible {
    public func toFloatArray() -> [Float] {
        return [m11, m12, m13, 0, m21, m22, m23, 0, m31, m32, m33, 0]
    }
    public func uniformSize() -> Int {
        return 12
    }
}

extension Matrix4x4: UniformConvertible {
    public func toFloatArray() -> [Float] {
        return [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44]
    }
    public func uniformSize() -> Int {
        return 16
    }
}
