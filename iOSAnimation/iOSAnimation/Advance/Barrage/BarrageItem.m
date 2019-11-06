//
//  BarrageItem.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import "BarrageItem.h"

@interface BarrageItem ()
{
    CGFloat __speed;
    CGFloat __movedDistance;
}
@property (nonatomic, strong) UILabel * barrageLabel;
@end


@implementation BarrageItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.maxWidth = 320;
        [self addSubview:self.barrageLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _barrageLabel.frame = self.bounds;
}


#pragma mark - BarrageItemPTC
/**
  *  @brief   协议类声明了 setter、getter 方法，没有实例变量
  */
- (void)setSpeed:(CGFloat)speed
{
    __speed = speed;
}

- (CGFloat)speed
{
    return __speed;
}

- (void)setMovedDistance:(CGFloat)movedDistance
{
    __movedDistance = movedDistance;
}

- (CGFloat)movedDistance
{
    return __movedDistance;
}


#pragma mark - SET

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _barrageLabel.textColor = textColor;
}

- (void)setContent:(NSString *)content
{
    // 内容发生改变
    if (![_content isEqualToString:content]) {
        _content = content;
        _barrageLabel.text = _content;  // 使用指针地址访问，不调用 getter 方法
        
        CGSize size = [_barrageLabel sizeThatFits:CGSizeMake(_maxWidth, 20)];
        self.bounds = CGRectMake(0, 0, size.width, size.height);
    }
}


#pragma mark - GET

- (UILabel *)barrageLabel
{
    if (_barrageLabel == nil) {
        _barrageLabel = ({
            UILabel * lab = [[UILabel alloc] init];
            lab.backgroundColor = [UIColor clearColor];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textAlignment = NSTextAlignmentLeft;
            lab.textColor = [UIColor whiteColor];
            lab;
        });
    }
    return _barrageLabel;
}

@end
