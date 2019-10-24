//
//  KeyframeInViewVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "KeyframeInViewVC.h"

@interface KeyframeInViewVC ()
{
    UIImageView * __imageView;
}
@end


@implementation KeyframeInViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景（这个图片其实在根图层）
    UIImage * backgroundImage = [UIImage imageNamed:@"bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    __imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yhc"]];
    __imageView.bounds = CGRectMake(0, 0, 17, 25.5);
    __imageView.center = CGPointMake(50, 150);
    [self.view addSubview:__imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*  关键帧动画
     
            参数1：总共时长
            参数2：延迟时间
             参数3：options
            */
    [UIView animateKeyframesWithDuration:5.0
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear                              animations:^{
                                  
        // 第 2 个关键帧（准确的说第一个关键帧是开始位置）:从 0 秒开始持续 50% 的时间，也就是 5.0*0.5 = 2.5 秒
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:0.5
                                      animations:^{
                                          
            self->__imageView.center = CGPointMake(80.0, 220.0);
        }];
        // 第 3 个关键帧，从 2.5 秒开始，持续 5.0*0.25 = 1.25 秒
        [UIView addKeyframeWithRelativeStartTime:0.5
                                relativeDuration:0.25
                                      animations:^{
                                          
            self->__imageView.center=CGPointMake(45.0, 300.0);
        }];
        //第 4 个关键帧：从 3.75 秒开始，持续 5.0*0.25 = 1.25 秒
        [UIView addKeyframeWithRelativeStartTime:0.75
                                relativeDuration:0.25
                                      animations:^{
                                          
            self->__imageView.center=CGPointMake(55.0, 400.0);
        }];
        
    } completion:^(BOOL finished) {
        
        NSLog(@"Animation end.");
    }];
}

@end
