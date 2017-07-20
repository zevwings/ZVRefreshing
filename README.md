# ZVRefreshing

![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)[](https://github.com/Carthage/Carthage)
<br/>
ZVRefreshing is a pure-swift and wieldy refresh component.

[中文文档](https://github.com/zevwings/ZVRefreshing/blob/master/README_CN.md)

## Requirements

- iOS 8.0+ 
- Swift 3.0

## Installation
### Cocoapod
[CocoaPods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects.
<br/>

You can install Cocoapod with the following command

```
$ sudo gem install cocoapods
```
To integrate `ZVRefreshing` into your project using CocoaPods, specify it into your `Podfile`

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
    use_frameworks!
    pod 'ZVRefreshing', :git => 'https://github.com/zevwings/ZVRefreshing.git'
end
```

Then，install your dependencies with [CocoaPods](https://cocoapods.org).

```
$ pod install
```
### Carthage 

[Carthage](https://github.com/Carthage/Carthage) is intended to be the simplest way to add frameworks to your application.

You can install Carthage with [Homebrew](https://brew.sh) using following command:

```
$ brew update
$ brew install carthage
```

To integrate `ZVRefreshing` into your project using Carthage, specify it into your `Cartfile`

```
github "zevwings/ZVRefreshing" ~> 0.0.1
```

Then，build the framework with Carthage
using `carthage update` and drag `ZVRefreshing.framework` into your project.

#### Note:
The framework is under the Carthage/Build, and you should drag it into  `Target` -> `Genral` -> `Embedded Binaries`

### Manual
Download this project, And drag `ZRefreshing.xcodeproj` into your own project.

In your target’s General tab, click the ’+’ button under `Embedded Binaries`

Select the `ZRefreshing.framework` to Add to your platform. 

## Genaral Usage
When you need add a refresh widget, you can use `import ZVRefreshing`

### Initialize
There is three ways to initialize this widget.

- Target-Action

```
let header = ZVRefreshNormalHeader(target: Any, action: Selector)
self.tableView.header = header
```
- Block

```
let header = ZVRefreshNormalHeader(refreshHandler: { 
    // your codes    
})
self.tableView.header = header
```
- None-parameters 

```
let header = RefreshHeader()
self.tableView.header = header
```

if you initialize the widget by none-parameters way,   you can add refresh handler block or target-action with following code:

```
// add refresh handler
header?.refreshHandler = {
    // your codes            
}
// add refresh target-action
header?.addTarget(Any?, action: Selector)
```

### Header 
#### Functions
1. beginRefreshing()

The refresh header begin enter into refreshing status. 

```
self.tableView.header?.beginRefreshing()
```

2. endRefreshing()

The refresh header begin enter into idle status. 

```
self.tableView.header?.endRefreshing()
```

3. setTitle(_:forState:)
To custom the title for refresh header, this function in `ZVRefreshStateHeader`. 

```
header.setTitle("pull to refresh...", forState: .idle)
header.setTitle("release to refresh...", forState: .pulling)
header.setTitle("loading...", forState: .refreshing)
```

4. setImages(_:forState:)
To custom the images for refresh header, this function in `ZVRefreshAnimationHeader`, you can use it as following code, also you can extend a subclass, like [Example](https://github.com/zevwings/ZVRefreshing/blob/master/Example/Example/Custom/ZVRefreshCustomAnimationHeader.swift)

```
self.setImages(idleImages, forState: .idle)
self.setImages(refreshingImages, forState: .pulling)
self.setImages(refreshingImages, forState: .refreshing)
```

#### Properties

1. lastUpdatedTimeKey
To storage the last time using this widget, if it dose not set, all your widget will shared a key `com.zevwings.refreshing.lastUpdateTime`

2. ignoredScrollViewContentInsetTop
3. lastUpdatedTimeLabel
4. lastUpdatedTimeLabelText
5. labelInsetLeft
6. activityIndicator
7. tintColor
8. stateLabel
9. animationView


### Footer
1. beginRefreshing()
The refresh footer begin enter into refreshing status. 

```
self.tableView.footer?.beginRefreshing()
```

1. isAutomaticallyHidden
2. ignoredScrollViewContentInsetBottom
3. isAutomaticallyRefresh

#### Common
1. labelInsetLeft
2. activityIndicator
3. tintColor
4. stateLabel
5. animationView
	⁃	
### 自定义方法

当需要自定义刷新控件时，可以继承RefreshComponent或者其子类，支持重写的属性，方法如下
1. 控件刷新状态 

```
open var state: RefreshState
```

2. 控件色调    

```
open override var tintColor: UIColor!
```

3. 控件初始化
   
```
open func prepare() {}
```
   
4. 控件位置

```
open func placeSubViews() {}
```

5. UIScrollView属性监听方法

- 监听UIScrollView.contentOffset

```
open func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
``` 

- 监听UIScrollView.contentSize

```
open func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
```    
- 监听UIScrollView.panGestureRecognizer.state

```
open func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
```

## License
`ZVProgressHUD` distributed under the terms and conditions of the [MIT License](https://github.com/zevwings/ZVRefreshing/blob/master/LICENSE).


