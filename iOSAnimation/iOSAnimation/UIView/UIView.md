
## UIView动画封装

其实 UIView 本身对于基本动画和关键帧动画、转场动画都有相应的封装，在对动画细节没有特殊要求的情况下使用起来也要简单的多。可以说在日常开发中 90% 以上的情况使用 UIView 的动画封装方法都可以搞定，因此在熟悉了核心动画的原理之后还是有必要给大家简单介绍一下 UIView 中各类动画使用方法的。

```
[UIView beginAnimations:@"KCBasicAnimation" context:nil];
[UIView setAnimationDuration:5.0];
//[UIView setAnimationDelay:1.0];//设置延迟
//[UIView setAnimationRepeatAutoreverses:NO];//是否回复
//[UIView setAnimationRepeatCount:10];//重复次数
//[UIView setAnimationStartDate:(NSDate *)];//设置动画开始运行的时间
//[UIView setAnimationDelegate:self];//设置代理
//[UIView setAnimationWillStartSelector:(SEL)];//设置动画开始运动的执行方法
//[UIView setAnimationDidStopSelector:(SEL)];//设置动画运行结束后的执行方法

_imageView.center=location;

// 开始动画
[UIView commitAnimations];
```


## 弹簧动画效果

![](https://images0.cnblogs.com/blog/62046/201409/150629081594923.gif)


## 动画设置参数

在动画方法中有一个 `option` 参数，UIViewAnimationOptions 类型，它是一个枚举类型，动画参数分为三类，可以组合使用：

1. 常规动画属性设置（可以同时选择多个进行设置）
    
    * UIViewAnimationOptionLayoutSubviews：动画过程中保证子视图跟随运动。
    * UIViewAnimationOptionAllowUserInteraction：动画过程中允许用户交互。
    * UIViewAnimationOptionBeginFromCurrentState：所有视图从当前状态开始运行。
    * UIViewAnimationOptionRepeat：重复运行动画。
    * UIViewAnimationOptionAutoreverse ：动画运行到结束点后仍然以动画方式回到初始点。
    * UIViewAnimationOptionOverrideInheritedDuration：忽略嵌套动画时间设置。
    * UIViewAnimationOptionOverrideInheritedCurve：忽略嵌套动画速度设置。
    * UIViewAnimationOptionAllowAnimatedContent：动画过程中重绘视图（注意仅仅适用于转场动画）。 
    * UIViewAnimationOptionShowHideTransitionViews：视图切换时直接隐藏旧视图、显示新视图，而不是将旧视图从父视图移除（仅仅适用于转场动画）
    * UIViewAnimationOptionOverrideInheritedOptions ：不继承父动画设置或动画类型。

2. 动画速度控制（可从其中选择一个设置）

    * UIViewAnimationOptionCurveEaseInOut：动画先缓慢，然后逐渐加速。
    * UIViewAnimationOptionCurveEaseIn ：动画逐渐变慢。
    * UIViewAnimationOptionCurveEaseOut：动画逐渐加速。
    * UIViewAnimationOptionCurveLinear ：动画匀速执行，默认值。

3. 转场类型（仅适用于转场动画设置，可以从中选择一个进行设置，基本动画、关键帧动画不需要设置）

    * UIViewAnimationOptionTransitionNone：没有转场动画效果。
    * UIViewAnimationOptionTransitionFlipFromLeft ：从左侧翻转效果。
    * UIViewAnimationOptionTransitionFlipFromRight：从右侧翻转效果。
    * UIViewAnimationOptionTransitionCurlUp：向后翻页的动画过渡效果。   
    * UIViewAnimationOptionTransitionCurlDown ：向前翻页的动画过渡效果。   
    * UIViewAnimationOptionTransitionCrossDissolve：旧视图溶解消失显示下一个新视图的效果。   
    * UIViewAnimationOptionTransitionFlipFromTop ：从上方翻转效果。   
    * UIViewAnimationOptionTransitionFlipFromBottom：从底部翻转效果。


## 关键帧动画

1. 常规动画属性设置（可以同时选择多个进行设置）

    * UIViewKeyframeAnimationOptionLayoutSubviews：动画过程中保证子视图跟随运动。
    * UIViewKeyframeAnimationOptionAllowUserInteraction：动画过程中允许用户交互。
    * UIViewKeyframeAnimationOptionBeginFromCurrentState：所有视图从当前状态开始运行。
    * UIViewKeyframeAnimationOptionRepeat：重复运行动画。
    * UIViewKeyframeAnimationOptionAutoreverse ：动画运行到结束点后仍然以动画方式回到初始点。
    * UIViewKeyframeAnimationOptionOverrideInheritedDuration：忽略嵌套动画时间设置。
    * UIViewKeyframeAnimationOptionOverrideInheritedOptions ：不继承父动画设置或动画类型。

2. 动画模式设置（同前面关键帧动画动画模式一一对应，可以从其中选择一个进行设置）

    * UIViewKeyframeAnimationOptionCalculationModeLinear：连续运算模式。
    * UIViewKeyframeAnimationOptionCalculationModeDiscrete ：离散运算模式。
    * UIViewKeyframeAnimationOptionCalculationModePaced：均匀执行运算模式。
    * UIViewKeyframeAnimationOptionCalculationModeCubic：平滑运算模式。 
    * UIViewKeyframeAnimationOptionCalculationModeCubicPaced：平滑均匀运算模式。


## 转场动画

仅有一个视图 UIImageView 做转场动画，每次转场通过切换 UIImageView 的内容而已。如果有两个完全不同的视图，并且每个视图布局都很复杂，此时要在这两个视图之间进行转场可以使用

```
+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0)
```

方法进行两个视图间的转场，需要注意的是默认情况下`转出的视图会从父视图移除，转入后重新添加`，可以通过`UIViewAnimationOptionShowHideTransitionViews` 参数设置，设置此参数后转出的视图会隐藏（不会移除）转入后再显示。

注意：转场动画设置参数完全同基本动画参数设置；与直接使用转场动画不同的是使用 UIView 的装饰方法进行转场动画其动画效果较少，因为这里无法直接使用私有 API。
