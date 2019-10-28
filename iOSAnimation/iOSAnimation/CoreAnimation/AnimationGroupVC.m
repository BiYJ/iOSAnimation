//
//  AnimationGroupVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.
//

#import "AnimationGroupVC.h"

#define  w(divisor) (SCREEN_WIDTH / (divisor))
#define  h(divisor) (SCREEN_HEIGHT / (divisor))

static NSString * kBasicAnimationPropertyToValueKey = @"BasicAnimationPropertyToValueKey";
static NSString * kKeyframeAnimationPropertyEndPointKey = @"KeyframeAnimationPropertyEndPointKey";

@interface AnimationGroupVC () <CAAnimationDelegate>
{
    CALayer * __layer;
    CALayer * __orangeLayer;
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
    
    __orangeLayer = [[CALayer alloc] init];
    __orangeLayer.bounds = CGRectMake(0, 0, 50, 50);
    __orangeLayer.position = self.view.center;
    __orangeLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:__orangeLayer];
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


#pragma mark - BaseBtnPTC

- (void)btnClicked:(UIButton *)btn
{
    [__orangeLayer removeAllAnimations];
    
    switch (btn.tag) {
        case 0:  // 同时动画
        {
            // 旋转动画
            CABasicAnimation * rotationZ = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            // toValue = M_PI * 6 等效 toValue = M_PI * 2、duration = 2.0
//            rotationZ.toValue = @(M_PI * 6);
            rotationZ.toValue = @(M_PI * 2);
            rotationZ.duration = 2.0;
            rotationZ.repeatCount = HUGE_VALF;
            
            // 缩放动画。keyPath = @"transform" 时，设置 fromValue 导致动画不生效
            CABasicAnimation * scaleXY = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            //scaleXY.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)];
            //scaleXY.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)];
            scaleXY.fromValue = @(0.8);
            scaleXY.toValue   = @(2.0);
            
            // 位移动画
            CAKeyframeAnimation * position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue * value0 = [NSValue valueWithCGPoint:CGPointMake(0, h(2.0) - 50)];
            NSValue * value1 = [NSValue valueWithCGPoint:CGPointMake(w(3.0), h(2.0) - 50)];
            NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake(w(3.0), h(2.0) + 50)];
            NSValue * value3 = [NSValue valueWithCGPoint:CGPointMake(w(3.0/2), h(2.0) + 50)];
            NSValue * value4 = [NSValue valueWithCGPoint:CGPointMake(w(3.0/2), h(2.0) - 50)];
            NSValue * value5 = [NSValue valueWithCGPoint:CGPointMake(w(1.0), h(2.0) - 50)];
            position.values = @[ value0, value1, value2, value3, value4, value5 ];
            
            CAAnimationGroup * group = [CAAnimationGroup animation];
            group.animations = @[ rotationZ, scaleXY, position];
            group.duration = 6.0;
            [__orangeLayer addAnimation:group forKey:@"ORANGELAYER_GROUP"];
            
            // 直接把三个动画添加到 layer 上，也相当于同时动画。这种时候不能自动终止 repeatCount = HUGE_VALF 的动画
//            [__orangeLayer addAnimation:rotationZ forKey:@"ORANGELAYER_ROTATION_Z"];
//            scaleXY.duration   = 6.0;
//            [__orangeLayer addAnimation:scaleXY forKey:@"ORANGELAYER_SCALE_XY"];
//            position.duration  = 6.0;
//            [__orangeLayer addAnimation:position forKey:@"ORANGLELAYER_POSITION"];
        }
            break;
            
        case 1:  // 连续动画
        {
            CFTimeInterval begin = CACurrentMediaTime();
            
            // 位移动画
            CABasicAnimation * position = [CABasicAnimation animationWithKeyPath:@"position"];
            position.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, h(2.0))];
            position.toValue   = [NSValue valueWithCGPoint:CGPointMake(w(2.0), h(2.0))];
            position.beginTime = begin;
            position.duration  = 1.0;
            position.fillMode  = kCAFillModeForwards;
            position.removedOnCompletion = NO;
            [__orangeLayer addAnimation:position forKey:@"ORANGELAYER_POSITION"];
            
            // 缩放动画
            CABasicAnimation * scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scale.fromValue = @(0.8);
            scale.toValue   = @(2.0);
            scale.beginTime = begin + 1.0;  // 动画开始时间
            scale.duration  = 1.0;
            scale.fillMode  = kCAFillModeForwards; // forwards 保留上次动画的状态；backwords 清除上次动画的状态
            scale.removedOnCompletion = NO;
            [__orangeLayer addAnimation:scale forKey:@"ORANGELAYER_SCALE"];
            
            // 旋转动画
            CABasicAnimation * rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotation.toValue   = @(M_PI * 4);
            rotation.beginTime = begin + 2.0;
            rotation.duration  = 1.0;
            rotation.fillMode  = kCAFillModeForwards;
            rotation.removedOnCompletion = NO;
            [__orangeLayer addAnimation:rotation forKey:@"ORANGELAYER_ROTATION"];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - GET

- (NSArray *)btnTitleArray
{
    return @[ @"同时动画", @"连续动画" ];
}

@end
