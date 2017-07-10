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
You should import `ZVRefreshing` when you needed.

```
import ZVRefreshing
```
#### Header
1. Init Header with target an action.

```
let header = RefreshNormalHeader()
header?.addTarget(self, action: #selector(DetailTableViewController.refreshAction(_:)))
self.tableView.header = header

```

2. Init Header with Block

```
let header = RefreshHeader(refreshHandler: {
             // Your code
})
self.tableView.header = header
```

3. Start Refreshing

```
self.tableView.header?.beginRefreshing()
```

4. Stop Refreshing

```
self.tableView.header?.beginRefreshing()
```

5. Hide the lastUpdateTime

```
header.lastUpdatedTimeLabel.isHidden = true
```

6. Hide the state

```
header.stateLabel.isHidden = true
```

7. Add Target and Action

```
header?.addTarget(self, action: #selector(ViewController.refreshAction(_:))

func refreshAction(_ sender: RefreshComponent) {
    // your code
}

```

8. Custom State label text

```
header.setTitle("下拉后更新...", forState: .idle)
```

9. Custom Animation Images

```
header.setImages(refreshingImages, state: .refreshing)
header.setImages(refreshingImages, duration: 1.0, state: .refreshing)
```

10. Custom ActivityIndicator Style

```
header.activityIndicatorViewStyle = .whiteLarge
```

11. Custom Content Inset Top

```
self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
header.ignoredScrollViewContentInsetTop = 30
```

#### Footer
- Init Footer with target an action.

```
let footer = RefreshBackNormalFooter()
footer?.addTarget(self, action: #selector(DetailTableViewController.refreshAction(_:)))
self.tableView.footer = footer

```
- Init Footer with Block

```
let footer = RefreshHeader(refreshHandler: {
             // Your code
})
self.tableView.footer = footer
```


