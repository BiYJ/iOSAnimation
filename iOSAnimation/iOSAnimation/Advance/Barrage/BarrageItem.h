//  单个弹幕控件
//
//  BarrageItem.h
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>
#import "BarrageItemPTC.h"

@interface BarrageItem : UIView <BarrageItemPTC>

@property (nonatomic, assign) CGFloat maxWidth;  // 最大宽度限制。默认 320pt
@property (nonatomic, copy) NSString * content;  // 弹幕内容
@property (nonatomic, strong) UIColor * textColor;  // 弹幕文本颜色

@end
