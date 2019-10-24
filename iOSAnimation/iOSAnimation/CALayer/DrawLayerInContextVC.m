//
//  DrawLayerInContextVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "DrawLayerInContextVC.h"

#define LAYER_WIDTH   150.0

/**    代理方法绘图。如果是单张图的话，也可以通过设置 layer.contents 实现效果    **/
@interface DrawLayerInContextVC () <CALayerDelegate>

@end


@implementation DrawLayerInContextVC

- (void)dealloc
{
    // 移除子图层，同时移除 delegate 的联系
    [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self __drawLayerWithMasksToBounds_NO];
    [self __drawLayerWithMasksToBounds_YES];
    [self __drawShadowCornerLayer];
}

/**
  *  @brief    masksToBounds = NO
  */
- (void)__drawLayerWithMasksToBounds_NO
{
    CALayer * layer = [self genLayer];
    layer.position = CGPointMake(self.view.center.x, self.view.center.y - LAYER_WIDTH - 40);
    layer.masksToBounds = NO;
    layer.shadowColor  = [UIColor redColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, -8);
    layer.shadowOpacity = 1;
    // 方式 ①、利用图层形变解决图像倒立问题
    //layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    // 方式 ②、通过 keyPath 进行设置图层形变
    //[layer setValue:@(M_PI) forKeyPath:@"transform.rotation.x"];
    
    [layer setNeedsDisplay];
}

/**
  *  @brief    masksToBounds = YES
  */
- (void)__drawLayerWithMasksToBounds_YES
{
    CALayer * layer = [self genLayer];
    layer.position = CGPointMake(self.view.center.x, self.view.center.y);
    /*  masksToBounds
     
             注意：仅仅设置圆角，对于图层而言可以正常显示，但是对于图层中绘制的图片无法正确显示。如果想要正确显示，则必须设置masksToBounds = YES 剪切子图层
             原因：当绘制一张图片到图层上的时候会重新创建一个图层添加到当前图层，这样一来如果设置了圆角之后虽然底图层有圆角效果，但是子图层还是矩形，只有设置了 masksToBounds 为 YES 让子图层按底图层剪切才能显示圆角效果。同样的，UIImageView 的 layer 设置圆角后图片无法显示圆角，只有设置 masksToBounds 才能出现效果，也是类似的问题。
         */
    layer.masksToBounds = YES;
    // 注意：阴影效果无法和 masksToBounds = YES 同时使用，因为 masksToBounds 的目的是剪切外边框，而阴影效果正好在外边框
    layer.shadowColor  = [UIColor redColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, -8);
    layer.shadowOpacity = 1;
    
    // 调用图层 setNeedsDisplay 方法，否则代理方法不会执行
    [layer setNeedsDisplay];
}

/**
  *  @brief   绘制圆角、阴影的图层
  */
- (void)__drawShadowCornerLayer
{
    // 负责阴影的图层
    CALayer * shadowLayer = [self genLayer];
    shadowLayer.position = CGPointMake(self.view.center.x, self.view.center.y + LAYER_WIDTH + 40);
    shadowLayer.masksToBounds = NO;
    shadowLayer.shadowColor  = [UIColor redColor].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(0, -8);
    shadowLayer.shadowOpacity = 1;
    
    // 负责圆角的图层
    CALayer * cornerLayer = [self genLayer];
    cornerLayer.position = CGPointMake(self.view.center.x, self.view.center.y + LAYER_WIDTH + 40);
    cornerLayer.masksToBounds = YES;
    
    [cornerLayer setNeedsDisplay];
}


#pragma mark - CALayerDelegate
/**
  *  @brief   绘制图形、图像到图层
  *  @param   ctx   当前图层的图形上下文，其中绘图位置也是相对图层而言的
  *
  *  @discussion   iOS目前有五种 context
                                         - Bitmap Graphics Context
                                         - PDF Graphics Context
                                         - Window Graphics Context
                                         - Layer Graphics Context
                                         - Printer Graphics Context
 
         1、UIGraphicsGetCurrentContext 默认返回时 y 轴向下的坐标系
         2、UIImage 的 DrawRect 是经过处理的 y 轴向下的坐标系
         3、CGContextDrawImage 是 y 轴向上的坐标系
         4、UIGraphicsBeginImageContextWithOptions 是 y 轴向上的坐标系
  */
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    // 保存当前状态，以后的操作都基于保存时的坐标系再转换变更
    CGContextSaveGState(ctx);
    
    // 方式 ③：图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);  // Changes the scale of the user coordinate system in a context.
    CGContextTranslateCTM(ctx, 0, -LAYER_WIDTH);
    // 参数 2 相对于图层而不是屏幕
    CGContextDrawImage(ctx, layer.bounds, [UIImage imageNamed:@"hy"].CGImage);
    
    // 恢复坐标系到 CGContextSaveGState 时的状态（两者之间的坐标系变更失效）
    CGContextRestoreGState(ctx);
}


#pragma mark - GET
/**
  *  @brief   返回图层实例
  */
- (CALayer *)genLayer
{
    CALayer * layer = [[CALayer alloc] init];
    layer.bounds          = CGRectMake(0, 0, LAYER_WIDTH, LAYER_WIDTH);
    layer.backgroundColor = UIColor.orangeColor.CGColor;
    layer.cornerRadius    = LAYER_WIDTH/2.0;
    layer.borderColor     = UIColor.grayColor.CGColor;
    layer.borderWidth     = 2;
    layer.delegate        = self; // 设置图层代理

    [self.view.layer addSublayer:layer];
    
    return layer;
}

@end
