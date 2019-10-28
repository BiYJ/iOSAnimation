//
//  CALayerVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "CALayerVC.h"

#define MAX_COL    3    // 列数
#define LAYER_GAP  30.0 // layer 间的间距
#define LAYER_WIDTH  ((SCREEN_WIDTH - (MAX_COL + 1) * LAYER_GAP) / MAX_COL)
#define BAR_HEIGHT   ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)

/*！
        1、使用图层精简非交互式绘图
        2、通过 CoreAnimation 创建基础动画、关键帧动画、动画组、转场动画
        3、通过 UIView 的装饰方法对这些动画操作进行简化等
 */
@interface CALayerVC ()

@property (weak, nonatomic) IBOutlet UIScrollView * bgScroll;
@property (weak, nonatomic) IBOutlet UIView * contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * contentViewHeightConstraint;

@end


@implementation CALayerVC

static NSInteger row;  // 行
static NSInteger col;  // 列

- (void)dealloc
{
    row = 0;
    col = 0;
    
    [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.bgScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.contentViewHeightConstraint.constant = SCREEN_HEIGHT - BAR_HEIGHT;
    
    row = 0;
    col = 0;
    
    [self __animatinAnchorPoint];
    [self __animationBackgroundColor];
    [self __animationBorderColor];
    [self __animationBorderWidth];
    [self __animationBounds];
    [self __animationContents];
    [self __animationContentsRect];
    [self __animationCornerRadius];
    [self __animationDoubleSided];
    [self __animationHidden];
    [self __animationMask];
    [self __animationMaskToBounds];
    [self __animationOpacity];
    [self __animationShadow];
    [self __animationSublayers];
    [self __animationTransform];
}

/**
  *  @brief   锚点
  */
- (void)__animatinAnchorPoint
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.anchorPoint = CGPointMake(1, 1);
    });
}

/**
  *  @brief   背景色
  */
- (void)__animationBackgroundColor
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.backgroundColor = UIColor.purpleColor.CGColor;
    });
}

/**
  *  @brief   边框颜色
  */
- (void)__animationBorderColor
{
    CALayer * layer = [self genLayer];
    layer.backgroundColor = UIColor.whiteColor.CGColor;
    layer.borderWidth = 2;
    layer.borderColor = UIColor.blackColor.CGColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.borderColor = UIColor.greenColor.CGColor;
    });
}

/**
  *  @brief   边框宽度
  */
- (void)__animationBorderWidth
{
    CALayer * layer = [self genLayer];
    layer.backgroundColor = UIColor.whiteColor.CGColor;
    layer.borderWidth = 1;
    layer.borderColor = UIColor.blackColor.CGColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.borderWidth = 10;
    });
}

/**
   *  @brief   图层大小
   */
- (void)__animationBounds
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect bounds = layer.bounds;
        bounds.size = CGSizeMake(20, 20);
        layer.bounds = bounds;
    });
}

/**
  *  @brief   图层显示内容
  */
- (void)__animationContents
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.contents = (id)[UIImage imageNamed:@"book"].CGImage;
    });
}

/**
 *  @brief   图层显示内容的大小和位置
 */
- (void)__animationContentsRect
{
    CALayer * layer = [self genLayer];
    layer.contents = (id)[UIImage imageNamed:@"book"].CGImage;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 展示 book 图片左上角（占整体四分之一）区域的内容
        layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
    });
}

/**
 *  @brief   圆角半径
 */
- (void)__animationCornerRadius
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.cornerRadius = LAYER_WIDTH / 2;
    });
}

/**
  *  @brief   图层背面是否显示，默认为 YES
  */
- (void)__animationDoubleSided
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.doubleSided = NO;
    });
}

/**
 *  @brief   是否隐藏
 */
- (void)__animationHidden
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.hidden = YES;
    });
}

/**
 *  @brief   图层蒙版。When setting the mask to a new layer, the new layer must have a nil superlayer
 */
- (void)__animationMask
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CALayer * maskLayer = [CALayer layer];
        maskLayer.frame = layer.bounds;
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        layer.mask = maskLayer;
    });
}

/**
 *  @brief   子图层是否剪切图层边界，默认为 NO
 */
- (void)__animationMaskToBounds
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.masksToBounds = YES;
    });
}

/**
  *  @brief   透明度 ，类似于 UIView 的 alpha
  */
- (void)__animationOpacity
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.opacity = 0.5;
    });
}

/**
  *  @brief   阴影
  */
- (void)__animationShadow
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.shadowColor = UIColor.blackColor.CGColor;
        layer.shadowOffset  = CGSizeMake(0, -7.5); // 阴影偏移量
        layer.shadowRadius  = 5;  // 阴影模糊半径
        layer.shadowOpacity = 1;  // 阴影透明度，注意默认为 0，如果设置阴影必须设置此属性
        layer.masksToBounds = NO;
        //layer.shadowPath   // 阴影的形状
    });
}

/**
  *  @brief   子图层
  */
- (void)__animationSublayers
{
    CALayer * layer = [self genLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CAGradientLayer * gradient = [[CAGradientLayer alloc] init];
        gradient.frame      = layer.bounds;
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint   = CGPointMake(1, 1);
        gradient.colors     = @[ (id)UIColor.whiteColor.CGColor, (id)UIColor.blackColor.CGColor ];
        
        [layer addSublayer:gradient];
    });
}

/**
  *  @brief   图层形变
  */
- (void)__animationTransform
{
    CALayer * layer = [self genLayer];
    
    //layer.sublayerTransform  // 子图层形变
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.transform = CATransform3DScale(CATransform3DIdentity, 0.3, 0.5, 1.0);
    });
}


#pragma mark - GET
/**
  *  @brief   提供 layer 实例
  */
- (CALayer *)genLayer
{
    if (col >= MAX_COL) {
        row++;
        col = 0;
    }
    
    CGFloat y = 50 + (20 + LAYER_WIDTH) * row;
    
    if (y + LAYER_WIDTH > SCREEN_HEIGHT - BAR_HEIGHT) {
        self.contentViewHeightConstraint.constant = y + LAYER_WIDTH + 50;
    }
    
    CALayer * layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(LAYER_GAP + (LAYER_GAP + LAYER_WIDTH) * col,
                             y,
                             LAYER_WIDTH,
                             LAYER_WIDTH);
    layer.backgroundColor = UIColor.orangeColor.CGColor;
    layer.cornerRadius    = 5;
    
    [self.contentView.layer addSublayer:layer];
    
    col++;
    
    return layer;
}

@end
