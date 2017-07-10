# ZVRefreshing

![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)[](https://github.com/Carthage/Carthage)
ZRefreshing is a pure-swift and wieldy Refreshing Control.


## Installation
### Cocoapod
First, [CocoaPods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. It has over 34 thousand libraries and is used in over 2.3 million apps. CocoaPods can help you scale your projects elegantly.

```
$ sudo gem install cocoapods
```
Second, Integrate ZVRefreshing with Cocoapods and write it into your Podfile.

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
    use_frameworks!
    pod 'ZVRefreshing'
end
```

Last, install the dependencies in your project.

```
$ pod install
```
### Carthage 
[Carthage](https://github.com/Carthage/Carthage) is intended to be the simplest way to add frameworks to your Cocoa application.

First, you can install Carthage with Homebrew.

```
$ brew update
$ brew install carthage
```

Second, Integrate ZVRefreshing with Carthage and write it into your Cartfile.

```
github "zevwings/ZVRefreshing" ~> 0.0.1
```

Last, install the dependecies by 

```
$ carthage update
```
### Manual
- First, Download this project, And drag ZVRefreshing.xcodeproj to your own project.

- Second, In your Target’s General tab, click the ’+’ button under Linked Frameworks and Libraries.

- Last, Select the `ZRefreshing.framework` to Add to your platform. 

## Usage
在需要使用 `ZVRefreshing`时，使用 `import ZVRefreshing`导入便可以使用

#### Header
1. 使用Target-Action初始化方法，初始化Header

```
let header = RefreshNormalHeader()
header?.addTarget(self, action: #selector(DetailTableViewController.refreshAction(_:)))
self.tableView.header = header

```

2. 使用Block初始化方法，初始化Header

```
let header = RefreshHeader(refreshHandler: {
             // Your code
})
self.tableView.header = header
```

3. 给Header添加 Target and Action

```
header?.addTarget(self, action: #selector(ViewController.refreshAction(_:))

func refreshAction(_ sender: RefreshComponent) {
    // your code
}
```

4. 开始更新

```
self.tableView.header?.beginRefreshing()
```

5. 停止更新

```
self.tableView.header?.beginRefreshing()
```

6. 隐藏上次更新时间文本

```
header.lastUpdatedTimeLabel.isHidden = true
```

7. 隐藏状态文本

```
header.stateLabel.isHidden = true
```

8. 自定义状态文本

```
header.setTitle("下拉后更新...", forState: .idle)
```

9. 自定义动画图片

```
header.setImages(refreshingImages, state: .refreshing)
header.setImages(refreshingImages, duration: 1.0, state: .refreshing)
```

10. 自定义 ActivityIndicator.activityIndicatorViewStyle 属性

```
header.activityIndicatorViewStyle = .whiteLarge
```

11. 自定义 TableView.contentInset属性时，需要设置 RefreshComponent.ignoredScrollViewContentInsetTop属性

```
self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom:0, right: 0)
header.ignoredScrollViewContentInsetTop = 30
```

12. 自定义 ArrowImageView/activityIndicator 与 状态文本间距

```
header.labelInsetLeft = 32.0
```

#### Footer
1. 使用Target-Action初始化方法，初始化Footer

```
let footer = RefreshFooter(target: self, action: #selector(DetailTableViewController.refreshAction(_:)))
self.tableView.footer = footer

```

2. 使用Block初始化方法，初始化Footer

```
let footer = RefreshFooter {
            
        }
self.tableView.footer = footer
```

3. 给Footer添加Target-Action

```
footer?.addTarget(self, action: #selector(ViewController.refreshAction(_:))

func refreshAction(_ sender: RefreshComponent) {
    // your code
}
```

4. 开始更新

```
self.tableView.footer?.beginRefreshing()
```

5. 停止更新

```
self.tableView.footer?.beginRefreshing()
```

6. 隐藏状态文本

```
footer.stateLabel.isHidden = true
```

7. 自定义状态文本

```
footer.setTitle("下拉后更新...", forState: .idle)
```

8. 自定义动画图片

```
footer.setImages(refreshingImages, state: .refreshing)
footer.setImages(refreshingImages, duration: 1.0, state: .refreshing)
```

9. 自定义 ActivityIndicator.activityIndicatorViewStyle 属性

```
footer.activityIndicatorViewStyle = .whiteLarge
```

10. 自定义 TableView.contentInset属性时，需要设置 RefreshComponent.ignoredScrollViewContentInsetTop属性

```
self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
footer.ignoredScrollViewContentInsetBottom
```

11. 自定义 ActivityIndicator 与 状态文本间距

```
footer.labelInsetLeft = 32.0
```

### 自定义方法

支持重写的属性，方法
1. 控件刷新状态 `var state: RefreshState`
2. 控件色调    `var tintColor: UIColor!`
3. 控件初始化
   
```
open func prepare() {}
```
   
4. 控件位置

```
open func placeSubViews() {}
```

5. UIScrollView属性监听方法

- 监听UIScrollView.contentOffset 变化时调用

```
open func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
``` 

- 监听UIScrollView.contentSize 变化时调用

```
open func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
```    
- 监听UIScrollView.panGestureRecognizer.state
 变化时调用

```
open func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
```



