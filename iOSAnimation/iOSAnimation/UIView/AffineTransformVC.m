//
//  AffineTransformVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/26.
//  Copyright © 2019年 D. All rights reserved.


#import "AffineTransformVC.h"

@interface AffineTransformVC ()

@property (nonatomic, strong) CALayer * orangeLayer;
@property (nonatomic, strong) UIView * operateView;

@end


@implementation AffineTransformVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view.layer addSublayer:self.orangeLayer];
    [self.view addSubview:self.operateView];
}


#pragma mark - BaseBtnPTC

- (void)btnClicked:(UIButton *)sender
{
    _operateView.transform = CGAffineTransformIdentity;

    switch (sender.tag) {
        case 0:  // 位移
        {
            // 图层的 affineTransform 类似于 transform，但不能动画
            _orangeLayer.affineTransform = CGAffineTransformMakeTranslation(100, 100);
            
            [UIView animateWithDuration:1.0 animations:^{
                self->_operateView.transform = CGAffineTransformMakeTranslation(-100, -100);
            }];
        }
            break;
            
        case 1:  // 缩放
        {
            [UIView animateWithDuration:1.0 animations:^{
                self->_operateView.transform = CGAffineTransformMakeScale(2.0, 2.0);
            }];
        }
            break;
            
        case 2:  // 旋转
        {
            [UIView animateWithDuration:1.0 animations:^{
                self->_operateView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
            break;
        
        case 3:  // 仿射变换的组合使用
        {
            [UIView animateWithDuration:1.0 animations:^{
                CGAffineTransform transform1 = CGAffineTransformMakeRotation(M_PI);
                CGAffineTransform transform2 = CGAffineTransformScale(transform1, 2.0, 2.0);
                self->_operateView.transform = CGAffineTransformTranslate(transform2, 100, 100);
            }];
        }
            break;
            
        case 4:  // 反转
        {
            [UIView animateWithDuration:1.0 animations:^{
                self->_operateView.transform = CGAffineTransformInvert(CGAffineTransformMakeScale(2.0, 2.0));
            }];
        }
            break;
            
        default:
            break;
    }
}

- (NSArray *)btnTitleArray
{
    return @[ @"位移", @"缩放", @"旋转", @"组合", @"反转" ];
}


#pragma mark - GET
/**
  *  @brief   UI开发技巧：Code Block Evaluation C Extension 语法
  */
- (CALayer *)orangeLayer
{
    if (_orangeLayer == nil) {
        _orangeLayer = ({
            
            CALayer * layer = [CALayer layer];
            layer.position = self.view.center;
            layer.bounds = ({
                CGRect rect = CGRectMake(0, 0, 100, 100);
                rect;
            });
            layer.backgroundColor = [UIColor orangeColor].CGColor;
            layer;
        });
    }
    return _orangeLayer;
}

- (UIView *)operateView
{
    if (_operateView == nil) {
        _operateView = ({
            UIView * view = [[UIView alloc] initWithFrame:({
                CGRect rect = CGRectMake(0, 0, 100, 100);
                rect;
            })];
            view.center = self.view.center;
            view.backgroundColor = [UIColor magentaColor];
            view;
        });
    }
    return _operateView;
}

@end
