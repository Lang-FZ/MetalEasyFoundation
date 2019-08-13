//
//  StyleTransferFilter.metal
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/8/13.
//  Copyright © 2019 LFZ. All rights reserved.
//

#include <metal_stdlib>
#import "OperationShaderTypes.h"
using namespace metal;

fragment half4 styleTransferFragment(SingleInputVertexIO fragmentInput [[stage_in]], texture2d<half> inputTexture [[texture(0)]], texture2d<half> modelTexture [[texture(1)]]) {
    
    constexpr sampler quadSampler;
    
    half4 color;
    half4 modelColor = modelTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    half4 inputColor = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
//    if (modelColor.r == 0 && modelColor.g == 0 && modelColor.b == 0) {
        color = modelColor;
//    } else {
//        color = inputColor;
//    }
    
    return color;
}

