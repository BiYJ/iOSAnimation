//
//  DrawQQVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/28.
//  Copyright © 2019年 D. All rights reserved.


#import "DrawQQVC.h"

#define DURATION   1.0  // 动画时长

@interface DrawQQVC () <CAAnimationDelegate>
{
    CAShapeLayer * __starLayer;
    UIBezierPath * __starPath1;
    UIBezierPath * __starPath2;
}
@property (weak, nonatomic) IBOutlet UIView * canvasView;

@end


@implementation DrawQQVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self __startDrawStar];
    [self __startDrawQQ];
}


#pragma mark - Star
/**
  *  @brief   绘制星星✨✨
  */
- (void)__startDrawStar
{
    __starLayer = [CAShapeLayer layer];
    __starLayer.frame = CGRectMake(40, 120, 60, 60);
    __starLayer.fillColor = [UIColor clearColor].CGColor;
    __starLayer.strokeColor = [UIColor redColor].CGColor;
    __starLayer.lineWidth = 2.0f;
    
    [self __addBezierPathAnimation];
    [self.view.layer addSublayer:__starLayer];
}

/**
  *  @brief   添加 bezierPath 的动画
  */
- (void)__addBezierPathAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.removedOnCompletion = NO;
    animation.duration  = 2;
    animation.fromValue = (__bridge id _Nullable)([self __getStarOneBezierPath].CGPath);
    animation.toValue = (__bridge id _Nullable)([self __getStarTwoBezierPath].CGPath);
    animation.autoreverses = YES;  // 自动来回动画，不需要定时器
    animation.repeatCount = HUGE_VALF;
    __starLayer.path = [self __getStarTwoBezierPath].CGPath;
    [__starLayer addAnimation:animation forKey:@"PATH_ANIMATION"];
}

/// 贝塞尔曲线1
- (UIBezierPath *)__getStarOneBezierPath
{
    if (__starPath1 == nil) {
        __starPath1 = [UIBezierPath bezierPath];
        [__starPath1 moveToPoint:CGPointMake(22.5, 2.5)];
        [__starPath1 addLineToPoint:CGPointMake(28.32, 14.49)];
        [__starPath1 addLineToPoint:CGPointMake(41.52, 16.32)];
        [__starPath1 addLineToPoint:CGPointMake(31.92, 25.56)];
        [__starPath1 addLineToPoint:CGPointMake(34.26, 38.68)];
        [__starPath1 addLineToPoint:CGPointMake(22.5,  32.4)];
        [__starPath1 addLineToPoint:CGPointMake(10.74, 38.68)];
        [__starPath1 addLineToPoint:CGPointMake(13.08, 25.56)];
        [__starPath1 addLineToPoint:CGPointMake(3.48,  16.32)];
        [__starPath1 addLineToPoint:CGPointMake(16.68, 14.49)];
        [__starPath1 closePath];
    }
    return __starPath1;
}

/// 贝塞尔曲线 2
- (UIBezierPath *)__getStarTwoBezierPath
{
    if (__starPath2 == nil) {
        __starPath2 = [UIBezierPath bezierPath];
        [__starPath2 moveToPoint:CGPointMake(22.5, 2.5)];
        [__starPath2 addLineToPoint:CGPointMake(32.15, 9.21)];
        [__starPath2 addLineToPoint:CGPointMake(41.52, 16.32)];
        [__starPath2 addLineToPoint:CGPointMake(38.12, 27.57)];
        [__starPath2 addLineToPoint:CGPointMake(34.26, 38.68)];
        [__starPath2 addLineToPoint:CGPointMake(22.5,  38.92)];
        [__starPath2 addLineToPoint:CGPointMake(10.74, 38.68)];
        [__starPath2 addLineToPoint:CGPointMake(6.88,  27.57)];
        [__starPath2 addLineToPoint:CGPointMake(3.48,  16.32)];
        [__starPath2 addLineToPoint:CGPointMake(12.85, 9.21)];
        [__starPath2 closePath];
    }
    return __starPath2;
}


#pragma mark - QQ
/**
  *  @brief  开始绘制
  */
- (void)__startDrawQQ
{
    CFTimeInterval beginTime = CACurrentMediaTime();
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    // 头型
    [path moveToPoint:CGPointMake(55, 110)];
    [path addQuadCurveToPoint:CGPointMake(128, 10)  controlPoint:CGPointMake(60, 13)];
    [path addQuadCurveToPoint:CGPointMake(203, 110) controlPoint:CGPointMake(198, 13)];
    [path addQuadCurveToPoint:CGPointMake(55, 110) controlPoint:CGPointMake(128, 135)];
    // 左眼（为了左眼绘制的慢一些，所以使用下面的代码，将每个部件分开绘制）
    //[path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(95, 38, 27, 37)]];

    CAShapeLayer * headShape = [self __getStrokeShapeLayerWithPath:path.CGPath];
    [self __addStrokeEndAnimationToLayer:headShape beginTime:beginTime];

    beginTime += DURATION;
    
    // 左眼
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(95, 38, 27, 37)];
    CAShapeLayer * lEyeShape = [self __getStrokeShapeLayerWithPath:path.CGPath];
    [self __addStrokeEndAnimationToLayer:lEyeShape beginTime:beginTime];
    
    beginTime += DURATION;
    
    // 左眼珠
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(107, 51, 11, 16)];
    CAShapeLayer * lEyeBallShape = [self __getFillColorShapeLayerWithPath:path.CGPath];
    [self __addFillColorAnimationToLayer:lEyeBallShape beginTime:beginTime];
    
    beginTime += DURATION;

    // 右眼
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(135, 38, 27, 37)];
    CAShapeLayer * rEyeShape = [self __getStrokeShapeLayerWithPath:path.CGPath];
    [self __addStrokeEndAnimationToLayer:rEyeShape beginTime:beginTime];
    
    beginTime += DURATION;

    // 右眼珠
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(139, 60)];
    [path addQuadCurveToPoint:CGPointMake(155, 56) controlPoint:CGPointMake(145, 51)];
    [path addLineToPoint:CGPointMake(154, 60)];
    [path addQuadCurveToPoint:CGPointMake(140, 61) controlPoint:CGPointMake(146, 52)];
    CAShapeLayer * rEyeBallShape = [self __getFillColorShapeLayerWithPath:path.CGPath];
    [self __addFillColorAnimationToLayer:rEyeBallShape beginTime:beginTime];
    
    beginTime += DURATION;

    // 嘴
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(82, 92)];
    [path addQuadCurveToPoint:CGPointMake(174, 92) controlPoint:CGPointMake(128, 78)];
    [path addQuadCurveToPoint:CGPointMake(82, 92) controlPoint:CGPointMake(128, 130)];
    CAShapeLayer * mouseShape = [self __getStrokeShapeLayerWithPath:path.CGPath];
    [self __addStrokeEndAnimationToLayer:mouseShape beginTime:beginTime];
    
    beginTime += DURATION;

    // 围巾
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(55, 110)];
    [path addQuadCurveToPoint:CGPointMake(203, 110) controlPoint:CGPointMake(128, 135)];
    [path addLineToPoint:CGPointMake(213, 135)];
    [path addQuadCurveToPoint:CGPointMake(114, 148) controlPoint:CGPointMake(155, 155)];
    [path addLineToPoint:CGPointMake(114, 180)];
    [path addQuadCurveToPoint:CGPointMake(81, 178)  controlPoint:CGPointMake(99, 182)];
    [path addLineToPoint:CGPointMake(81, 144)];
    [path addQuadCurveToPoint:CGPointMake(44, 135)  controlPoint:CGPointMake(62, 141)];
    [path closePath];
    CAShapeLayer * scarfShape = [self __getStrokeShapeLayerWithPath:path.CGPath];
    [self __addStrokeEndAnimationToLayer:scarfShape beginTime:beginTime];
    
    beginTime += DURATION;

    // 左 右胳膊
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(44, 135)];
    [path addLineToPoint:CGPointMake(33, 171)];
    [path addQuadCurveToPoint:CGPointMake(31, 204)  controlPoint:CGPointMake(25, 191)];
    [path addQuadCurveToPoint:CGPointMake(52, 180)  controlPoint:CGPointMake(41, 200)];
    [path addQuadCurveToPoint:CGPointMake(128, 244) controlPoint:CGPointMake(75, 250)];
    [path addQuadCurveToPoint:CGPointMake(204, 180) controlPoint:CGPointMake(181, 250)];
    [path addQuadCurveToPoint:CGPointMake(225, 204) controlPoint:CGPointMake(214, 200)];
    [path addQuadCurveToPoint:CGPointMake(223, 171) controlPoint:CGPointMake(231, 191)];
    [path addLineToPoint:CGPointMake(212, 135)];
    // 肚子
    [path addQuadCurveToPoint:CGPointMake(183, 145) controlPoint:CGPointMake(198, 140)];
    [path addCurveToPoint:CGPointMake(128, 235) controlPoint1:CGPointMake(190, 183) controlPoint2:CGPointMake(171, 240)];
    [path addCurveToPoint:CGPointMake(73, 143) controlPoint1:CGPointMake(85, 240) controlPoint2:CGPointMake(66, 183)];
    [path addQuadCurveToPoint:CGPointMake(44, 135) controlPoint:CGPointMake(58, 140)];
    
    CAShapeLayer * armBellyShape = [self __getStrokeShapeLayerWithPath:path.CGPath];
    [self __addStrokeEndAnimationToLayer:armBellyShape beginTime:beginTime];
    
    beginTime += DURATION;

    // 左脚
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(77, 227)];
    [path addQuadCurveToPoint:CGPointMake(56, 237)  controlPoint:CGPointMake(64, 231)];
    [path addQuadCurveToPoint:CGPointMake(56, 242)  controlPoint:CGPointMake(50, 239)];
    [path addQuadCurveToPoint:CGPointMake(126, 244) controlPoint:CGPointMake(91, 248)];
    [path addQuadCurveToPoint:CGPointMake(77, 227)  controlPoint:CGPointMake(96, 244)];
    CAShapeLayer * lLegShape = [self __getStrokeShapeLayerWithPath:path.CGPath];
    [self __addStrokeEndAnimationToLayer:lLegShape beginTime:beginTime];
    
    beginTime += DURATION;

    // 右脚
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(179, 227)];
    [path addQuadCurveToPoint:CGPointMake(200, 237)  controlPoint:CGPointMake(192, 231)];
    [path addQuadCurveToPoint:CGPointMake(200, 242)  controlPoint:CGPointMake(206, 239)];
    [path addQuadCurveToPoint:CGPointMake(130, 244) controlPoint:CGPointMake(165, 248)];
    [path addQuadCurveToPoint:CGPointMake(179, 227)  controlPoint:CGPointMake(160, 244)];
    CAShapeLayer * rLegShape = [self __getStrokeShapeLayerWithPath:path.CGPath];
    [self __addStrokeEndAnimationToLayer:rLegShape beginTime:beginTime];

    beginTime += DURATION;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        headShape.fillColor = UIColor.blackColor.CGColor;
        lEyeShape.fillColor = UIColor.whiteColor.CGColor;
        rEyeShape.fillColor = UIColor.whiteColor.CGColor;
        mouseShape.fillColor = RGB(246, 146, 12).CGColor;
        armBellyShape.fillColor = UIColor.blackColor.CGColor;
        lLegShape.fillColor  = RGB(246, 146, 12).CGColor;
        rLegShape.fillColor  = RGB(246, 146, 12).CGColor;
        scarfShape.fillColor = RGB(223, 0, 25).CGColor;
        scarfShape.lineWidth = 0;
        lLegShape.lineWidth  = 0;
        rLegShape.lineWidth  = 0;
    });
}

/**
  *  @brief   添加线条绘制动画
  */
- (void)__addStrokeEndAnimationToLayer:(CALayer *)layer
                             beginTime:(CFTimeInterval)beginTime
{
    if (!layer)
        return;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue   = @(1);
    animation.beginTime = beginTime;
    animation.duration  = DURATION;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    
    [animation setValue:layer forKey:@"AnimationLayer"];
    [layer addAnimation:animation forKey:@"STROKE_END_ANIMATION"];
}

/**
 *  @brief   添加颜色填充动画
 */
- (void)__addFillColorAnimationToLayer:(CALayer *)layer
                             beginTime:(CFTimeInterval)beginTime
{
    if (!layer)
        return;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.fromValue = (id)UIColor.clearColor.CGColor;
    animation.toValue   = (id)UIColor.blackColor.CGColor;
    animation.beginTime = beginTime;
    animation.duration  = DURATION;
    animation.removedOnCompletion = NO;
    animation.fillMode  = kCAFillModeForwards;
    animation.delegate  = self;
    
    [animation setValue:layer forKey:@"AnimationLayer"];
    [layer addAnimation:animation forKey:@"FILL_COLOR_ANIMATION"];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    CAShapeLayer * layer = [anim valueForKey:@"AnimationLayer"];
    layer.opacity = 1;
}


#pragma mark - GET
/**
  *  @brief   返回路径绘制的图层
  */
- (CAShapeLayer *)__getStrokeShapeLayerWithPath:(CGPathRef)path
{
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.lineWidth   = 1.5;
    shape.strokeColor = UIColor.blackColor.CGColor;
    shape.fillColor   = UIColor.clearColor.CGColor;
    shape.opacity     = 0; // 隐藏
    shape.path = path;
    
    [self.canvasView.layer addSublayer:shape];

    return shape;
}

/**
  *  @brief   返回颜色填充的图层
  */
- (CAShapeLayer *)__getFillColorShapeLayerWithPath:(CGPathRef)path
{
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.opacity = 0;  // 隐藏
    shape.path = path;
    
    [self.canvasView.layer addSublayer:shape];
    
    return shape;
}

@end
