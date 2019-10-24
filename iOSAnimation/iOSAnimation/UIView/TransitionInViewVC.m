//
//  TransitionInViewVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "TransitionInViewVC.h"

#define IMAGE_COUNT 5

@interface TransitionInViewVC ()
{
    UIImageView * __imageView;
    int __curIndex;
}
@end


@implementation TransitionInViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 定义图片控件
    __imageView = [[UIImageView alloc]init];
    __imageView.frame = [UIScreen mainScreen].applicationFrame;
    __imageView.contentMode = UIViewContentModeScaleAspectFit;
    __imageView.image = [UIImage imageNamed:@"0.jpg"];//默认图片
    [self.view addSubview:__imageView];
    
    // 添加手势
    UISwipeGestureRecognizer * lSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(leftSwipe:)];
    lSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:lSwipe];
    
    UISwipeGestureRecognizer * rSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
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
  *  @brief    转场动画
  */
- (void)__transitionAnimation:(BOOL)isNext
{
    UIViewAnimationOptions option;
    
    if (isNext) {
        option = UIViewAnimationOptionCurveLinear | UIViewAnimationOptionTransitionFlipFromRight;
    }
    else {
        option = UIViewAnimationOptionCurveLinear | UIViewAnimationOptionTransitionFlipFromLeft;
    }
    
    [UIView transitionWithView:__imageView
                      duration:1.0
                       options:option
                    animations:^{
                        
        self->__imageView.image = [self getImage:isNext];
                        
    } completion:nil];
}

/**
  *  @brief   取得当前图片
  */
- (UIImage *)getImage:(BOOL)isNext
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
