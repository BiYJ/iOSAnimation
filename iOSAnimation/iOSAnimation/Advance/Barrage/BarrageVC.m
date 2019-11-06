//
//  BarrageVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import "BarrageVC.h"
#import "BarrageView.h"
#import "BarrageItem.h"
#import "UIView+Layout.h"


@interface BarrageVC () <BarrageViewDataSource>

@property (nonatomic, strong) BarrageView * barrageView;
@property (nonatomic, strong) UIView * parentView;
@property (nonatomic, strong) NSMutableArray * messageArray;

@end


@implementation BarrageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.messageArray = [NSMutableArray array];
    
    _parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 150)];
    [self.view insertSubview:_parentView atIndex:0];
    
    BarrageView *barrage = [[BarrageView alloc] initWithFrame:_parentView.bounds];
    barrage.dataSource = self;
    barrage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    barrage.barrageMaxLineCount = 3;
    barrage.backgroundColor = [UIColor blackColor];
    barrage.barrageUnifiedSpeed = 80;
    [_parentView addSubview:barrage];
    _barrageView = barrage;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    static NSInteger type = 0;
    
    for (NSInteger i = 0; i < 50; i ++) {
        NSString * title = nil;
        if (type == 0) {
            type  = 1;
            title = @"1shihiaognaihoi";
        }
        else if (type == 1) {
            type = 2;
            title = @"HenHenH";
        }
        else if (type == 2) {
            type = 3;
            title = @"_@#!+-";
        }
        else if (type == 3) {
            type = 4;
            title = @"嘻嘻呵呵哈哈嘎嘎";
        }
        else {
            type = 0;
            title = @"10759651235215662164322346321523512";
        }
        
        [_messageArray addObject:title];
    }
}


#pragma mark - BaseBtnPTC

- (void)btnClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            [_barrageView start];
            break;
            
        case 1:
            [_messageArray addObject:@"我的消息"];
            break;
            
        case 2:
            [_barrageView pause];
            break;
        
        case 3:
            [_barrageView resume];
            break;
            
        case 4:
            [_barrageView stop];
            [_messageArray removeAllObjects];
            break;
        
        case 5:
            [_barrageView stop];
            [_messageArray removeAllObjects];
            break;
            
        case 6:  // 旋转界面
        {
            static BOOL rotate = NO;
            
            [UIView animateWithDuration:0.2 animations:^{
                if (rotate == NO) {
                    rotate = YES;
                    self->_parentView.size = CGSizeMake(self.view.height, 100);
                    self->_parentView.center = CGPointMake(self.view.width/2, self.view.height/2);
                    self->_parentView.transform = CGAffineTransformMakeRotation(M_PI/2);
                }
                else {
                    rotate = NO;
                    self->_parentView.transform = CGAffineTransformIdentity;
                    self->_parentView.size = CGSizeMake(self.view.width, 150);
                    self->_parentView.origin = CGPointMake(0, 100);
                }
            } completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (NSArray *)btnTitleArray
{
    return @[ @"开始", @"发送弹幕", @"暂停", @"重启", @"清除弹幕", @"停止", @"旋转界面" ];
}


#pragma mark - BarrageViewDataSource

- (UIView<BarrageItemPTC> *)itemForBarrageView:(BarrageView *)barrageView
{
    NSString * title = [_messageArray firstObject];
    if (title) {
        [_messageArray removeObjectAtIndex:0];
        
        BarrageItem * item = (BarrageItem *)[barrageView dequeueReusableItem];
        if (!item) {
            item = [BarrageItem new];
        }
        item.speed = 80;
        
        BOOL highSpeed = (arc4random_uniform((int32_t)time(NULL)) % 100) < 10;
        if (highSpeed) {
            item.speed = 120;
        }
        
        item.content = title;
        
        return item;
    }
    return nil;
}

@end

