# ZVRefreshing

![](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)[]()
![](https://img.shields.io/badge/CocoaPods-1.4.0-4BC51D.svg?style=flat)[](https://cocoapods.org)
![](https://img.shields.io/badge/Platform-iOS-4BB32E.svg)
![](https://img.shields.io/badge/License-MIT-4BC51D.svg)
![](https://img.shields.io/badge/swift-4.0.0-4BC51D.svg)
<br/>
ZVRefreshing is a pure-swift and  wieldy refresh component.

[中文文档](https://github.com/zevwings/ZVRefreshing/blob/master/README_CN.md)

## Requirements

- iOS 9.0+ 
- Swift 4.0   

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
    pod 'ZVRefreshing' ~> '2.0.0'
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

## Demo
### Appetize
You can use online demo on [Appetize](https://appetize.io/app/hkhybxa53yyw594zp8v5chee0r?device=iphone6s&scale=75&orientation=portrait&osVersion=10.0)

## Genaral Usage
When you need add a refresh widget, you can use `import ZVRefreshing`

### Initialize
There is three ways to initialize this widget.

- Target-Action

```
let header = ZVRefreshNormalHeader(target: NSObject, action: Selector)
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

if you initialize the widget by none-parameters way, you can add refresh handler block or target-action with following code:

1. add a refresh handler
```
// add refresh handler
header?.refreshHandler = {
    // your codes            
}
```
2. add a Target-Action
```
// add refresh target-action
header?.addTarget(Any?, action: Selector)
```
3. add a Target-Action-UIControlEvents.valueChanged
```
// The ZVRefreshComponent extend from UIControl, When isRefreshing properties changed will send a UIControlEvents.valueChanged event.
header?.addTarget(Any, action: Selector, for: .valueChanged)
```

### Functions

The functions is same for header and footer.

1. beginRefreshing()

The widget begin enter into refreshing status. 

```
self.tableView.header?.beginRefreshing()
```

2. endRefreshing()

The widge begin enter into idle status. 

```
self.tableView.header?.endRefreshing()
```

3. setTitle(_:forState:)
To custom the title for widget, this function in `ZVRefreshStateHeader`. 

```
header.setTitle("pull to refresh...", forState: .idle)
header.setTitle("release to refresh...", forState: .pulling)
header.setTitle("loading...", forState: .refreshing)
```

or 

```
 footer.setTitle("pull to refresh...", forState: .idle)
 footer.setTitle("release to refresh...", forState: .pulling)
 footer.setTitle("loading...", forState: .refreshing)
 footer.setTitle("no more data", forState: .noMoreData)
```

4. setImages(_:forState:)
To custom the images for widget, this function in `ZVRefreshAnimationHeader`, you can use it as following code, also you can extend a subclass, like [Example](https://github.com/zevwings/ZVRefreshing/blob/master/Example/Example/Custom/ZVRefreshCustomAnimationHeader.swift)

```
self.setImages(idleImages, forState: .idle)
self.setImages(refreshingImages, forState: .pulling)
self.setImages(refreshingImages, forState: .refreshing)
```

### Properties
#### Header
1. lastUpdatedTimeKey
To storage the last time using this widget, if it dose not set, all your widget will shared a key `com.zevwings.refreshing.lastUpdateTime`

```
header.lastUpdatedTimeKey = "custom last updated key"
```

2. ignoredScrollViewContentInsetTop

when your table set `contentInset` property, you should set it, for example:

```
self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom:0, right: 0)
header.ignoredScrollViewContentInsetTop = 30
```

3. lastUpdatedTimeLabel

To custom the `UILabel` properties for `lastUpdatedTimeLabel`, for example:

```
// hide the lastUpdatedTimeLabel
header.lastUpdatedTimeLabel.isHidden = true
```
or 

```
// set the font for lastUpdatedTimeLabel
header.lastUpdatedTimeLabel.font = .systemFont(ofSize: 16.0)
```

4. lastUpdatedTimeLabelText

To custom the format for showing last time.

```
header.lastUpdatedTimeLabelText = { date in

    if let d = date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return "Last updated：\(formatter.string(from: d))"
    }
    return "There is no record"
}
```
#### Footer 
1. isAutomaticallyHidden
To set the automatically hidden for widget, default is `true`

```
footer.isAutomaticallyHidden = false
```

2. ignoredScrollViewContentInsetBottom
when your table set `contentInset` property, you should set it, for example:

```
self.tableView.contentInset = UIEdgeInsets(top:0, left: 0, bottom:30, right: 0)
footer.ignoredScrollViewContentInsetBottom = 30
```

3. isAutomaticallyRefresh
To set the automatically refresh for widget, default is `true`, this property in `ZVRefreshAutoFooter`

```
footer.isAutomaticallyRefresh = false
```

#### Common
The following properties is same for header and footer.

1. labelInsetLeft
To set the empty width between activityIndicator an label.

```
header.labelInsetLeft = 32.0
```

2. activityIndicator
To custom the properties for `activityIndicator`, the properties @see [ZActivityIndicatorView](https://github.com/zevwings/ZActivityIndicatorView.git)

3. tintColor
To custom the color for all sub-widget.

```
header.tintColor = .black
```

4. stateLabel
To custom the `UILabel` properties for `stateLabel`, for example:

```
// hide the stateLabel
header.stateLabel.isHidden = true
```
or 

```
// set the font for stateLabel
header.stateLabel.font = .systemFont(ofSize: 16.0)
```

5. animationView

To custom the `UIImageView` properties for `stateLabel`, for example:

## Custom Usage

You can extend `ZVRefreshComponent` or it's sub-class to custom your own refresh widget.
like [Example](https://github.com/zevwings/ZVRefreshing/tree/master/Example/Example/Custom).

### Properties

1. state

To custom you needed when refresh state changed.

```
open var state: ZVRefreshComponent.State
```

2. pullingPercent

To custom you needed when widget position changed.

```
open var pullingPercent: CGFloat
```

3. tintColor

To custom you own widget color.

```
open override var tintColor: UIColor!
```

### Functions

1. prepare

To define your own controls, call at `init(frame: CGRect)`.
   
```
open func prepare() {}
```
   
2. placeSubViews

To set your own constrols size and position, call at `layoutSubviews()`.

```
open func placeSubViews() {}
```

3. scrollViewContentOffsetDidChanged

To observe the UIScrollView.contentOffset, call at `UIScrollView.contentOffset` value changed.

```
open func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
``` 

4. scrollViewContentSizeDidChanged

To observe the UIScrollView.contentSize, call at `UIScrollView.contentSize` value changed.

```
open func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
```    
5. scrollViewPanStateDidChanged

To observe the UIScrollView.panGestureRecognizer.state, call at `UIScrollView.panGestureRecognizer.state` value changed.

```
open func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
```

## Update Log

#### V1.2 
This version convert to swift 4.0, add @objc to the functions, The new swift 4.0 feature will update next version.

#### V1.1 Why use UIControl?
The ZVRefrhing v1.0 is base on UIView, but it is not support for RxSwift binding, if the control beginRefreshing, you can use `refreshHandler` or `addTarget(Any?, action: Selector)`, but it not a good idea for `Rx`.
Now, you can use `ZVRefreshing` with `Rx`, like: 

```
self.tableView.footer?.rx.controlEvent(.valueChanged).asObservable()
    .map { [unowned self] _ in
        return self.tableView.footer?.isRefreshing ?? false
    }.filter {
        $0 == true
    }.subscribe(onNext: { [unowned self] _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.footer?.endRefreshing()
        }
    }).disposed(by: _disposeBag);
```

There is a [Simple Demo](https://github.com/zevwings/ZVRefreshing-Rx.git) for Rx.

## Issue or Suggestion
You can issue me on [GitHub](https://github.com/zevwings/ZVRefreshing/issues) or send a email<zev.wings@gmail.com>.
If you have a good idea, tell me.
thanks.

## License
`ZVRefreshing` distributed under the terms and conditions of the [MIT License](https://github.com/zevwings/ZVRefreshing/blob/master/LICENSE).


