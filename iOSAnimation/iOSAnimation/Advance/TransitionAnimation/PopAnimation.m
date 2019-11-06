//
//  PopAnimation.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import "PopAnimation.h"

@implementation PopAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * fromView = nil;
    UIView * toView = nil;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else {
        fromView = fromVC.view;
        toView   = toVC.view;
    }
    // 此时 fromView、toView 都在 containerView 里。将 toView 加到 fromView 的下面，非常重要！
    [[transitionContext containerView] insertSubview:toView belowSubview:fromView];

    fromView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        fromView.frame = [self endFrame];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (CGRect)endFrame
{
    switch (self.mode) {
        case PopAnimationMode_ToLeft:
            return CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        case PopAnimationMode_ToRight:
            return CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        case PopAnimationMode_ToTop:
            return CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        case PopAnimationMode_ToBottom:
            return CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        default:
            break;
    }
}

@end
