//
//  TikTokHallucinationFilter.metal
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/6.
//  Copyright © 2019 LFZ. All rights reserved.
//

#include <metal_stdlib>
#import "ShaderType.h"
using namespace metal;

constant float PI = 3.1415926;
constant float duration = 2.0;

fragment half4 tikTokHallucinationFragment(SingleInputVertexIO fragmentInput [[stage_in]], texture2d<half> inputTexture [[texture(0)]], constant float& time [[ buffer(1)]]) {
    
    constexpr sampler quadSampler;
    
    float progress = fmod(time, duration);
    
    float scale = 1.2;
    float padding = 0.5 * (1.0 - 1.0 / scale);
    float2 textureCoords = float2(0.5, 0.5) + (fragmentInput.textureCoordinate - float2(0.5, 0.5)) / scale;
    
    float hideTime = 0.9;
    float timeGap = 0.2;
    
    float maxAlphaR = 0.5; // max R
    float maxAlphaG = 0.05; // max G
    float maxAlphaB = 0.05; // max B
    
    float2 translation = float2(sin(progress * (PI * 2.0 / duration)),
                            cos(progress * (PI * 2.0 / duration)));
    float2 translationTextureCoords = textureCoords + padding * translation;
    half4 mask = inputTexture.sample(quadSampler, translationTextureCoords);
    
    float alphaR = 1.0; // R
    float alphaG = 1.0; // G
    float alphaB = 1.0; // B
    
    float4 resultMask = float4(0, 0, 0, 0);
    
    for (float f = 0.0; f < duration; f += timeGap) {
        float tmpTime = f;
        float2 translation = float2(sin(tmpTime * (PI * 2.0 / duration)),
                                    cos(tmpTime * (PI * 2.0 / duration)));
        float2 tmpTranslationTextureCoords = textureCoords + padding * translation;
        half4 tmpMask = inputTexture.sample(quadSampler, tmpTranslationTextureCoords);
        
        float tmpAlphaR = maxAlphaR - maxAlphaR * min(fmod(duration + progress - tmpTime, duration), hideTime) / hideTime;
        float tmpAlphaG = maxAlphaG - maxAlphaG * min(fmod(duration + progress - tmpTime, duration), hideTime) / hideTime;
        float tmpAlphaB = maxAlphaB - maxAlphaB * min(fmod(duration + progress - tmpTime, duration), hideTime) / hideTime;
        
        resultMask += float4(tmpMask.r * tmpAlphaR, tmpMask.g * tmpAlphaG, tmpMask.b * tmpAlphaB, 1.0);
        alphaR -= tmpAlphaR;
        alphaG -= tmpAlphaG;
        alphaB -= tmpAlphaB;
    }
    resultMask += float4(mask.r * alphaR, mask.g * alphaG, mask.b * alphaB, 1.0);
    
    half4 color = half4(resultMask.r, resultMask.g, resultMask.b, resultMask.a);
    
    return color;
}

