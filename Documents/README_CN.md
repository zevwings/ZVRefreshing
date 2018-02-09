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

在`ZVRefreshing`中定义好了6个可以直接使用的空间，可以根据自己的需求选择需要的控件。

#### 使用自定义指示器的
1. ZVRefreshFlatHeader

![Flat-Header](https://github.com/zevwings/ZVRefreshing/blob/master/Documents/Resource/Flat-Header.gif)

2. ZVRefreshAutoFlatFooter

![Flat-AutoFooter](https://github.com/zevwings/ZVRefreshing/blob/master/Documents/Resource/Flat-AutoFooter.gif)

3. ZVRefreshBackFlatFooter

![Flat-BackFooter](https://github.com/zevwings/ZVRefreshing/blob/master/Documents/Resource/Flat-BackFooter.gif)

  
#### 使用原生指示器的
1. ZVRefreshNativeHeader
2. ZVRefreshAutoNativeFooter
3. ZVRefreshBackNativeFooter




### 动画定义篇


### 自定义控件篇

### 初始化

`ZVRefreshing`总共拥有5个初始化方法

1.组件添加了3个自定义初始化方法

2.`UIControl`自带的2个初始化方法

### 属性介绍

### 刷新动画定制

### 自定义刷新控件


## 问题与建议
1. 你们可以在[Github issue](https://github.com/zevwings/ZVRefreshing/issues)添加你们的意见与建议
2. 也可以通过邮箱<zev.wings@gmail.com>联系到我。

如果你们遇到问题或有好的意见，请联系我，谢谢。

## License
`ZVRefreshing` distributed under the terms and conditions of the [MIT License](https://github.com/zevwings/ZVRefreshing/blob/master/LICENSE).