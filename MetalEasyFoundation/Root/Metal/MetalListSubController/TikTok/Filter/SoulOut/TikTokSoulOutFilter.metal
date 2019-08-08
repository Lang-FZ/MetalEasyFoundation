//
//  TikTokSoulOutFilter.metal
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

#include <metal_stdlib>
#import "OperationShaderTypes.h"
using namespace metal;

typedef struct {
    float tikTokSoulOutTime;
} TikTokSoulOutTime;

fragment half4 tikTokSoulOutFragment(SingleInputVertexIO fragmentInput [[stage_in]], texture2d<half> inputTexture [[texture(0)]], constant TikTokSoulOutTime& time [[ buffer(1)]]) {
    
    float duration = 0.7;
    float maxAlpha = 0.4;
    float maxScale = 1.8;
    
    float progress = fmod(time.tikTokSoulOutTime, duration) / duration; // 0~1
    float alpha = maxAlpha * (1.0 - progress);
    float scale = 1.0 + (maxScale - 1.0) * progress;
    
    float weakX = 0.5 + (fragmentInput.textureCoordinate[0] - 0.5) / scale;
    float weakY = 0.5 + (fragmentInput.textureCoordinate[1] - 0.5) / scale;
    float2 weakTextureCoords = float2(weakX, weakY);
    
    constexpr sampler quadSampler;
    
    half4 weakMask = inputTexture.sample(quadSampler, weakTextureCoords);
    half4 mask = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    half4 color = mask * (1.0 - alpha) + weakMask * alpha;
    
    return color;
}
