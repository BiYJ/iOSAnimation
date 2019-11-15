//
//  DisplayLinkVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "DisplayLinkVC.h"

#define IMAGE_COUNT 6


@interface DisplayLinkVC ()
{
    CALayer * __layer;
    int __index;
    NSMutableArray * __images;
}
@end


@implementation DisplayLinkVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景
    self.view.layer.contents = (id)[UIImage imageNamed:@"bg.png"].CGImage;
    
    __layer = [[CALayer alloc]init];
    __layer.frame = CGRectMake(160, 284, 87, 32);
    [self.view.layer addSublayer:__layer];
    
    // 由于鱼的图片在循环中会不断创建，而 10 张鱼的照片相对都很小。与其在循环中不断创建 UIImage 不如直接将 10 张图片缓存起来
    __images = [NSMutableArray array];
    
//    for (int i = 0; i < 10; ++i) {
//        NSString * imageName = [NSString stringWithFormat:@"fish%i.png", i];
//        UIImage * image = [UIImage imageNamed:imageName];
//        [__images addObject:image];
//    }
    
    for (int i = 0; i < 6; ++i) {
        NSString * imageName = [NSString stringWithFormat:@"dragon-%i.png", i];
        UIImage * image = [UIImage imageNamed:imageName];
        [__images addObject:image];
    }
    
    // 定义时钟对象
    CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    // 添加时钟对象到主运行循环
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

/**
  *  @brief   每次屏幕刷新就会执行一次此方法（每秒接近 60 次）
  */
- (void)step
{
    static int s = 0;
    // 每秒执行 6 次
    if (++s%10 == 0) {
        UIImage * image = __images[__index];
        __layer.contents = (id)image.CGImage;  //更新图片
        __index = (__index + 1) % IMAGE_COUNT;
    }
}

@end
