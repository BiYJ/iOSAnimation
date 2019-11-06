//
//  TransitioningVC_A.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import "TransitioningVC_A.h"
#import "PushAnimation.h"
#import "TransitioningVC_B.h"


@interface TransitioningVC_A () <UINavigationControllerDelegate>
@property (nonatomic, strong) PushAnimation * pushAnimationObj;
@end


@implementation TransitioningVC_A

- (void)dealloc
{
    self.navigationController.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pushAnimationObj = [[PushAnimation alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // push 转场的动画行为是由 UINavigationControllerDelegate 协议指定，所以我们在 ViewController 设置导航控制器的 Delegate。
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
}


#pragma mark - BaseBtnPTC

- (void)btnClicked:(UIButton *)sender
{
    TransitioningVC_B * bVC = (TransitioningVC_B *)[self.storyboard instantiateViewControllerWithIdentifier:@"TransitioningVC_B_SBID"];

    switch (sender.tag) {
        case 0:
        {
            self.pushAnimationObj.mode = PushAnimationMode_FromRight_ToLeft;
            bVC.popAnimationObj.mode = PopAnimationMode_ToRight;
        }
            break;
            
        case 1:
        {
            self.pushAnimationObj.mode = PushAnimationMode_FromLeft_ToRight;
            bVC.popAnimationObj.mode = PushAnimationMode_FromRight_ToLeft;
        }
            break;
            
        case 2:
        {
            self.pushAnimationObj.mode = PushAnimationMode_FromBottom_ToTop;
            bVC.popAnimationObj.mode = PushAnimationMode_FromTop_ToBottom;
        }
            break;
            
        case 3:
        {
            self.pushAnimationObj.mode = PushAnimationMode_FromTop_ToBottom;
            bVC.popAnimationObj.mode = PopAnimationMode_ToTop;
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:bVC animated:YES];
}

- (NSArray *)btnTitleArray
{
    return @[ @"从右往左入", @"从左往右入", @"从下往上入", @"从上往下入" ];
}


#pragma mark - UINavigationControllerDelegate
/**
  *  @brief   指定 push 要使用的转场动画行为。由于要自定义转场动画，所以我们需要指定转场动画行为。
  */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimationObj;
    }
    return nil;
}

@end
