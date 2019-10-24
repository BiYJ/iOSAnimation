//
//  SpringAnimationVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "SpringAnimationVC.h"

@interface SpringAnimationVC ()
{
    UIImageView * _imageView;
}
@end


@implementation SpringAnimationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建图像显示控件
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball"]];
    _imageView.frame = CGRectMake(0, 0, 80, 80);
    _imageView.center = CGPointMake(160, 50);
    [self.view addSubview:_imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = touches.anyObject;
    CGPoint location = [touch locationInView:self.view];
    
    /* 弹性动画
     
            参数1：动画时间
            参数2：延迟时间
            参数3：damping 阻尼，范围 0~1，阻尼越接近于 0，弹性效果越明显，越慢停下来
            参数4：velocity 弹性复位的速度
        */
    [UIView animateWithDuration:5.0
                          delay:0
         usingSpringWithDamping:0.1
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
        self->_imageView.center = location;
                         
    } completion:nil];
}

@end
