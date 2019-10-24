//
//  CustomView.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.
//

#import "CustomView.h"
#import "CustomLayer.h"


@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CustomLayer * layer = [[CustomLayer alloc] init];
        layer.bounds   = CGRectMake(0, 0, 185, 185);
        layer.position = CGPointMake(160, 284);
        layer.backgroundColor = [UIColor colorWithRed:0 green:0.4 blue:0.95 alpha:1.0].CGColor;
        
        // 触发 layer 的 drawInContext: 方法，显示图层
        [layer setNeedsDisplay];
        
        [self.layer addSublayer:layer];
    }
    return self;
}


/**
  *  @brief   UIView 在显示时，其根图层会自动创建一个 CGContextRef（CALayer 本质使用的是位图上下文 kCGContextTypeBitmap），同时调用图层代理（UIView 创建图层会自动设置图层代理为其自身）的 drawLayer:inContext: 方法并将图形上下文作为参数传递给这个方法。而在 UIView 的 drawLayer:inContext: 方法中会调用其 drawRect: 方法，在 drawRect: 方法中使用 UIGraphicsGetCurrentContext() 方法得到的上下文正是前面创建的上下文。
 
             -[CustomView drawLayer:inContext:] : <CGContext 0x600000f98a80> (kCGContextTypeUnknown)
             -[CustomView drawRect:] : <CGContext 0x600000f98a80> (kCGContextTypeUnknown)
 
             -[CustomLayer drawInContext:] : <CGContext 0x600000f9db00> (kCGContextTypeBitmap)
             <<CGColorSpace 0x600001e845a0> (kCGColorSpaceICCBased; kCGColorSpaceModelRGB; sRGB IEC61966-2.1)>
             width = 185, height = 185, bpc = 8, bpp = 32, row bytes = 768
             kCGImageAlphaPremultipliedFirst | kCGImageByteOrder32Little
  */
- (void)drawRect:(CGRect)rect
{
    NSLog(@"%s : %@", __func__, UIGraphicsGetCurrentContext());
    
    [super drawRect:rect];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    NSLog(@"%s : %@", __FUNCTION__, ctx);
    
    [super drawLayer:layer inContext:ctx];
}

@end
