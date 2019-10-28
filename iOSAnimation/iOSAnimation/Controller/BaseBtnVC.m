//
//  BaseBtnVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/26.
//  Copyright © 2019年 D. All rights reserved.


#import "BaseBtnVC.h"

#define  COUNT  4
#define  LINE_GAP   20.0
#define  SPACE   20.0
#define  BTN_HEIGHT 40

@interface BaseBtnVC ()

@end


@implementation BaseBtnVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBtns];
}

/**
  *  @brief   初始化按钮
  */
- (void)initBtns
{
    NSArray * arr = [self btnTitleArray];
    
    if (arr.count == 0) {
        return;
    }
    
    CGFloat rows = (arr.count + COUNT - 1) / COUNT;
    CGFloat originY = SCREEN_HEIGHT - rows * (BTN_HEIGHT + LINE_GAP) - 40;
    CGFloat w = (SCREEN_WIDTH - (COUNT + 1) * SPACE) / COUNT;
    
    for (NSInteger i = 0; i < arr.count; i++) {
        
        CGFloat x = SPACE + (i%COUNT) * (w + SPACE);
        CGFloat y = originY + i/COUNT * (BTN_HEIGHT + LINE_GAP);
        
        UIButton * btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(x, y, w, BTN_HEIGHT);
        btn.backgroundColor = [UIColor colorWithRed:111/255.0 green:186/255.0 blue:44/255.0 alpha:1.0];
        btn.layer.cornerRadius  = 5;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (NSArray *)btnTitleArray
{
    return nil;
}

@end
