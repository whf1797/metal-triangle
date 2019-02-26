//
//  WFRender.h
//  metalDemo0226
//
//  Created by 王洪飞 on 2019/2/26.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WFRender : NSObject
-(instancetype)initWithMtkView:(nonnull MTKView *)mtkView;
@end

NS_ASSUME_NONNULL_END
