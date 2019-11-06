//
//  PopAnimation.h
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopAnimationMode) {
    PopAnimationMode_ToLeft = 1, // 从左出
    PopAnimationMode_ToRight,    // 从右出
    PopAnimationMode_ToBottom,   // 从下出
    PopAnimationMode_ToTop       // 从上出
};

@interface PopAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PopAnimationMode mode;

@end
