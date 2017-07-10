# ZVRefreshing

![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)[](https://github.com/Carthage/Carthage)
ZRefreshing 是使用纯Swift开发，简单易用刷新控件。


## Installation
### Cocoapod
第一步，安装 [CocoaPods](https://cocoapods.org)，关于Pods更多的介绍和功能，请移步[CocoaPods 主页](https://cocoapods.org)；

```
$ sudo gem install cocoapods
```
第二步, 使用[CocoaPods](https://cocoapods.org)集成 `ZVRefreshing` ，并写入到你的`Podfile`中；

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
    use_frameworks!
    pod 'ZVRefreshing'
end
```

最后，使用[CocoaPods](https://cocoapods.org) 安装你的依赖库。

```
$ pod install
```
### Carthage 

第一步，使用[Homebrew](https://brew.sh)安装[Carthage](https://github.com/Carthage/Carthage)，关于Carthage更多的介绍和功能，请移步[Carthage 主页](https://github.com/Carthage/Carthage)；

```
$ brew update
$ brew install carthage
```

第二步， 使用[Carthage](https://github.com/Carthage/Carthage)集成 `ZVRefreshing` ，并写入到你的`Cartfile`中；

```
github "zevwings/ZVRefreshing" ~> 0.0.1
```

第三步，使用[Carthage](https://github.com/Carthage/Carthage) 安装依赖；

```
$ carthage update
```

最后，在Carthage/Build文件夹下面找到 `ZVRefreshing.framework` 并拖到Targets -> Genral的Embedded Binaries下。

### Manual
第一步，下载本项目，并将 `ZVRefreshing.xcodeproj` 拖到你的目录下；

第二步，在你的项目配置找到 Targets -> Genral -> Embedded Binaries，点击 `+` 按钮， 选择`ZVRefreshing.framework` 并添加到工程。 

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

当需要自定义刷新控件时，可以继承RefreshComponent或者其子类，支持重写的属性，方法如下
1. 控件刷新状态 

```
var state: RefreshState
```

2. 控件色调    

```
var tintColor: UIColor!
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



