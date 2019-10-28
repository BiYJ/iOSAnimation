//
//  TransitionAnimationVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "TransitionAnimationVC.h"

#define IMAGE_COUNT 5

@interface TransitionAnimationVC ()
{
    UIImageView * __imageView;
    int __curIndex;
    
    CALayer * __orangeLayer;
    int __colorIndex;
}
@property (nonatomic, copy) NSArray<UIColor *> * colorArray;

@end


@implementation TransitionAnimationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 定义图片控件
    __imageView = [[UIImageView alloc] init];
    __imageView.frame = [UIScreen mainScreen].applicationFrame;
    __imageView.contentMode = UIViewContentModeScaleAspectFit;
    __imageView.image = [UIImage imageNamed:@"0.jpg"]; // 默认图片
    [self.view addSubview:__imageView];
    [self.view sendSubviewToBack:__imageView];
    
    // 添加滑动手势
    UISwipeGestureRecognizer * lSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(leftSwipe:)];
    lSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:lSwipe];
    
    UISwipeGestureRecognizer * rSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                        action:@selector(rightSwipe:)];
    rSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rSwipe];
    
    __orangeLayer = [[CALayer alloc] init];
    __orangeLayer.position = self.view.center;
    __orangeLayer.bounds = CGRectMake(0, 0, 180, 260);
    __orangeLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:__orangeLayer];
}

/**
  *  @brief   向左滑动浏览下一张图片
  */
- (void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self __transitionAnimation:YES];
}

/**
  *  @brief   向右滑动浏览上一张图片
  */
- (void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self __transitionAnimation:NO];
}


/**
  *  @brief   转场动画
  */
-(void)__transitionAnimation:(BOOL)isNext
{
    // ①、创建转场动画对象
    CATransition * transition = [[CATransition alloc] init];
    
    // ②、设置动画类型，对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
    transition.type = @"cube";
    
    // 设置子类型
    if (isNext) {
        transition.subtype = kCATransitionFromRight;
    }
    else {
        transition.subtype = kCATransitionFromLeft;
    }
    // 设置动画时常
    transition.duration = 1.0f;
    
    // ③、设置转场后的新视图添加转场动画
    __imageView.image = [self getImage:isNext];
    [__imageView.layer addAnimation:transition forKey:@"TransitionAnimationKey"];
}

/**
  *  @brief   取得当前图片
  */
-(UIImage *)getImage:(BOOL)isNext
{
    if (isNext) {
        __curIndex = (__curIndex + 1) % IMAGE_COUNT;
    }
    else {
        __curIndex = (__curIndex - 1 + IMAGE_COUNT) % IMAGE_COUNT;
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", __curIndex]];
}


#pragma mark - BaseBtnPTC

- (void)btnClicked:(UIButton *)btn
{
    [__orangeLayer removeAllAnimations];
    
    [self __updateLayerBackgroundColor];
    
    CATransition * transition = [CATransition animation];
    transition.subtype = kCATransitionFromRight; // 动画方向
    transition.duration = 1.0;
    transition.startProgress = 0.3;
    transition.endProgress = 0.8;

    switch (btn.tag) {
        case 0:  // fade
            transition.type = kCATransitionFade;  // 动画类型
            break;
            
        case 1:  // moveIn
            transition.type = kCATransitionMoveIn;
            break;
    
        case 2:  // push
            transition.type = kCATransitionPush;
            break;
            
        case 3:  // reveal
            transition.type = kCATransitionReveal;
            break;
            
        case 4:  // cube
            transition.type = @"cube";
            break;
            
        case 5:  // suck
            transition.type = @"suckEffect";
            break;
            
        case 6:  // oglFlip
            transition.type = @"oglFlip";
            break;
            
        case 7:  // ripple
            transition.type = @"rippleEffect";
            break;
            
        case 8:  // Curl
            transition.type = @"pageCurl";
            break;
            
        case 9:  // UnCurl
            transition.type = @"pageUnCurl";
            break;
            
        case 10:  // caOpen
            transition.type = @"cameraIrisHollowOpen";
            break;
            
        case 11:  // caClose
            transition.type = @"cameraIrisHollowClose";
            break;
            
        default:
            break;
    }
    [__orangeLayer addAnimation:transition forKey:@"ORANGELAYER_TRANSITION"];
}

/**
  *  @brief   更新图层的背景色
  */
- (void)__updateLayerBackgroundColor
{
    __colorIndex = (++__colorIndex % 4);
    
    __orangeLayer.backgroundColor = [self.colorArray[__colorIndex] CGColor];
}


#pragma mark - GET

- (NSArray *)btnTitleArray
{
    return @[
             // 开放 api
             @"淡出", @"移入", @"推开", @"显露",
             // 私有 api
             @"方块", @"吸走", @"翻面", @"水滴波纹", @"向下翻页", @"向上翻页", @"照相机开", @"照相机关"
             ];
}

- (NSArray<UIColor *> *)colorArray
{
    if (_colorArray == nil) {
        _colorArray = @[ [UIColor orangeColor], [UIColor cyanColor],
                         [UIColor magentaColor], [UIColor purpleColor] ];
    }
    return _colorArray;
}

@end
