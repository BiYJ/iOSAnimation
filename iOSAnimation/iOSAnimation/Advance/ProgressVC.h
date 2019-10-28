//  进度条
//
//  ProgressVC.h
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/28.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

@interface Circle : UIView

@property (nonatomic, assign) CGFloat circleWidth; // 圆环的宽度
@property (nonatomic, assign) CGFloat progress;    // 进度。0 ~ 1

- (instancetype)initWithFrame:(CGRect)frame
                  circleWidth:(CGFloat)circleWidth;

@end

/**
  *  @brief   圆环进度条。https://github.com/mengxianliang/XLCircleProgress
  */
@interface CircleProgress : UIView

@property (nonatomic, assign) CGFloat progress; // 进度：0 ~ 1

@end


/**
  *  @brief   虚线进度条。
  */
@interface LineDashView : UIView

@end


/**
  *  @brief   扇形进度条
  */
@interface PieProgressView : UIView;

@end



@interface ProgressVC : UIViewController

@end
