
## 一、CAShapeLayer简介

* CAShapeLayer 是一个通过`矢量图形`而不是 bitmap 来绘制的图层子类。
* CAShapeLayer 继承自 CALayer，可以使用 CALayer 的所有属性值。
* CAShapeLayer 需要与贝塞尔曲线配合使用才有意义，使用 CAShapeLayer 与贝塞尔曲线可以画出你想要的图形。

相对于 Core Graphics 绘制图片，使用 CAShapeLayer 有以下一些优点:

1. `渲染快速`。CAShapeLayer 使用了硬件加速(使用 `CPU` 渲染)，绘制同一图形会比用 Core Graphics 快很多
2. `高效使用内存`。一个 CAShapeLayer 不需要像普通 CALayer 一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
3. `不会被图层边界剪裁掉`。一个 CAShapeLayer 可以在边界之外绘制。


## 二、贝塞尔曲线简介

在数学的数值分析领域中，贝济埃曲线（英语：Bézier curve，亦作“贝塞尔”）是计算机图形学中相当重要的参数曲线。([贝塞尔曲线扫盲](https://link.jianshu.com/?t=http://www.html-js.com/article/1628))

贝塞尔曲线对应 iOS 中是 UIBezierPath 对象，它是 CGPathRef 数据类型的封装。path 如果是基于矢量形状的，都用直线和曲线段去创建。我们使用直线段去创建矩形和多边形，使用曲线段去创建弧（arc），圆或者其他复杂的曲线形状。
