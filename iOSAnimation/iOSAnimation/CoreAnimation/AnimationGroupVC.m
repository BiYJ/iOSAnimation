//
//  AnimationGroupVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.
//

#import "AnimationGroupVC.h"

static NSString * kBasicAnimationPropertyToValueKey = @"BasicAnimationPropertyToValueKey";
static NSString * kKeyframeAnimationPropertyEndPointKey = @"KeyframeAnimationPropertyEndPointKey";


@interface AnimationGroupVC () <CAAnimationDelegate>
{
    CALayer * __layer;
}
@end

@implementation AnimationGroupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景（这个图片其实在根图层）
    UIImage * backgroundImage = [UIImage imageNamed:@"bg"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:backgroundImage];
    
    __layer = [[CALayer alloc]init];
    __layer.frame = CGRectMake(100, 150, 17, 25.5);
    __layer.contents = (id)[UIImage imageNamed:@"yhc"].CGImage;
    [self.view.layer addSublayer:__layer];
    
    // 创建动画
    [self __groupAnimation];
}

/**
  *  @brief   基础旋转动画
  */
- (CABasicAnimation *)__rotationAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:M_PI_2 * 3];
    
    animation.autoreverses = YES;
    animation.repeatCount  = HUGE_VALF;
    animation.removedOnCompletion = NO;
    
    [animation setValue:[NSNumber numberWithFloat:M_PI_2 * 3] forKey:kBasicAnimationPropertyToValueKey];
    
    return animation;
}

/**
  *  @brief   关键帧移动动画
  */
- (CAKeyframeAnimation *)__translationAnimation
{
    CGPoint endPoint = CGPointMake(105, 600);

    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, __layer.position.x, __layer.position.y);
    CGPathAddCurveToPoint(path, NULL, 250, 390, -30, 440, endPoint.x, endPoint.y);
    animation.path = path;
    CGPathRelease(path);
    
    [animation setValue:[NSValue valueWithCGPoint:endPoint] forKey:kKeyframeAnimationPropertyEndPointKey];
    
    CAShapeLayer * shape = [[CAShapeLayer alloc] init];
    shape.frame = self.view.bounds;
    shape.path = path;
    shape.lineWidth = 2;
    shape.strokeColor = UIColor.whiteColor.CGColor;
    shape.fillColor = UIColor.clearColor.CGColor;
    [self.view.layer addSublayer:shape];
    
    return animation;
}

/**
  *  @brief   创建动画组
  */
-(void)__groupAnimation
{
    // ①、创建动画组
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    
    // ②、设置组中的动画和其他属性
    CABasicAnimation * basicAnimation = [self __rotationAnimation];
    CAKeyframeAnimation * keyframeAnimation = [self __translationAnimation];
    animationGroup.animations = @[basicAnimation, keyframeAnimation];
    
    animationGroup.delegate  = self;
    animationGroup.duration  = 10.0;  // 设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
    animationGroup.beginTime = CACurrentMediaTime() + 2; // 延迟 2 秒执行
    
    // ③、给图层添加动画
    [__layer addAnimation:animationGroup forKey:nil];
}


#pragma mark - CAAnimationDelegate
/**
  *  @brief  动画完成
  */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAAnimationGroup * animationGroup = (CAAnimationGroup *)anim;
    
    CABasicAnimation * basicAnimation = (CABasicAnimation *)animationGroup.animations[0];
    CAKeyframeAnimation * keyframeAnimation = (CAKeyframeAnimation *)animationGroup.animations[1];
    
    CGFloat toValue = [[basicAnimation valueForKey:kBasicAnimationPropertyToValueKey] floatValue];
    CGPoint endPoint = [[keyframeAnimation valueForKey:kKeyframeAnimationPropertyEndPointKey] CGPointValue];
    
    // 开启事务
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    // 设置动画最终状态
    __layer.position = endPoint;
    __layer.transform = CATransform3DMakeRotation(toValue, 0, 0, 1);
    
    // 提交事务
    [CATransaction commit];
}

@end
