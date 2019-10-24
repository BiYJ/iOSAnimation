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
}
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
    
    // 添加滑动手势
    UISwipeGestureRecognizer * lSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(leftSwipe:)];
    lSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:lSwipe];
    
    UISwipeGestureRecognizer * rSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                        action:@selector(rightSwipe:)];
    rSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rSwipe];
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

@end
