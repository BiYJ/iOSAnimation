//
//  UberAnimationVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/12/23.
//  Copyright © 2019 D. All rights reserved.
//

#import "UberAnimationVC.h"

/*    "U" Logo 动画视图    */
@interface AnimatedULogoView : UIView
{
    CAShapeLayer * __circleLayer;
    CAShapeLayer * __lineLayer;
    CAShapeLayer * __squareLayer;
    CAShapeLayer * __maskLayer;
}

@end

@implementation AnimatedULogoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        __circleLayer = [self generateCircleLayer];
    }
    return self;
}

- (CAShapeLayer *)generateCircleLayer
{
    CGFloat radius = CGRectGetWidth(self.bounds);
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    return layer;
}

@end



@interface UberAnimationVC ()

@end


@implementation UberAnimationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
