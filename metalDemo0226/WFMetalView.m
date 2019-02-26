//
//  WFMetalView.m
//  metalDemo0226
//
//  Created by 王洪飞 on 2019/2/26.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "WFMetalView.h"
#import <MetalKit/MetalKit.h>
#import "shadertypes.h"

@interface WFMetalView()
{
    id <MTLDevice> mdevice;
    id<MTLCommandQueue> mCommandQueue;
    CAMetalLayer *mMetalLayer;
    id <MTLRenderPipelineState> mPiplelineState;
}
@property(nonatomic, strong) CAMetalLayer *metallayer;


@end

@implementation WFMetalView

+(Class)layerClass{
    return [CAMetalLayer class];
}

-(CAMetalLayer *)metallayer{
    return (CAMetalLayer *)self.layer;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor cyanColor];
        [self commit];
    }
    return self;
}

-(void)commit{
    mdevice = MTLCreateSystemDefaultDevice();
    mCommandQueue = [mdevice newCommandQueue];
    self.metallayer = [CAMetalLayer new];
//    [self.layer addSublayer:self.metallayer];
//    self.metallayer.frame = [UIScreen mainScreen].bounds;
    self.metallayer.device = mdevice;
    [self setupPipeline];
}

-(void)setupPipeline {
    id <MTLLibrary> library = [mdevice newDefaultLibrary];
    id<MTLFunction> vertfunc = [library newFunctionWithName:@"vertexfunction"];
    id<MTLFunction> fragmentFunc = [library newFunctionWithName:@"fragmentshader"];
    
    
    MTLRenderPipelineDescriptor *pipelineDsp = [MTLRenderPipelineDescriptor new];
    pipelineDsp.vertexFunction = vertfunc;
    pipelineDsp.fragmentFunction = fragmentFunc;
    pipelineDsp.colorAttachments[0].pixelFormat = self.metallayer.pixelFormat;
    NSError *error = nil;
    mPiplelineState = [mdevice newRenderPipelineStateWithDescriptor:pipelineDsp error:&error];
    
}

-(void)didMoveToWindow {
    [super didMoveToWindow];
    [self render];
}

-(void)render {
    id<CAMetalDrawable> drawable = [self.metallayer nextDrawable];
    if (!drawable) {
        return;
    }
    
    MTLRenderPassDescriptor *renderpassDsp = [MTLRenderPassDescriptor renderPassDescriptor];
    renderpassDsp.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1);
    renderpassDsp.colorAttachments[0].texture = drawable.texture;
    renderpassDsp.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderpassDsp.colorAttachments[0].storeAction = MTLStoreActionStore;
    
    id <MTLCommandBuffer> commandBuffer = [mCommandQueue commandBuffer];
    id<MTLRenderCommandEncoder>commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderpassDsp];
    
    static const WFVertex vertexs[] = {
        { .position = {  0.5, -0.5 }, .color = { 1, 0, 0, 1 } },
        { .position = { -0.5, -0.5 }, .color = { 0, 1, 0, 1 } },
        { .position = {  0.0,  0.5 }, .color = { 0, 0, 1, 1 } }
    };
    
    [commandEncoder setRenderPipelineState:mPiplelineState];
    [commandEncoder setVertexBytes:vertexs length:sizeof(WFVertex)*3 atIndex:0];
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:3];
    
    [commandEncoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
