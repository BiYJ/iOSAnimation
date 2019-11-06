//
//  PushAnimation.h
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PushAnimationMode) {
    PushAnimationMode_FromRight_ToLeft = 1,  // 从右往左入
    PushAnimationMode_FromLeft_ToRight,      // 从左往右入
    PushAnimationMode_FromTop_ToBottom,      // 从上往下入
    PushAnimationMode_FromBottom_ToTop       // 从下往上入
};


// UIViewControllerAnimatedTransitioning：转场动画协议，实现此协议定义转场的动画行为。
@interface PushAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PushAnimationMode mode; // 动画模式

@end
