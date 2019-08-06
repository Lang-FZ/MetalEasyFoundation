//
//  TikTokShakeFilter.metal
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

#include <metal_stdlib>
#import "ShaderType.h"
using namespace metal;

fragment half4 tikTokShakeFragment(SingleInputVertexIO fragmentInput [[stage_in]], texture2d<half> inputTexture [[texture(0)]], constant float& time [[ buffer(1)]]) {
    
    constexpr sampler quadSampler;
    
    float duration = 0.7;
    float maxScale = 1.1;
    float offset = 0.02;
    
    float progress = fmod(time, duration) / duration; // 0~1
    float2 offsetCoords = float2(offset, offset) * progress;
    float scale = 1.0 + (maxScale - 1.0) * progress;
    
    float2 ScaleTextureCoords = float2(0.5, 0.5) + (fragmentInput.textureCoordinate - float2(0.5, 0.5)) / scale;
    half4 maskR = inputTexture.sample(quadSampler, ScaleTextureCoords + offsetCoords);
    half4 maskB = inputTexture.sample(quadSampler, ScaleTextureCoords - offsetCoords);
    half4 mask = inputTexture.sample(quadSampler, ScaleTextureCoords);
    
    half4 color = half4(maskR.r, mask.g, maskB.b, mask.a);
    
    return color;
}


