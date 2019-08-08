//
//  TikTokFlashWhiteFilter.metal
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

#include <metal_stdlib>
#import "OperationShaderTypes.h"
using namespace metal;

typedef struct {
    float tikTokFlashWhiteTime;
} TikTokFlashWhiteTime;

constant float PI = 3.1415926;

fragment half4 tikTokFlashWhiteFragment(SingleInputVertexIO fragmentInput [[stage_in]], texture2d<half> inputTexture [[texture(0)]], constant TikTokFlashWhiteTime& time [[ buffer(1)]]) {
    
    constexpr sampler quadSampler;
    
    float duration = 0.6;
    float progress = fmod(time.tikTokFlashWhiteTime, duration); // 0~1
    
    half4 whiteMask = half4(1.0, 1.0, 1.0, 1.0);
    float amplitude = abs(sin(progress * (PI / duration)));
    
    half4 mask = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    half4 color = mask * (1.0 - amplitude) + whiteMask * amplitude;
    
    return color;
}

