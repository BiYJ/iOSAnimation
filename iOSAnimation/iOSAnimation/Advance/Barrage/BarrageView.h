//
//  BarrageView.h
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>


/**
  *  @brief   弹幕的运动状态
  */
typedef NS_ENUM(NSInteger, BarrageAnimationStatus) {
    BarrageAnimationStatus_Playing,  // 动画中
    BarrageAnimationStatus_Paused,   // 已暂停
    BarrageAnimationStatus_Stoped,   // 已终止
};


@class BarrageView;
@protocol BarrageItemPTC;
@protocol BarrageViewDataSource <NSObject>
@required
/**
  *  @brief    提供弹幕视图源
  */
- (UIView<BarrageItemPTC> *)itemForBarrageView:(BarrageView *)barrageView;

@end




/**
  *  @see
  */
@interface BarrageView : UIView

@property (nonatomic, weak) id<BarrageViewDataSource> dataSource;

@property (nonatomic, assign) NSUInteger barrageMaxLineCount;  // 弹幕的最大行数。默认为 3
@property (nonatomic, assign) CGFloat barrageItemSpacing;  // 弹幕减的间距。默认 16pt
@property (nonatomic, assign) CGFloat barrageUnifiedSpeed; // 弹幕的平均速度。当旋转屏幕时，所有的正在播放的弹幕会设置成这个速度，避免出现重叠

@property (nonatomic, readonly, assign) BarrageAnimationStatus animationStatus; // 弹幕播放状态

/**
  *  @brief   获取可重用的弹幕
  */
- (UIView<BarrageItemPTC> *)dequeueReusableItem;
/**
  *  @brief   开始功能
  */
- (BOOL)start;
/**
  *  @brief   暂停弹幕
  */
- (BOOL)pause;
/**
  *  @brief   重新运行
  */
- (BOOL)resume;
/**
  *  @brief   停止功能
  */
- (BOOL)stop;

@end
