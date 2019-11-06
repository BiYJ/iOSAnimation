//
//  PushAnimation.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import "PushAnimation.h"

@implementation PushAnimation

/**
  *  @brief   动画时长
  */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

/**
  *  @brief   UIViewControllerContextTransitioning：转场动画上下文，这个协议定义了转场动画具体参数，控制转场动画的状态。这个协议一般由系统实现，在转场发生时提供给我们使用。
  */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // from
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // to
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    
    UIView * toView = nil;
    UIView * fromView = nil;
    // UITransitionContextFromViewKey和UITransitionContextToViewKey定义在iOS8.0以后的SDK中，所以在iOS8.0以下SDK中将toViewController和fromViewController的view设置给toView和fromView
    //iOS8.0 之前和之后 view 的层次结构发生变化，所以 iOS8.0以后UITransitionContextFromViewKey获得view并不是fromViewController的view
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else {
        fromView = fromVC.view;
        toView   = toVC.view;
    }
    //这个非常重要，将toView加入到containerView中
    // 转场动画所有要呈现的元素都要放在 containerView 中，fromView 默认已经在 containerView中了。
    [[transitionContext containerView] addSubview:toView];
    
    toView.frame = [self beginFrame];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        toView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        // 动画的状态和转场的状态是不一样的，动画完成后，不代表转场完成，所以我们要在动画的 completion 里面决定是否完成转场：[transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        [transitionContext completeTransition:YES];
    }];
}

- (CGRect)beginFrame
{
    switch (self.mode) {
        case PushAnimationMode_FromRight_ToLeft:
            return CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        case PushAnimationMode_FromLeft_ToRight:
            return CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        case PushAnimationMode_FromTop_ToBottom:
            return CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        case PushAnimationMode_FromBottom_ToTop:
            return CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        default:
            break;
    }
}

@end
