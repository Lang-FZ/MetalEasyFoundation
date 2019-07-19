//
//  TikTokZoomFilter.metal
//  MetalEasyFoundation
//
//  Created by LangFZ on 2019/7/18.
//  Copyright © 2019 LFZ. All rights reserved.
//

//#include <metal_stdlib>
//using namespace metal;
//
//struct TikTokZoomVertexIO {
//    float4 position [[position]];
//    float2 textureCoordinate [[user(texturecoord)]];
//    float tikTokZoomTime;
//};
//
//
//vertex SingleInputVertexIO tikTokZoomVertex(device packed_float2 *position [[buffer(0)]], device packed_float2 *texturecoord [[buffer(1)]], uint vid [[vertex_id]]) {
//
////#if __METAL_VERSION__ >= 200 //__METAL_IOS__
////
////#endif
//
//    SingleInputVertexIO outputVertices;
//    outputVertices.position = float4(position[vid], 0, 1.0);
//    outputVertices.textureCoordinate = texturecoord[vid];
//
//    return outputVertices;
//}
