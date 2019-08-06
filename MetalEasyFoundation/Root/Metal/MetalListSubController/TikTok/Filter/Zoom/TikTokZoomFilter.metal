//
//  TikTokZoomFilter.metal
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/18.
//  Copyright © 2019 LFZ. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
constant float PI = 3.1415926;

struct TikTokZoomVertexIO {
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
};


vertex TikTokZoomVertexIO tikTokZoomVertex(device packed_float2 *position [[buffer(0)]], device packed_float2 *texturecoord [[buffer(1)]], constant float& uniforms [[ buffer(2)]], uint vid [[vertex_id]]) {
    
    TikTokZoomVertexIO outputVertices;
    
    float duration = 0.6;
    float maxAmplitude = 0.3;
    
    float time = fmod(uniforms, duration);
    float amplitude = 1.0 + maxAmplitude * abs(sin(time * (PI / duration)));
    
    outputVertices.position = float4(position[vid]*amplitude, 0, 1.0);
    outputVertices.textureCoordinate = texturecoord[vid];
    
    return outputVertices;
}

fragment half4 tikTokZoomFragment(TikTokZoomVertexIO fragmentInput [[stage_in]], texture2d<half> inputTexture [[texture(0)]]) {
    
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    return color;
}
