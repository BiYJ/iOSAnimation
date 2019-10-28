//  基础类，实现页面内按钮的生成
//
//  BaseBtnVC.h
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/26.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>


@protocol BaseBtnPTC <NSObject>
@required
/**
  *  @brief   按钮数据源
  */
- (NSArray *)btnTitleArray;
/**
  *   @brief   初始化按钮
  */
- (void)initBtns;

@optional
/**
  *  @brief   按钮被点击
  */
- (void)btnClicked:(UIButton *)sender;

@end





@interface BaseBtnVC : UIViewController <BaseBtnPTC>

@end
