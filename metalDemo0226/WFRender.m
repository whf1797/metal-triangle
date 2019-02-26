//
//  WFRender.m
//  metalDemo0226
//
//  Created by 王洪飞 on 2019/2/26.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "WFRender.h"
#import "shadertypes.h"
@interface WFRender()<MTKViewDelegate>

@end

@implementation WFRender
{
    id <MTLDevice> mDevice;
    id <MTLCommandQueue> mCommandQueue;
    id <MTLBuffer> mCommandBuffer;
    id<MTLRenderPipelineState> mPipelineState;
}

-(instancetype)initWithMtkView:(nonnull MTKView *)mtkView {
    if (self = [super init]) {
        mDevice = mtkView.device;
        mtkView.delegate = self;
        [self setupPipelineWit:mtkView];
    }
    return self;
}

-(void)setupPipelineWit:(MTKView *)mtkview {
    id<MTLLibrary> defaultLibrary = [mDevice newDefaultLibrary];
    id<MTLFunction> vertFunction = [defaultLibrary newFunctionWithName:@"vertexfunction"];
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentshader"];
    
    MTLRenderPipelineDescriptor *pipelinedsp = [[MTLRenderPipelineDescriptor alloc] init];
    pipelinedsp.vertexFunction = vertFunction;
    pipelinedsp.fragmentFunction = fragmentFunction;
    pipelinedsp.colorAttachments[0].pixelFormat = mtkview.colorPixelFormat;
    pipelinedsp.label = @"mypiple";
    pipelinedsp.sampleCount = mtkview.sampleCount;
    
    mPipelineState = [mDevice newRenderPipelineStateWithDescriptor:pipelinedsp error:nil];
    mCommandQueue = [mDevice newCommandQueue];
    
    float trangle[] = {
        // a
        0,1,0  , 1,0,0,
        //b
        -1,0,0 , 0,1,0,
        //c
        1,-1,0, 0,0,1,
    };
    
    
    
//    WFVertex vertexs[] = {
//        {.position = {0.5,-0.5}, .color = {1,0,0}},
//        {.position = {-0.5,0.5}, .color = {0,1,0}},
//        {.position = {0.5,0.5}, .color = {0,0,1}}
//    };
    
    
    mCommandBuffer = [mDevice newBufferWithBytes:trangle length:sizeof(float)*18 options:MTLResourceCPUCacheModeDefaultCache];
    
    
    id <MTLCommandBuffer> commandbuffer = [mCommandQueue commandBuffer];
    commandbuffer.label = @"drawmtkview";
    MTLRenderPassDescriptor *renderDsp = mtkview.currentRenderPassDescriptor;
    id <CAMetalDrawable> drawable = mtkview.currentDrawable;
    id<MTLRenderCommandEncoder> commandEncoder = [commandbuffer renderCommandEncoderWithDescriptor:renderDsp];
    [commandEncoder setRenderPipelineState:mPipelineState];
    [commandEncoder setVertexBuffer:mCommandBuffer offset:0 atIndex:0];
    
    [commandEncoder endEncoding];
    [commandbuffer presentDrawable:drawable];
    [commandbuffer commit];
}

-(void)drawInMTKView:(MTKView *)view {
    id <MTLCommandBuffer> commandbuffer = [mCommandQueue commandBuffer];
    commandbuffer.label = @"drawmtkview";
    MTLRenderPassDescriptor *renderDsp = view.currentRenderPassDescriptor;
    id <CAMetalDrawable> drawable = view.currentDrawable;
   id<MTLRenderCommandEncoder> commandEncoder = [commandbuffer renderCommandEncoderWithDescriptor:renderDsp];
    [commandEncoder setRenderPipelineState:mPipelineState];
    [commandEncoder setVertexBuffer:mCommandBuffer offset:0 atIndex:0];
    
    [commandEncoder endEncoding];
    [commandbuffer presentDrawable:drawable];
    [commandbuffer commit];
}

@end
