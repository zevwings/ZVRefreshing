# ZVRefreshing

![](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)[]()
![](https://img.shields.io/badge/pod-1.4.0-4BC51D.svg?style=flat)[](https://cocoapods.org)
![](https://img.shields.io/badge/platform-ios-4BC51D.svg)
![](https://img.shields.io/badge/swift-4.0.0-4BC51D.svg)
![](https://img.shields.io/badge/License-MIT-4BC51D.svg)
<br/>
ZVRefreshing 是使用纯swift开发的，简单易用的刷新组件。

## 安装方法

### Cocoapods
将如下代码注入到`Podfile`中，并执行 `pod install` 安装依赖库。
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
    use_frameworks!
    pod 'ZVRefreshing', '2.0.0'
end
```
### Carthage

将如下代码注入到`Cartfile`中，并执行`carthage update`安装依赖库。
```
github "zevwings/ZVRefreshing" ~> 2.0.0
```

## 使用方法

`ZVRefreshing`自定义了6个可以直接使用的刷新控件，3个支持动画的基础控件，并提供自定义方法与属性。

下面我们分类介绍这些控件。

### 直接使用篇

在`ZVRefreshing`中定义好了6个可以直接使用的空间，可以根据自己的需求选择需要的控件。具体样式如下列举展示。

#### 使用自定义指示器的

##### ZVRefreshFlatHeader
![Flat-Header.gif](http://upload-images.jianshu.io/upload_images/2463725-4640748d6f164ea2.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### ZVRefreshAutoFlatFooter
![Flat-AutoFooter.gif](http://upload-images.jianshu.io/upload_images/2463725-cd591d4a8ae58386.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### ZVRefreshBackFlatFooter
![Flat-BackFooter.gif](http://upload-images.jianshu.io/upload_images/2463725-ca957d4507cd042d.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 使用原生指示器的
##### ZVRefreshNativeHeader
![Native-Header.gif](http://upload-images.jianshu.io/upload_images/2463725-a2cb404645d4178f.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### ZVRefreshAutoNativeFooter
![Native-AutoFooter.gif](http://upload-images.jianshu.io/upload_images/2463725-d62d1a00ac2d0cc2.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### ZVRefreshBackNativeFooter
![Native-BackFooter.gif](http://upload-images.jianshu.io/upload_images/2463725-78f9b38bc4593246.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 初始化

`ZVRefreshing`总共拥有3个初始化方法及两个`UIControl`的初始化方法

#### Handler Closure

初始化一个刷新控件并添加一个刷新处理的闭包

```
init(refreshHandler:)
```

###### 使用示例：
```
let animationHeader = ZVRefreshCustomAnimationHeader(refreshHandler: { [weak self] in
                      })
```
#### Target-Action

初始化一个刷新控件并添加回调方法

```
init(target:action:)
```

###### 使用示例

```
let animationBackFooter = ZVRefreshBackCustomAnimationFooter(target: self, action: #selector(refreshFooterHandler(_:)))
```

#### Non-Paramters

初始化一个刷新控件，需要自己添加闭包或者回调方法

```
init()
```

###### 添加回调函数

为刷新控件添加一个回调函数

```
flatAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
```

###### 添加闭包

为刷新控件添加一个回调闭包

```
flatAutoFooter?.refreshHandler = { [weak self] in

}
```

###### 使用示例
```
let animationAutoFooter = ZVRefreshAutoCustomAnimationFooter()
```

###### 备注：
1. 控件宽度在控件生命周期的`willMove(toSuperview:)`函数执行是赋值。
2. 控件高度在`prepare()`函数执行时赋值。
3. 综上两点`init(frame:)`不能控制控件大小，如果需要改变控件高度时，需要在子类的 `prepare()` 函数中设置控件高度，宽度随父视图高度改变

### 方法介绍

public func beginRefreshing()

public func endRefreshing()

public func endRefreshingWithNoMoreData()

public func resetNoMoreData()

### 属性介绍

刷新状态

open var refreshState: State

public private(set) var isRefreshing: Bool

public var isAutomaticallyChangeAlpha: Bool

open var pullingPercent: CGFloat

// Header
public var ignoredScrollViewContentInsetTop: CGFloat

public var labelInsetLeft: CGFloat

// Footer
public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0

public var isAutomaticallyHidden: Bool = true

public var minimumRowsForAutomaticallyHidden: Int = 0

// AutoFooter
public var isAutomaticallyRefresh: Bool = true

// labelLeftInset
public var labelInsetLeft: CGFloat = 12.0


// 样式设置
public private(set) var stateLabel: UILabel?
public private(set) var lastUpdatedTimeLabel: UILabel?

// Flat
public private(set) var activityIndicator: ZVActivityIndicatorView?

// Native
public private(set) var arrowView: UIImageView?    
public private(set) var activityIndicator: UIActivityIndicatorView?

// Animation
public private(set) var animationView: UIImageView?


### 刷新动画定制

### 自定义刷新控件

open func prepare()

open func placeSubViews()

open func doOnAnyState(with oldState: State) {}

open func doOnIdle(with oldState: State) {}

open func doOnNoMoreData(with oldState: State) {}

open func doOnPulling(with oldState: State) {}

open func doOnWillRefresh(with oldState: State) {}

open func doOnRefreshing(with oldState: State) {}

open func scrollView(_ scrollView: UIScrollView, contentOffsetDidChanged value: [NSKeyValueChangeKey: Any]?) {}

open func scrollView(_ scrollView: UIScrollView, contentSizeDidChanged value: [NSKeyValueChangeKey: Any]?) {}

open func panGestureRecognizer(_ panGestureRecognizer: UIPanGestureRecognizer, stateValueChanged value: [NSKeyValueChangeKey: Any]?, for scrollView: UIScrollView) {}

## 问题与建议
1. 你们可以在[Github issue](https://github.com/zevwings/ZVRefreshing/issues)添加你们的意见与建议
2. 也可以通过邮箱<zev.wings@gmail.com>联系到我。

如果你们遇到问题或有好的意见，请联系我，谢谢。

## License
`ZVRefreshing` distributed under the terms and conditions of the [MIT License](https://github.com/zevwings/ZVRefreshing/blob/master/LICENSE).
