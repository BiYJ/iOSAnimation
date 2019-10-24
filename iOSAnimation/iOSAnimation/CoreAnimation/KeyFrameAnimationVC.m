//
//  KeyFrameAnimationVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "KeyFrameAnimationVC.h"

static NSString * kKeyFrameAnimationTranslationKey = @"KeyFrameAnimationTranslationKey";


@interface KeyFrameAnimationVC ()
{
    CALayer * __layer;
}
@end


@implementation KeyFrameAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景（这个图片其实在根图层）
    UIImage * backgroundImage = [UIImage imageNamed:@"bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    __layer = [[CALayer alloc]init];
    __layer.frame = CGRectMake(100, 600, 17, 25.5);
    __layer.contents = (id)[UIImage imageNamed:@"yhc"].CGImage;
    [self.view.layer addSublayer:__layer];
    
    // 创建动画
    [self __translationAnimation];
}

/**
  *  @brief   关键帧动画：移动
  */
- (void)__translationAnimation
{
    // ①、创建关键帧动画并设置动画属性
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // ②、设置关键帧
    NSValue * key1 = [NSValue valueWithCGPoint:__layer.position];  // 对于关键帧动画初始值不能省略
    NSValue * key2 = [NSValue valueWithCGPoint:CGPointMake(50, 450)];
    NSValue * key3 = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    NSValue * key4 = [NSValue valueWithCGPoint:CGPointMake(300, 400)];
    animation.values = @[ key1, key2, key3, key4 ];
    
    // ②、设置关键帧路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, __layer.position.x, __layer.position.y);
    CGPathAddCurveToPoint(path, NULL, 0, 540, 150, 520, 50, 450);
    CGPathAddCurveToPoint(path, NULL, 20, 250, 220, 500, 200, 300);
    CGPathAddCurveToPoint(path, NULL, 280, 250, 220, 450, 300, 400);
    animation.path = path; // 设置 path 属性
    CGPathRelease(path);   // 释放路径对象
    
    // 设置其他属性
    animation.duration = 5.0;
    animation.beginTime = CACurrentMediaTime() + 2; // 延迟 2 秒执行
    animation.keyTimes = @[ @(0.4), @(0.75), @(1.0) ];
    /**
                    kCAAnimationLinear  默认的，线性执行
                    kCAAnimationDiscrete  离散的，从第 1 帧经过 0.4 * 5 秒直接到第 2 帧，中间没有任何过渡。
                    kCAAnimationPaced  均匀执行，会忽略keyTimes
                    kCAAnimationCubic  平滑执行，对于位置变动关键帧动画运行轨迹更平滑
                    kCAAnimationCubicPaced  平滑均匀执行
            */
    animation.calculationMode = kCAAnimationPaced;
    
    // ③、添加动画到图层，添加动画后就会执行动画
    [__layer addAnimation:animation forKey:kKeyFrameAnimationTranslationKey];

    
    CAShapeLayer * shape = [[CAShapeLayer alloc] init];
    shape.frame = self.view.bounds;
    shape.path = path;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:shape];
}

@end
