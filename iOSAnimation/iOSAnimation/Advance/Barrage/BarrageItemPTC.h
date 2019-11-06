//  每个弹幕控件需要遵守的协议
//
//  BarrageItemPTC.h
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import <CoreGraphics/CoreGraphics.h>

@protocol BarrageItemPTC <NSObject>

@property (nonatomic, assign) CGFloat speed;  // 弹幕移动速度
@property (nonatomic, assign) CGFloat movedDistance; // 弹幕已移动的路程

@end
