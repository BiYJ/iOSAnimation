//
//  BasicAnimationVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "BasicAnimationVC.h"

static NSString * kBasicAnimationTranslationKey = @"BaiscAnimationTranslationKey";
static NSString * kBasicAnimationRotationKey = @"BasicAnimationRotationKey";

/**   基础动画   **/
@interface BasicAnimationVC () <CAAnimationDelegate>
{
    CALayer * __layer;
    CALayer * __orangeLayer;
}
@property (nonatomic, strong) CALayer * layer;

@end


@implementation BasicAnimationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景（这个图片其实在根图层）
    UIImage * backgroundImage = [UIImage imageNamed:@"bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    __layer = [[CALayer alloc] init];
    __layer.frame = CGRectMake(100, 600, 17, 25.5);
    __layer.anchorPoint = CGPointMake(0.5, 0.6);  // 设置锚点
    __layer.contents = (id)[UIImage imageNamed:@"yhc"].CGImage;
    [self.view.layer addSublayer:__layer];
    
    __orangeLayer = [[CALayer alloc] init];
    __orangeLayer.position = self.view.center;
    __orangeLayer.bounds = CGRectMake(0, 0, 100, 100);
    __orangeLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:__orangeLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    // 判断是否已经创建过动画，如果已经创建则不再创建动画
    CAAnimation * animation = [__layer animationForKey:kBasicAnimationTranslationKey];
    
    if(animation){
        if (__layer.speed == 0) {
            [self animationResume];
        }
        else {
            [self animationPause];
        }
    }
    else {
        [self __translationAnimation:[touch locationInView:self.view]];
        [self __rotationAnimation];
    }
}

/**
  *  @brief   移动动画
  */
- (void)__translationAnimation:(CGPoint)location
{
    // ①、创建动画并指定动画属性
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // ②、设置动画属性初始值和结束值
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 600)];
    animation.toValue = [NSValue valueWithCGPoint:location];
    
    // 动画时间 5 秒
    animation.duration = 3;
    // 设置重复次数。HUGE_VALF 可看做无穷大，起到循环动画的效果
    //animation.repeatCount = HUGE_VALF;
    // 运行一次是否移除动画
    animation.removedOnCompletion = NO;
    
    // 代理
    animation.delegate = self;
    [animation setValue:[NSValue valueWithCGPoint:location] forKey:@"Location"];

    
    // ③、添加动画到图层，注意 key 相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [__layer addAnimation:animation forKey:kBasicAnimationTranslationKey];
}

/**
  *  @brief   旋转动画
  */
- (void)__rotationAnimation
{
    // ①、创建动画并指定动画属性
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // ②、设置动画属性初始值、结束值
    // animation.fromValue = [NSNumber numberWithInt:M_PI_2];
    animation.toValue = [NSNumber numberWithFloat:M_PI_2 * 3];
    
    animation.duration = 3.0;
    animation.autoreverses = YES; // 旋转后再旋转到原来的位置
    animation.repeatCount = HUGE_VALF; // 设置无限循环
    animation.removedOnCompletion = NO;
    
    // ③、添加动画到图层，注意 key 相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [__layer addAnimation:animation forKey:kBasicAnimationRotationKey];
}

/**
  *  @brief   动画暂停
  */
- (void)animationPause
{
    // 取得指定图层动画的媒体时间，后面参数用于指定子图层，这里不需要
    CFTimeInterval interval = [__layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 设置时间偏移量，保证暂停时停留在旋转的位置。如果设置为 0，__layer 会回到起始位置
    [__layer setTimeOffset:interval];
    // 速度设置为 0，暂停动画
    __layer.speed = 0;
}

/**
  *  @brief   动画恢复
  */
- (void)animationResume
{
    // 获得暂停的时间
    CFTimeInterval beginTime = CACurrentMediaTime() - __layer.timeOffset;
    // 设置偏移量
    __layer.timeOffset = 0;
    // 设置开始时间
    __layer.beginTime = beginTime;
    // 设置动画速度，开始运动
    __layer.speed = 1.0;
}


#pragma mark - CAAnimationDelegate
/**
  *  @brief   动画开始
  */
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

/**
  *  @brief   动画结束
  */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 图层动画的本质就是将图层内部的内容转化为位图经硬件操作形成一种动画效果，其实图层本身并没有任何的变化。
    NSLog(@"animation(%@) layer.position = %@", anim, NSStringFromCGPoint(__layer.position));
    
    // 开启动画事务
    [CATransaction begin];
    // 禁用隐式动画
    [CATransaction setDisableActions:YES];

    // 需要关闭隐式动画
    __layer.position = [[anim valueForKey:@"Location"] CGPointValue];

    // 提交动画事务
    [CATransaction commit];
}


#pragma mark - BaseBtnPTC

- (void)btnClicked:(UIButton *)btn
{
    [__orangeLayer removeAllAnimations];
    
    switch (btn.tag) {
        case 0:  // 位移
        {
            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT / 2)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
            animation.duration = 1.0;
            //如果 fillMode = kCAFillModeForwards 和 removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = YES;
            animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
            [__orangeLayer addAnimation:animation forKey:@"ORANGELAYER_POSITION"];
            
            //使用 UIView Animation 代码块调用
            [UIView animateWithDuration:1.0f animations:^{

            } completion:^(BOOL finished) {

            }];
        
            //使用 UIView  [begin, commit] 模式
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0f];
            // ...
            [UIView commitAnimations];
        }
            break;
            
        case 1:  // 透明度
        {
            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.fromValue = @(1);
            animation.toValue = @(0.2);
            animation.duration = 1.0;
            [__orangeLayer addAnimation:animation forKey:@"ORANGELAYER_OPACITY"];
        }
            break;
            
        case 2:  // 缩放
        {
            // ①、修改 bounds
//            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
//            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
//            animation.duration = 1.0f;
//            [__orangeLayer addAnimation:animation forKey:@"ORANGELAYER_BOUNDS"];
            
            // ②、设置变换矩阵
            CABasicAnimation * animtion = [CABasicAnimation animationWithKeyPath:@"transform"];
            animtion.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
            animtion.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
            animtion.duration = 1.0;
            [__orangeLayer addAnimation:animtion forKey:@"ORANGELAYER_TRANSFORM"];
            
            // ③、只针对 x 缩放
//            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
//            animation.toValue = @(0.5);
//            animation.duration = 1.0;
//            [__orangeLayer addAnimation:animation forKey:@"ORANGELAYER_TRANSFORM_SCALE_X"];
        }
            break;
            
        case 3:  // 旋转
        {
            // 绕着 z 轴为矢量，进行旋转
            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            animation.toValue = @(M_PI);
            animation.duration = 1;
            [__orangeLayer addAnimation:animation forKey:@"READLAYER_TRANSFORM_RORATION_Z"];
        }
            break;
        
        case 4:  // 背景色
        {
            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
            animation.toValue = (id)[UIColor greenColor].CGColor;
            animation.duration = 1.0;
            [__orangeLayer addAnimation:animation forKey:@"ORANGELAYER_BACKGROUNDCOLOR"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - GET

- (NSArray *)btnTitleArray
{
    return @[ @"位移", @"透明度", @"缩放", @"旋转", @"背景色" ];
}

@end
