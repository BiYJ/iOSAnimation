//
//  CustomLayer.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "CustomLayer.h"

@implementation CustomLayer

- (void)drawInContext:(CGContextRef)ctx
{
    NSLog(@"%s : %@", __func__, ctx);
    
    CGContextSetRGBFillColor(ctx, 135.0/255.0, 232.0/255.0, 84.0/255.0, 1);
    CGContextSetRGBStrokeColor(ctx, 135.0/255.0, 232.0/255.0, 84.0/255.0, 1);
    CGContextMoveToPoint(ctx, 94.5, 33.5);
    
    // 绘制星星
    CGContextAddLineToPoint(ctx, 104.02, 47.39);
    CGContextAddLineToPoint(ctx, 120.18, 52.16);
    CGContextAddLineToPoint(ctx, 109.91, 65.51);
    CGContextAddLineToPoint(ctx, 110.37, 82.34);
    CGContextAddLineToPoint(ctx, 94.5, 76.7);
    CGContextAddLineToPoint(ctx, 78.63, 82.34);
    CGContextAddLineToPoint(ctx, 79.09, 65.51);
    CGContextAddLineToPoint(ctx, 68.82, 52.16);
    CGContextAddLineToPoint(ctx, 84.98, 47.39);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end
