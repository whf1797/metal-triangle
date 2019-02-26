//
//  shader.metal
//  metalDemo0226
//
//  Created by 王洪飞 on 2019/2/26.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#include <metal_stdlib>
#import "shadertypes.h"
using namespace metal;
struct VertexInOut{
    float4 position[[position]];
    float4 color;
};

//struct vertexin{
//    packed_float3 pos;
//    packed_float3 color;
//};

vertex VertexInOut vertexfunction(uint vidd[[vertex_id]],
                   constant WFVertex *in[[buffer(0)]]) {
    VertexInOut vertexout;
    vertexout.position = float4(in[vidd].position,0,1);
    vertexout.color = float4(in[vidd].color);
    return vertexout;
}


fragment float4 fragmentshader(VertexInOut infag[[stage_in]]) {
    return infag.color;
}


