//
//  ViewController.m
//  metalDemo0226
//
//  Created by 王洪飞 on 2019/2/26.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "ViewController.h"
#import "WFRender.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import "WFMetalView.h"

@interface ViewController ()
{
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WFMetalView *metalView = [[WFMetalView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:metalView];
}


@end
