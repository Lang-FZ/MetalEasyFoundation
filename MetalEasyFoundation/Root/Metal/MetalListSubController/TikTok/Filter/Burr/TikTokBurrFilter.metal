//
//  TikTokBurrFilter.metal
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

#include <metal_stdlib>
#import "OperationShaderTypes.h"
using namespace metal;

typedef struct {
    float tikTokBurrTime;
} TikTokBurrTime;

constant float PI = 3.1415926;

fragment half4 tikTokBurrFragment(SingleInputVertexIO fragmentInput [[stage_in]], texture2d<half> inputTexture [[texture(0)]], constant TikTokBurrTime& time [[ buffer(1)]]) {
    
    constexpr sampler quadSampler;
    
    float maxJitter = 0.06;
    float duration = 0.3;
    float colorROffset = 0.01;
    float colorBOffset = -0.025;
    float progress = fmod(time.tikTokBurrTime, duration * 2.0); // 0~1
    
    float amplitude = max(sin(progress * (PI / duration)), 0.0);
    float jitter = fract(sin(fragmentInput.textureCoordinate[1]) * 43758.5453123) * 2.0 - 1.0; // -1~1
    bool needOffset = abs(jitter) < maxJitter * amplitude;
    
    half textureX = fragmentInput.textureCoordinate[0] + (needOffset ? jitter : (jitter * amplitude * 0.006));
    float2 textureCoords = float2(textureX, fragmentInput.textureCoordinate[1]);
    
    half4 mask = inputTexture.sample(quadSampler, textureCoords);
    half4 maskR = inputTexture.sample(quadSampler, textureCoords + float2(colorROffset * amplitude, 0.0));
    half4 maskB = inputTexture.sample(quadSampler, textureCoords + float2(colorBOffset * amplitude, 0.0));
    
    half4 color = half4(maskR.r, mask.g, maskB.b, mask.a);
    
    return color;
}

