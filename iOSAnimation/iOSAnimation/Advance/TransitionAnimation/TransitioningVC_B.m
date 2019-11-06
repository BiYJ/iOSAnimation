//
//  TransitioningVC_B.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import "TransitioningVC_B.h"

@interface TransitioningVC_B () <UINavigationControllerDelegate>

// UIViewControllerInteractiveTransitioning：转场的交互协议，用来控制转场动画的状态或进度。
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition * interactiveTransition;

@end


@implementation TransitioningVC_B

- (void)dealloc
{
    self.navigationController.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加 pan 手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(panGestureRecognizerAction:)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan
{
    // 产生百分比
    CGFloat process = [pan translationInView:self.view].x / ([UIScreen mainScreen].bounds.size.width);
    
    process = MIN(1.0,(MAX(0.0, process)));
    
    // 开始状态：创建 UIPercentDrivenInteractiveTransition 对象，通过 popViewControllerAnimated: 方法触发转场动画。
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        // 触发 pop 转场动画
        [self.navigationController popViewControllerAnimated:YES];
    }
    // 变化状态：通过计算得到的百分比实时更新转场动画的状态。
    else if (pan.state == UIGestureRecognizerStateChanged){
        [self.interactiveTransition updateInteractiveTransition:process];
    }
    // 取消或者结束状态：根据完成的百分比决定是否完成转场或者取消转场。
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        
        if (process > 0.5) {
            [ self.interactiveTransition finishInteractiveTransition];
        }
        else {
            [ self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return self.popAnimationObj;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[PopAnimation class]]) {
        return self.interactiveTransition;
    }
    // 不需要交互的转场 interactionControllerForAnimationController: 方法一定要返回 nil
    return nil;
}


#pragma mark - GET
/**
  *  @brief   懒加载
  */
- (PopAnimation *)popAnimationObj
{
    if (_popAnimationObj == nil) {
        _popAnimationObj = [[PopAnimation alloc] init];
        _popAnimationObj.mode = PopAnimationMode_ToRight;
    }
    return _popAnimationObj;
}

@end
