
1. CALayer 包含在 `QuartzCore` 框架中，这是一个跨平台的框架；

2. CALayer 的设计主要是了为了`内容展示`和`动画操作`，CALayer 不能响应事件；

3. CALayer 很多属性在修改时都能形成动画效果，这种属性称为`“隐式动画属性”`。但是对于 UIView 的根图层而言属性的修改并不形成动画效果，因为很多情况下根图层更多的充当`容器`的作用，如果它的属性变动形成动画效果会直接影响子图层

4. UIView 的根图层创建工作完全由 iOS 负责完成，`无法重新创建`，但是可以往根图层中添加子图层或移除子图层。

5. 在使用 Core Animation 开发动画的本质就是将 CALayer 中的内容转化为`位图`从而供硬件操作；

6. 利用 `drawRect:` 方法绘图的本质就是绘制到了 UIView 的 layer（属性）中。在图层中绘图的方式跟原来基本没有区别，只是 drawRect: 方法是由 UIKit 组件进行调用，因此里面可以使用一些 UIKit 封装的方法进行绘图，而直接绘制到图层的方法由于并非 UIKit 直接调用因此只能用原生的 Core Graphics 方法绘制。


## 常用属性

|属性名|描述|是否支持隐式动画|
|:---------|:--------|:-----:|
|anchorPoint|和中心点 position 重合的一个点，称为“锚点”，锚点的描述是相对于 x、y 位置比例而言的，默认在图像中心点(0.5,0.5)的位置|是|
|backgroundColor|图层背景颜色|是|
|borderColor|边框颜色|是|
|borderWidth|边框宽度|是|
|bounds|图层大小|是|
|contents|图层显示内容，例如可以将图片作为图层内容显示|是|
|contentsRect|图层显示内容的大小和位置|是|
|cornerRadius|圆角半径|是|
|doubleSided|图层背面是否显示，默认为YES|否|
|frame|图层大小和位置，不支持隐式动画，所以CALayer中很少使用frame，通常使用bounds和position代替|否|
|hidden|是否隐藏|是|
|mask|图层蒙版|是|
|maskToBounds|子图层是否剪切图层边界，默认为 NO|是|
|opacity|透明度 ，类似于 UIView 的 alpha|是|
|position|图层中心点位置，类似于 UIView 的 center|是|
|shadowColor|阴影颜色|是|
|shadowOffset|阴影偏移量|是|
|shadowOpacity|阴影透明度，注意默认为0，如果设置阴影必须设置此属性|是|
|shadowPath|阴影的形状|是|
|shadowRadius|阴影模糊半径|是|
|sublayers|子图层|是|
|sublayerTransform|子图层形变|是|
|transform|图层形变|是|

* 隐式属性动画的本质是这些属性的变动，`默认隐含了 CABasicAnimation动画实现`，详情大家可以参照 Xcode 帮助文档中“Animatable Properties”一节。
* 在 CALayer 中很少使用 frame 属性，因为 frame 本身不支持动画效果，通常使用 bounds 和 position 代替。
* CALayer 中透明度使用 opacity 表示而不是 alpha；中心点使用 position 表示而不是 center。
* anchorPoint 属性是图层的锚点，范围在（0~1, 0~1）表示在 x、y 轴的比例，`这个点永远可以同 position（中心点）重合`，当图层中心点固定后，调整 anchorPoint 即可达到调整图层显示位置的作用（因为它永远和 position 重合）

![](https://images0.cnblogs.com/blog/62046/201409/150628370964045.png)



## CALayer 绘图

图层绘图有两种方法

1. 通过图层代理 `drawLayer:inContext:` 方法绘制；
2. 通过自定义图层 `drawInContext:` 方法绘制。

不管使用哪种方法绘制完必须调用`图层的 setNeedDisplay` 方法
