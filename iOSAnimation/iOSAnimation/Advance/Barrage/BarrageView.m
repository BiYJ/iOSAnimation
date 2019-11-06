//
//  BarrageView.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import "BarrageView.h"
#import "BarrageItemPTC.h"
#import "UIView+Layout.h"


static NSUInteger defaultBarrageMaxLineCount = 3;


@interface BarrageLine : NSObject
@property (nonatomic, copy) NSArray<UIView<BarrageItemPTC> *> * items;
@end

@implementation BarrageLine
@end



@interface BarrageView ()

@property (nonatomic, strong) CADisplayLink * displayLink; // 用于弹幕动画的定时器
@property (nonatomic, strong) UIView<BarrageItemPTC> * needAnimationItem; // 需要添加的弹幕
@property (nonatomic, strong) NSMutableArray<BarrageLine *> * barrages;
@property (nonatomic, strong) NSMutableSet * reusePool;  // 弹幕重用池

@end


@implementation BarrageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _barrageMaxLineCount = defaultBarrageMaxLineCount;
        _barrageItemSpacing = 16;
        _animationStatus = BarrageAnimationStatus_Stoped;
        
        self.reusePool = [NSMutableSet set];
        self.barrages = [NSMutableArray<BarrageLine *> arrayWithCapacity:_barrageMaxLineCount];
        for (NSInteger i = 0; i < _barrageMaxLineCount; i++) {
            BarrageLine * barrageLine = [[BarrageLine alloc] init];
            barrageLine.items = @[];
            [self.barrages addObject:barrageLine];
        }
    }
    return self;
}


#pragma mark - Public API
/**
  *  @brief   开始弹幕功能
  */
- (BOOL)start
{
    if (_animationStatus != BarrageAnimationStatus_Playing) {
        _animationStatus = BarrageAnimationStatus_Playing;
        [self displayLink];
        return YES;
    }
    return NO;
}

/**
  *  @brief   暂停弹幕动画
  */
- (BOOL)pause
{
    if (_animationStatus == BarrageAnimationStatus_Playing) {
        _animationStatus = BarrageAnimationStatus_Paused;
        [self.displayLink setPaused:YES];
        return YES;
    }
    return NO;
}

/**
  *  @brief   重启弹幕动画
  */
- (BOOL)resume
{
    if (_animationStatus == BarrageAnimationStatus_Paused) {
        _animationStatus = BarrageAnimationStatus_Playing;
        self.displayLink.paused = NO;
        return YES;
    }
    return NO;
}

/**
  *  @brief   终止弹幕功能
  */
- (BOOL)stop
{
    if (_animationStatus != BarrageAnimationStatus_Stoped) {
        _animationStatus = BarrageAnimationStatus_Stoped;
        
        [self __destoryDisplayLink];
        [self.reusePool removeAllObjects];
        self.needAnimationItem = nil;
        
        [_barrages enumerateObjectsUsingBlock:^(BarrageLine * obj, NSUInteger idx, BOOL * stop) {
            for (UIView<BarrageItemPTC> * item in obj.items) {
                [item removeFromSuperview];
            }
            obj.items = @[];
        }];
        return YES;
    }
    return NO;
}

/**
  *  @brief   获取复用池的对象
  */
- (UIView<BarrageItemPTC> *)dequeueReusableItem
{
    UIView<BarrageItemPTC> * item = [_reusePool anyObject];
    if (item) {
        [_reusePool removeObject:item];
    }
    return item;
}


#pragma mark - Private API
/**
  *  @brief   定时器执行
  */
- (void)__update:(CADisplayLink *)displayLink
{
    CFTimeInterval ti = displayLink.duration;
    [self __aminateBarrageItemWithTime:ti];
    
    if (!_needAnimationItem) {
        if ([self.dataSource respondsToSelector:@selector(itemForBarrageView:)]) {
            _needAnimationItem = [self.dataSource itemForBarrageView:self];
        }
    }
    
    if (_needAnimationItem) {
        // 有待播放的弹幕
        if ([self __addItemToBarrages:_needAnimationItem]) {
            _needAnimationItem = nil;
        }
    }
    
    [self __removeFinishedPlayingItem];
}

/**
  *  @brief   销毁定时器
  */
- (void)__destoryDisplayLink
{
    [_displayLink invalidate];
    _displayLink = nil;
}

/**
  *   @brief   更新每个弹幕控件的位置
  */
- (void)__aminateBarrageItemWithTime:(CFTimeInterval)ti
{
    [_barrages enumerateObjectsUsingBlock:^(BarrageLine * obj, NSUInteger idx, BOOL * stop) {
        for (UIView<BarrageItemPTC> * item in obj.items) {
            item.movedDistance += item.speed * ti;
            
            CGFloat x = [self __barrageBeginX] - item.movedDistance;
            NSInteger ix = x;
            NSInteger rightNumber = x*10 - ix*10;
            if (rightNumber > 5) {
                ix ++;
            }
            item.x = ix;
            item.centerY = [self __getBarrageLineCenterYAtIndex:idx];
        }
    }];
}

- (void)__itemFinishPlay:(UIView<BarrageItemPTC> *)item
{
    [item removeFromSuperview];
    [_reusePool addObject:item];
}

/**
  *  @brief    控件尺寸发生变化时，需要调整弹幕控件
  */
- (void)__updateWhenSizeChanged
{
    if (_barrageUnifiedSpeed < 0.00001) {
        return;
    }
    
    for (NSUInteger i = 0; i < _barrages.count; i ++) {
        BarrageLine * barrageLine = _barrages[i];
        
        // 设置统一的速度
        for (NSUInteger j = 0; j < barrageLine.items.count; j ++) {
            UIView<BarrageItemPTC> * item = barrageLine.items[j];
            item.speed = _barrageUnifiedSpeed;
        }
    }
}

/**
  *  @brief   初始化弹幕的配置
  */
- (void)__initItem:(UIView<BarrageItemPTC> *)item
{
    item.movedDistance = 0;

    item.left = [self __barrageBeginX];
    item.y = 0;
}

/**
  *  @brief   弹幕开始的地方。因为是从右侧进入，所以是当前视图的宽
 */
- (NSInteger)__barrageBeginX
{
    return self.width;
}

- (NSInteger)__getBarrageLineCenterYAtIndex:(NSUInteger)index
{
    NSInteger rowHeight = self.height / _barrageMaxLineCount;
    NSInteger centerY = (index + 0.5) * rowHeight;
    
    return centerY;
}

- (void)__configItem:(UIView<BarrageItemPTC> *)item inBarrageLineAtIndex:(NSUInteger)index
{
    item.centerY = [self __getBarrageLineCenterYAtIndex:index];
    item.left = [self __barrageBeginX];
    [self addSubview:item];
}


#pragma mark - Algorithm
/**
  *  @brief   添加弹幕到播放队列，自动判断这时候能否播放新弹幕，如果能则添加成功则返回 YES
  */
- (BOOL)__addItemToBarrages:(UIView<BarrageItemPTC> *)item
{
    if (!item)
        return NO;
    
    [self __initItem:item];
    
    NSMutableArray * freeQueueIndexArr = [NSMutableArray array];
    __block NSUInteger rowIndex = NSNotFound;
    
    [_barrages enumerateObjectsUsingBlock:^(BarrageLine * obj, NSUInteger idx, BOOL * stop) {
        
        UIView<BarrageItemPTC> * curItem = [obj.items lastObject];
        
        if (curItem && curItem.left - self.width > -0.00001) {
            // 还没开始播放
        }
        else {
            NSTimeInterval ti = [self __itemFinishedPlayingTime:item appendDistance:-item.width - self->_barrageItemSpacing];
            NSTimeInterval curTi = [self __itemFinishedPlayingTime:curItem appendDistance:0];
            
            if (curItem && curTi > ti) {
                // 当前弹幕的速度过慢，会被新的弹幕追上
            }
            else {
                if (curItem && self.width - (curItem.right + self->_barrageItemSpacing) < 0.000001) {
                    /// 两个弹幕的距离太短
                }
                else {
                    if (freeQueueIndexArr.count == 0) {
                        rowIndex = idx;
                    }
                    [freeQueueIndexArr addObject:@(idx)];
                }
            }
        }
    }];

    if (freeQueueIndexArr.count > 0) {
        
        int32_t objIndex = arc4random_uniform((int32_t)time(NULL)) % freeQueueIndexArr.count;
        rowIndex = [freeQueueIndexArr[objIndex] integerValue];
        
        BarrageLine * barrageLine = _barrages[rowIndex];
        NSMutableArray<UIView<BarrageItemPTC> *> * mArr = [barrageLine.items mutableCopy];
        [mArr addObject:item];
        barrageLine.items = mArr.copy;
        [self __configItem:item inBarrageLineAtIndex:rowIndex];
        return YES;
    }
    return NO;
}

/**
  *  @brief   弹幕播放完毕还需要多少时间
  */
- (NSTimeInterval)__itemFinishedPlayingTime:(UIView<BarrageItemPTC> *)item
                             appendDistance:(NSInteger)append
{
    if (!item) {
        return 0;
    }
    if (item.right < 0) {
        return 0;
    }
    if (fabs(item.speed) < 0.0000001) {
        /// 没有设置item的速度
        return CGFLOAT_MAX;
    }
    
    NSInteger distance = item.right - 0;
    distance += append;
    NSTimeInterval interval = distance/item.speed;
    return interval;
}

/**
  *  @brief    移除播放完成的弹幕
  */
- (void)__removeFinishedPlayingItem
{
    [_barrages enumerateObjectsUsingBlock:^(BarrageLine * obj, NSUInteger idx, BOOL * stop) {
        
        NSMutableArray * mArr = [NSMutableArray array];
        
        for (NSUInteger j = 0; j < obj.items.count; j++) {
            UIView<BarrageItemPTC> * item = obj.items[j];
            
            if (item.right - 0 < 0.000001) {
                // 播放完成
                [self __itemFinishPlay:item];
            }
            else {
                [mArr addObject:item];
            }
        }
        obj.items = mArr.copy;
    }];
}


#pragma mark - SET & GET
/**
  *  @brief   懒加载
  */
- (CADisplayLink *)displayLink
{
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(__update:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (void)setBarrageMaxLineCount:(NSUInteger)barrageMaxLineCount
{
    if (_barrageMaxLineCount != barrageMaxLineCount) {
        _barrageMaxLineCount = barrageMaxLineCount;
        
        // 增加弹幕行
        if (_barrageMaxLineCount > self.barrages.count) {
            NSUInteger diff = _barrageMaxLineCount - self.barrages.count;
            for (NSInteger i = 0; i < diff; i++) {
                [self.barrages addObject:[[BarrageLine alloc] init]];
            }
        }
        // 减少弹幕行
        else {
            // TODO
        }
    }
}

- (void)setFrame:(CGRect)frame
{
    if (CGSizeEqualToSize(self.frame.size, frame.size) == NO) {
        [super setFrame:frame];
        [self __updateWhenSizeChanged];
    }
    else {
        [super setFrame:frame];
    }
}

@end
