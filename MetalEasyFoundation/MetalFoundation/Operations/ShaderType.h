//
//  ShaderType.h
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/8.
//  Copyright © 2019 LFZ. All rights reserved.
//

#ifndef ShaderType_h
#define ShaderType_h
using namespace metal;

constant half3 luminanceWeighting = half3(0.2125, 0.7154, 0.0721);

struct SingleInputVertexIO {
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
};

struct TwoInputVertexIO {
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
    float2 textureCoordinate2 [[user(texturecoord2)]];
};

#endif /* ShaderType_h */
