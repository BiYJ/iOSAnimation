//
//  ProgressVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/28.
//  Copyright © 2019年 D. All rights reserved.


#import "ProgressVC.h"

static CGFloat Margin = 1.0;

@implementation Circle
{
    @private
        CAShapeLayer * __progressLayer; // 进度图层
        CALayer * __endPointLayer;
        CGFloat __radius;  // 圆环半径
}

- (instancetype)initWithFrame:(CGRect)frame circleWidth:(CGFloat)circleWidth
{
    if (self = [super initWithFrame:frame]) {
        self.progress = 0.0;
        self.circleWidth = circleWidth;
        
        [self __addLayoutLayer];
    }
    return self;
}

/**
  *  @brief    添加布局图层
  */
- (void)__addLayoutLayer
{
    // 中心点
    CGFloat centerX = CGRectGetWidth(self.bounds) / 2.0;
    CGFloat centerY = CGRectGetHeight(self.bounds)/ 2.0;
    // 半径
    __radius = centerX - _circleWidth/2.0;
    
    // 贝塞尔路径
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY)
                                                         radius:__radius
                                                     startAngle:-M_PI_2
                                                       endAngle:M_PI_2 * 3
                                                      clockwise:YES];
    // 背景圆环
    CAShapeLayer * backCircleLayer = [CAShapeLayer layer];
    backCircleLayer.frame = self.bounds;
    backCircleLayer.fillColor = [UIColor clearColor].CGColor;
    backCircleLayer.strokeColor = RGB(50, 50, 50).CGColor;
    backCircleLayer.lineWidth = _circleWidth;
    backCircleLayer.strokeEnd = 1;  // 终点位置
    backCircleLayer.path = path.CGPath;
    [self.layer addSublayer:backCircleLayer];
    
    // 渐变色
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[ (id)[RGB(255, 151, 0) CGColor],
                              (id)[RGB(255, 203, 0) CGColor] ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [self.layer addSublayer:gradientLayer];
    
    // 进度图层
    __progressLayer = [CAShapeLayer layer];
    __progressLayer.frame = self.bounds;
    __progressLayer.fillColor = [UIColor clearColor].CGColor;
    __progressLayer.strokeColor = [UIColor blackColor].CGColor;
    __progressLayer.lineCap = kCALineCapRound;
    __progressLayer.lineWidth = _circleWidth;
    __progressLayer.path = path.CGPath;
    __progressLayer.strokeEnd = 0;  // 起始位置
    gradientLayer.mask = __progressLayer; // 掩层
    
    // 进度条末尾的图标
    CGFloat wh = _circleWidth - 2*Margin;
    __endPointLayer = [CALayer layer];
    __endPointLayer.frame = CGRectMake(centerX, 0, wh, wh);
    __endPointLayer.opacity = 0;
    __endPointLayer.backgroundColor = [UIColor blackColor].CGColor;
    __endPointLayer.contents = (id)[UIImage imageNamed:@"endPoint"].CGImage;
    __endPointLayer.masksToBounds = YES;
    __endPointLayer.cornerRadius = wh/2;
    [self.layer addSublayer:__endPointLayer];
}

/**
  *  @brief   更新末尾图标的位置
  */
- (void)__updateEndPointLayer
{
    // 转成弧度
    CGFloat allAngle = M_PI * 2 * _progress;
    // 当前进度在第几象限内
    NSInteger quadrant = (allAngle) / M_PI_2;
    // 用于计算正弦/余弦的角度，调整到 0 ~ 90°
    float calculateAngle = allAngle - quadrant * M_PI_2;

    CGRect frame = __endPointLayer.frame;
    switch (quadrant) {
        case 0:
            frame.origin.x = __radius + sinf(calculateAngle)*__radius;
            frame.origin.y = __radius - cosf(calculateAngle)*__radius;
            break;
        case 1:
            frame.origin.x = __radius + cosf(calculateAngle)*__radius;
            frame.origin.y = __radius + sinf(calculateAngle)*__radius;
            break;
        case 2:
            frame.origin.x = __radius - sinf(calculateAngle)*__radius;
            frame.origin.y = __radius + cosf(calculateAngle)*__radius;
            break;
        case 3:
            frame.origin.x = __radius - cosf(calculateAngle)*__radius;
            frame.origin.y = __radius - sinf(calculateAngle)*__radius;
            break;
            
        default:
            break;
    }
    frame.origin.x += Margin;
    frame.origin.y += Margin;
    // 关闭隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    __endPointLayer.frame = frame;
    __endPointLayer.opacity = 1;
    if (_progress == 0 || _progress == 1) {
        __endPointLayer.opacity = 0;
    }
    [CATransaction commit];
}


#pragma mark - SET

- (void)setProgress:(CGFloat)progress
{
    _progress = MAX(0, MIN(1, progress));
    __progressLayer.strokeEnd = progress;
    [self __updateEndPointLayer];
    [__progressLayer removeAllAnimations];
}

@end


/**
  *  @brief   圆环进度视图
  */
@interface CircleProgress()

@property (nonatomic, weak) IBOutlet UILabel * percentLabel;
@property (nonatomic, strong) Circle * circle;

@end

@implementation CircleProgress

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    _circle = [[Circle alloc] initWithFrame:self.bounds
                                circleWidth:0.1 * CGRectGetWidth(self.bounds)];
    [self addSubview:_circle];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = MAX(0, MIN(1, progress));
    
    self.percentLabel.text = [NSString stringWithFormat:@"%.0f%%", _progress * 100];
    _circle.progress = progress;
}

@end




@implementation LineDashView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self __addLayoutLayer];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self __addLayoutLayer];
}

- (void)__addLayoutLayer
{
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(60, 60)
                                                         radius:50
                                                     startAngle:-M_PI_2
                                                       endAngle:M_PI_2 * 3
                                                      clockwise:YES];
    
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.frame = self.bounds;
    shape.path = path.CGPath;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    shape.lineCap = kCALineCapButt;
    shape.lineDashPattern = @[ @(5), @(10) ];
    shape.lineWidth = 10;
    shape.fillColor = [UIColor clearColor].CGColor;

    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue   = @(1);
    animation.duration  = 5;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [shape addAnimation:animation forKey:@"STROKE_END_ANIMATION"];
    
    [self.layer addSublayer:shape];
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, 10);
//    // 设置线条的起始点样式
//    CGContextSetLineCap(ctx,kCGLineCapButt);
//    // 虚实切换。线段宽度 5pt，间隔 10pt
//    CGFloat length[] = { 5, 10 };
//    CGContextSetLineDash(ctx, 0, length, 2);
//    [[UIColor whiteColor] set];
//    CGContextAddEllipseInRect(ctx, CGRectMake(10, 10, 100, 100));
//    CGContextStrokePath(ctx);
//}

@end






@implementation PieProgressView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self __addLayoutLayer];
}

- (void)__addLayoutLayer
{
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(60, 60)
                                                         radius:50
                                                     startAngle:-M_PI_2
                                                       endAngle:M_PI_2 * 17.0/8
                                                      clockwise:YES];
    
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.frame = self.bounds;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = [UIColor orangeColor].CGColor;
    shape.lineWidth = 50;
    shape.path = path.CGPath;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue   = @(1);
    animation.duration  = 5;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [shape addAnimation:animation forKey:@"STROKE_END_ANIMATION"];
    
    [self.layer addSublayer:shape];
}

@end





@interface ProgressVC ()

@property (weak, nonatomic) IBOutlet CircleProgress * circleProgress;
@property (weak, nonatomic) IBOutlet LineDashView * lineDashView;
@property (weak, nonatomic) IBOutlet PieProgressView * pieProgress;

@end


@implementation ProgressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)progressChanged:(UISlider *)sender
{
    self.circleProgress.progress = sender.value;
}

@end
