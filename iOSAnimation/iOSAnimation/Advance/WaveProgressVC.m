//
//  WaveProgressVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/12/24.
//  Copyright © 2019 D. All rights reserved.


#import "WaveProgressVC.h"
#import <UIKit/UIKit.h>


@interface WaveView : UIView

@property (nonatomic, assign) CGFloat scaleDivisionsLength; // 比例尺长度
@property (nonatomic, assign) CGFloat scaleDivisionsWidth;  // 比例尺刻度宽度
@property (nonatomic, assign) CGFloat scaleMargin;  // 比例尺到 WaveView 的边距
@property (nonatomic, assign) CGFloat scaleCount;   // 比例尺的个数
@property (nonatomic, assign) CGFloat waveMargin; // 比例尺到圆形波纹的距离
@property (nonatomic, assign) CGFloat waveLength;  // 波长
@property (nonatomic, assign) CGFloat amplitude;  // 振幅

@property (nonatomic, assign) CGFloat percent;  // 百分比

@property (nonatomic, retain) UIColor *frontWaterColor;  // 前波浪颜色
@property (nonatomic, retain) UIColor *backWaterColor;  // 后波浪颜色
@property (nonatomic, retain) UIColor *waterBgColor;  // 波浪的背景颜色

@property (nonatomic, retain) UIColor * lineBgColor;  // 刻度线背景色
@property (nonatomic, retain) UIColor * scaleColor;   // 刻度线颜色
@property (nonatomic, assign) BOOL showBgLineView;    // 是否显示背景上的线条

@end


@implementation WaveView
{
    CGRect fullRect;
    CGRect scaleRect;
    CGRect waveRect;
    
    CGFloat currentLinePointY;
    CGFloat targetLinePointY;
    
    CGFloat currentPercent;//但前百分比，用于保存第一次显示时的动画效果
    
    CGFloat a;
    CGFloat b;
    
    BOOL increase;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        fullRect = frame;
        
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _scaleDivisionsLength = 10;
    _scaleDivisionsWidth = 2;
    _scaleCount = 100;
    
    a = 1.5;
    b = 0;
    increase = NO;
    _waveLength = 180;
    _amplitude = 10;
    
    _frontWaterColor = [UIColor colorWithRed:0.325 green:0.392 blue:0.729 alpha:1.00];
    _backWaterColor = [UIColor colorWithRed:0.322 green:0.514 blue:0.831 alpha:1.00];
    _waterBgColor = [UIColor colorWithRed:0.259 green:0.329 blue:0.506 alpha:1.00];
    _lineBgColor = [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00];
    _scaleColor = [UIColor colorWithRed:0.969 green:0.937 blue:0.227 alpha:1.00];
    _percent = 0.45;
    
    _scaleMargin = 30;
    _waveMargin = 18;
    _showBgLineView = NO;
    
    [self initDrawingRects];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
}

- (void)initDrawingRects
{
    CGFloat offset = _scaleMargin;
    scaleRect = CGRectMake(offset,
                           offset,
                           fullRect.size.width - 2 * offset,
                           fullRect.size.height - 2 * offset);
    
    offset = _scaleMargin + _waveMargin + _scaleDivisionsLength;
    waveRect = CGRectMake(offset,
                          offset,
                          fullRect.size.width - 2 * offset,
                          fullRect.size.height - 2 * offset);
    
    currentLinePointY = waveRect.size.height;
    targetLinePointY = waveRect.size.height * (1 - _percent);
    
    [self setNeedsDisplay];
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBackground:context];
    [self drawWave:context];
    [self drawLabel:context];
    [self drawScale:context];
    [self drawProcessScale:context];
    
}

/**
 *  画比例尺
 *
 *  @param context 全局context
 */
- (void)drawScale:(CGContextRef)context {
    
    CGContextSetLineWidth(context, _scaleDivisionsWidth);//线的宽度
    //======================= 矩阵操作 ============================
    CGContextTranslateCTM(context, fullRect.size.width / 2, fullRect.size.width / 2);
    
    CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);//线框颜色
    // 2. 绘制一些图形
    for (int i = 0; i < _scaleCount; i++) {
        CGContextMoveToPoint(context, scaleRect.size.width/2 - _scaleDivisionsLength, 0);
        CGContextAddLineToPoint(context, scaleRect.size.width/2, 0);
        //    CGContextScaleCTM(ctx, 0.5, 0.5);
        // 3. 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, 2 * M_PI / _scaleCount);
    }
    
    CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);//线框颜色
    CGContextSetLineWidth(context, 0.5);
    CGContextAddArc (context, 0, 0, scaleRect.size.width/2 - _scaleDivisionsLength - 3, 0, M_PI* 2 , 0);
    CGContextStrokePath(context);
    
    CGContextTranslateCTM(context, -fullRect.size.width / 2, -fullRect.size.width / 2);
}

/**
 *  画波浪
 *
 *  @param context 全局context
 */
- (void)drawWave:(CGContextRef)context {
    
    CGMutablePathRef frontPath = CGPathCreateMutable();
    CGMutablePathRef backPath = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_frontWaterColor CGColor]);
    
    CGFloat offset = _scaleMargin + _waveMargin + _scaleDivisionsLength;
    
    float frontY = currentLinePointY;
    float backY = currentLinePointY;
    
    CGFloat radius = waveRect.size.width / 2;
    
    CGPoint frontStartPoint = CGPointMake(offset, currentLinePointY + offset);
    CGPoint frontEndPoint = CGPointMake(offset, currentLinePointY + offset);
    
    CGPoint backStartPoint = CGPointMake(offset, currentLinePointY + offset);
    CGPoint backEndPoint = CGPointMake(offset, currentLinePointY + offset);
    
    for(float x = 0; x <= waveRect.size.width; x++){
        
        //前浪绘制
        frontY = a * sin( x / (_waveLength / 2) * M_PI + 4 * b / M_PI ) * _amplitude + currentLinePointY;
        
        CGFloat frontCircleY = frontY;
        if (frontY < radius) {
            frontCircleY = radius - sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (frontY < frontCircleY) {
                frontY = frontCircleY;
            }
        } else if (frontY > radius) {
            frontCircleY = radius + sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (frontY > frontCircleY) {
                frontY = frontCircleY;
            }
        }
        if (x == 0) {
            frontStartPoint = CGPointMake(x + offset, frontY + offset);
            CGPathMoveToPoint(frontPath, NULL, frontStartPoint.x, frontStartPoint.y);
        }
        
        frontEndPoint = CGPointMake(x + offset, frontY + offset);
        CGPathAddLineToPoint(frontPath, nil, frontEndPoint.x, frontEndPoint.y);
        
        //后波浪绘制
        backY = a * cos( x / (_waveLength / 2) * M_PI + 3 * b / M_PI ) * _amplitude + currentLinePointY;
        CGFloat backCircleY = backY;
        if (backY < radius) {
            backCircleY = radius - sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (backY < backCircleY) {
                backY = backCircleY;
            }
        } else if (backY > radius) {
            backCircleY = radius + sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (backY > backCircleY) {
                backY = backCircleY;
            }
        }
        
        if (x == 0) {
            backStartPoint = CGPointMake(x + offset, backY + offset);
            CGPathMoveToPoint(backPath, NULL, backStartPoint.x, backStartPoint.y);
        }
        
        backEndPoint = CGPointMake(x + offset, backY + offset);
        CGPathAddLineToPoint(backPath, nil, backEndPoint.x, backEndPoint.y);
    }
    
    CGPoint centerPoint = CGPointMake(fullRect.size.width / 2, fullRect.size.height / 2);
    
    //绘制前浪圆弧
    CGFloat frontStart = [self calculateRotateDegree:centerPoint point:frontStartPoint];
    CGFloat frontEnd = [self calculateRotateDegree:centerPoint point:frontEndPoint];
    
    CGPathAddArc(frontPath, nil, centerPoint.x, centerPoint.y, waveRect.size.width / 2, frontEnd, frontStart, 0);
    CGContextAddPath(context, frontPath);
    CGContextFillPath(context);
    //推入
    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(frontPath);
    
    
    //绘制后浪圆弧
    CGFloat backStart = [self calculateRotateDegree:centerPoint point:backStartPoint];
    CGFloat backEnd = [self calculateRotateDegree:centerPoint point:backEndPoint];
    
    CGPathAddArc(backPath, nil, centerPoint.x, centerPoint.y, waveRect.size.width / 2, backEnd, backStart, 0);
    
    CGContextSetFillColorWithColor(context, [_backWaterColor CGColor]);
    CGContextAddPath(context, backPath);
    CGContextFillPath(context);
    //推入
    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(backPath);
    
}

/**
 *  画背景界面
 *
 *  @param context 全局context
 */
- (void)drawBackground:(CGContextRef)context {
    
    //画背景圆
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_waterBgColor CGColor]);
    
    CGPoint centerPoint = CGPointMake(fullRect.size.width / 2, fullRect.size.height / 2);
    CGPathAddArc(path, nil, centerPoint.x, centerPoint.y, waveRect.size.width / 2, 0, 2 * M_PI, 0);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    if (_showBgLineView) {
        //绘制背景的线
        //======================= 矩阵操作 ============================
        CGContextTranslateCTM(context, fullRect.size.width / 2, fullRect.size.width / 2);
        
        CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);//线框颜色
        CGContextSetLineWidth(context, 1);
        CGContextAddArc (context, 0, 0, fullRect.size.width/2 - 4, -M_PI / 4, M_PI / 4, 0);
        CGContextStrokePath(context);
        
        CGContextRotateCTM(context, M_PI / 4);
        CGContextMoveToPoint(context, fullRect.size.width/2 - 4, 0);
        CGContextAddLineToPoint(context, fullRect.size.width/2, 0);
        // 3. 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, -M_PI / 4);
        
        CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);//线框颜色
        CGContextSetLineWidth(context, 1);
        CGContextAddArc (context, 0, 0, fullRect.size.width/2 - 4, M_PI * 3 / 4, M_PI * 5 / 4, 0);
        CGContextStrokePath(context);
        
        CGContextRotateCTM(context, M_PI * 5 / 4);
        CGContextMoveToPoint(context, fullRect.size.width/2 - 4, 0);
        CGContextAddLineToPoint(context, fullRect.size.width/2, 0);
        // 3. 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, -M_PI * 5 / 4);
        
        CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);//线框颜色
        CGContextSetLineWidth(context, 6);
        CGContextAddArc (context, 0, 0, fullRect.size.width/2 - _scaleMargin / 2, M_PI * 4 / 10, M_PI * 6 / 10, 0);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);//线框颜色
        CGContextSetLineWidth(context, 6);
        CGContextAddArc (context, 0, 0, fullRect.size.width/2 - _scaleMargin / 2, M_PI * 14 / 10, M_PI * 16 / 10, 0);
        CGContextStrokePath(context);
        
        CGContextTranslateCTM(context, -fullRect.size.width / 2, -fullRect.size.width / 2);
    }
}

/**
 *  比例次进度
 *
 *  @param context 全局context
 */
- (void)drawProcessScale:(CGContextRef)context {
    
    CGContextSetLineWidth(context, _scaleDivisionsWidth);//线的宽度
    //======================= 矩阵操作 ============================
    CGContextTranslateCTM(context, fullRect.size.width / 2, fullRect.size.width / 2);
    
    CGContextSetStrokeColorWithColor(context, _scaleColor.CGColor);//线框颜色
    
    int count = (_scaleCount / 2 + 1) * currentPercent;
    CGFloat scaleAngle = 2 * M_PI / _scaleCount;
    
    // 2. 绘制一些图形
    for (int i = 0; i < count; i++) {
        CGContextMoveToPoint(context, 0, scaleRect.size.width/2 - _scaleDivisionsLength);
        CGContextAddLineToPoint(context, 0, scaleRect.size.width/2);
        //    CGContextScaleCTM(ctx, 0.5, 0.5);
        // 3. 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, scaleAngle);
    }
    
    CGContextRotateCTM(context, -count * scaleAngle);
    
    for (int i = 0; i < count; i++) {
        CGContextMoveToPoint(context, 0, scaleRect.size.width/2 - _scaleDivisionsLength);
        CGContextAddLineToPoint(context, 0, scaleRect.size.width/2);
        //    CGContextScaleCTM(ctx, 0.5, 0.5);
        // 3. 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, -scaleAngle);
    }
    
    
    CGContextTranslateCTM(context, -fullRect.size.width / 2, -fullRect.size.width / 2);
}

- (void)drawLabel:(CGContextRef)context {
    
    NSMutableAttributedString *attriButedText = [self formatBatteryLevel:_percent * 100];
    CGRect textSize = [attriButedText boundingRectWithSize:CGSizeMake(400, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    NSMutableAttributedString *attriLabelText = [self formatLabel:@"汽车当前电量"];
    CGRect labelSize = [attriLabelText boundingRectWithSize:CGSizeMake(400, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    CGPoint textPoint = CGPointMake(fullRect.size.width / 2 - textSize.size.width / 2, fullRect.size.height / 2 - textSize.size.height / 2 - labelSize.size.height / 2);
    CGPoint labelPoint = CGPointMake(fullRect.size.width / 2 - labelSize.size.width / 2, textPoint.y + textSize.size.height);
    
    [attriButedText drawAtPoint:textPoint];
    [attriLabelText drawAtPoint:labelPoint];
    
    //推入
    CGContextSaveGState(context);
}

/**
 *  实时调用产生波浪的动画效果
 */
-(void)animateWave
{
    if (targetLinePointY == self.frame.size.height ||
        currentLinePointY == 0) {
        return;
    }
    
    if (targetLinePointY < currentLinePointY) {
        currentLinePointY -= 1;
        currentPercent = (waveRect.size.height - currentLinePointY) / waveRect.size.height;
    }
    
    if (targetLinePointY > currentLinePointY) {
        currentLinePointY += 1;
        currentPercent = (waveRect.size.height - currentLinePointY) / waveRect.size.height;
    }
    
    if (increase) {
        a += 0.01;
    } else {
        a -= 0.01;
    }
    
    
    if (a <= 1) {
        increase = YES;
    }
    
    if (a >= 1.5) {
        increase = NO;
    }
    
    b += 0.1;
    
    [self setNeedsDisplay];
}

/**
 * Core Graphics rotation in context
 */
- (void)rotateContext:(CGContextRef)context fromCenter:(CGPoint)center_ withAngle:(CGFloat)angle
{
    CGContextTranslateCTM(context, center_.x, center_.y);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -center_.x, -center_.y);
}

/**
 *  根据圆心点和圆上一个点计算角度
 *
 *  @param centerPoint 圆心点
 *  @param point       圆上的一个点
 *
 *  @return 角度
 */
- (CGFloat)calculateRotateDegree:(CGPoint)centerPoint point:(CGPoint)point {
    
    CGFloat rotateDegree = asin(fabs(point.y - centerPoint.y) / (sqrt(pow(point.x - centerPoint.x, 2) + pow(point.y - centerPoint.y, 2))));
    
    //如果point纵坐标大于原点centerPoint纵坐标(在第一和第二象限)
    if (point.y > centerPoint.y) {
        //第一象限
        if (point.x >= centerPoint.x) {
            rotateDegree = rotateDegree;
        }
        //第二象限
        else {
            rotateDegree = M_PI - rotateDegree;
        }
    } else //第三和第四象限
    {
        if (point.x <= centerPoint.x) //第三象限，不做任何处理
        {
            rotateDegree = M_PI + rotateDegree;
        }
        else //第四象限
        {
            rotateDegree = 2 * M_PI - rotateDegree;
        }
    }
    return rotateDegree;
}

/**
 *  格式化电量的Label的字体
 *
 *  @param percent 百分比
 *
 *  @return 电量百分比文字参数
 */
-(NSMutableAttributedString *) formatBatteryLevel:(NSInteger)percent
{
    UIColor *textColor = [UIColor whiteColor];
    NSMutableAttributedString *attrText;
    
    NSString *percentText=[NSString stringWithFormat:@"%ld%%",(long)percent];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    if (percent<10) {
        attrText=[[NSMutableAttributedString alloc] initWithString:percentText];
        UIFont *capacityNumberFont=[UIFont fontWithName:@"HelveticaNeue-Thin" size:60];
        UIFont *capacityPercentFont=[UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
        [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 1)];
        [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(1, 1)];
        [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 2)];
        [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 2)];
        
    } else {
        attrText=[[NSMutableAttributedString alloc] initWithString:percentText];
        UIFont *capacityNumberFont=[UIFont fontWithName:@"HelveticaNeue-Thin" size:60];
        UIFont *capacityPercentFont=[UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
        
        
        if (percent>=100) {
            
            [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 3)];
            [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(3, 1)];
            [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 4)];
            [attrText addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 4)];
        } else {
            [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 2)];
            [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(2, 1)];
            [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 3)];
            [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 3)];
        }
        
    }
    
    
    return attrText;
}

/**
 *  显示信息Label参数
 *
 *  @param text 显示的文字
 *
 *  @return 相关参数
 */
-(NSMutableAttributedString *) formatLabel:(NSString*)text
{
    UIColor *textColor = [UIColor whiteColor];
    NSMutableAttributedString *attrText;
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    attrText=[[NSMutableAttributedString alloc] initWithString:text];
    [attrText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
    [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, text.length)];
    
    return attrText;
}

#pragma mark - Setter

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    currentPercent = percent;
    targetLinePointY = waveRect.size.height * (1 - _percent);
    [self initDrawingRects];
}

- (void)setWaterBgColor:(UIColor *)waterBgColor {
    _waterBgColor = waterBgColor;
    [self initDrawingRects];
}

- (void)setFrontWaterColor:(UIColor *)frontWaterColor {
    _frontWaterColor = frontWaterColor;
    [self initDrawingRects];
}

- (void)setBackWaterColor:(UIColor *)backWaterColor {
    _backWaterColor = backWaterColor;
    [self initDrawingRects];
}

- (void)setLineBgColor:(UIColor *)lineBgColor {
    _lineBgColor = lineBgColor;
    [self initDrawingRects];
}

- (void)setScaleColor:(UIColor *)scaleColor {
    _scaleColor = scaleColor;
    [self initDrawingRects];
}

- (void)setShowBgLineView:(BOOL)showBgLineView {
    _showBgLineView = showBgLineView;
    [self initDrawingRects];
}

- (void)setAmplitude:(CGFloat)amplitude {
    _amplitude = amplitude;
    [self initDrawingRects];
}

- (void)setWaveLength:(CGFloat)waveLength {
    _waveLength = waveLength;
    [self initDrawingRects];
}

- (void)setWaveMargin:(CGFloat)waveMargin {
    _waveMargin = waveMargin;
    [self initDrawingRects];
}

@end



@interface WaveProgressVC ()
{
    WaveView *_customView;
}
@end


@implementation WaveProgressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _customView = [[WaveView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, 70, self.view.frame.size.width * 0.8, self.view.frame.size.width * 0.8)];
    _customView.percent = 0.6;
    _customView.showBgLineView = YES;
    _customView.waveLength = self.view.frame.size.width;
    _customView.amplitude = self.view.frame.size.width * 0.8 / 20;
    _customView.showBgLineView = NO;
    _customView.waterBgColor = [UIColor colorWithRed:0.718 green:0.890 blue:0.988 alpha:1.00];
    _customView.lineBgColor = [UIColor colorWithRed:0.749 green:0.910 blue:0.984 alpha:1.00];
    _customView.scaleColor = [UIColor colorWithRed:0.969 green:0.937 blue:0.227 alpha:1.00];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2, self.view.frame.size.width * 0.8 + 100, 150, 20)];
    slider.minimumValue = 0;// 设置最小值
    slider.value = 0.6;
    slider.maximumValue = 1;// 设置最大值
    slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
    slider.continuous = YES;// 设置可连续变化
    slider.minimumTrackTintColor = [UIColor greenColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
    slider.maximumTrackTintColor = [UIColor redColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
    slider.thumbTintColor = [UIColor redColor];//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WaveBg"]];
    [self.view addSubview:_customView];
    [self.view addSubview:slider];
}

- (void)sliderValueChanged: (UISlider *)slider
{
    _customView.percent = slider.value;
}

@end
