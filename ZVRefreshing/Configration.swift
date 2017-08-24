//
//  Constrants.swift

//
//  Created by ZhangZZZZ on 16/3/28.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public typealias ZVRefreshHandler = () -> ()
public typealias ZVBeginRefreshingCompletionHandler = () -> ()
public typealias ZVEndRefreshingCompletionHandler = () -> ()

internal typealias ZVReloadDataHandler = @convention(block) (_ totalCount: Int) -> ()

struct Config {
    
    static let lastUpdatedTimeKey = "com.zevwings.refreshing.lastUpdateTime"
    
    struct KeyPath {
        static let contentOffset = "contentOffset"
        static let contentInset  = "contentInset"
        static let contentSize   = "contentSize"
        static let panState      = "state"
    }
    
    struct AnimationDuration {
        static let fast = 0.25
        static let slow = 0.4
    }
}

struct Component {
    
    static let labelLeftInset: CGFloat = 24.0
    static let font: UIFont = .systemFont(ofSize: 14.0)
    
    static let tintColor: UIColor = .init(white: 90.0/255.0, alpha: 1.0)
    
    struct Header {
        static let height: CGFloat = 54.0
    }
    
    struct Footer {
        static let height: CGFloat = 44.0
    }
}


struct Constants {
    
    struct Header {
        static let idle = "pull down to refresh"
        static let pulling = "release to refresh"
        static let refreshing = "loading..."
    }
    
    struct Footer {
        
        struct Auto {
            static let idle = "tap or pull up to load more"
            static let refreshing = "loading..."
            static let noMoreData = "no more data"
        }
        
        struct Back {
            static let idle = "pull up to load more"
            static let pulling = "release to load more"
            static let refreshing = "loading..."
            static let noMoreData = "no more data"
        }
    }
    
    struct State {
        static let lastUpdatedTime = "last update:"
        static let dateToday = "today"
        static let noLastTime = "no record"
    }
}

internal extension UIView {
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}

extension UIScrollView {
    
    var offsetY: CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            self.contentOffset.y = newValue
        }
    }
    
    var offsetX: CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            self.contentOffset.x = newValue
        }
    }
    
    var contentWidth: CGFloat {
        get {
            return self.contentSize.width
        }
        set {
            self.contentSize.width = newValue
        }
    }
    
    var contentHeight: CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            self.contentSize.height = newValue
        }
    }
    
    var insetTop: CGFloat {
        get {
            return self.contentInset.top
        }
        set {
            self.contentInset.top = newValue
        }
    }
    
    var insetBottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.bottom = newValue
        }
    }
    
    var insetLeft: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.left = newValue
        }
    }
    
    var insetRight: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.right = newValue
        }
    }
}

internal extension UILabel {
    
    /// 获取textWidth 的宽度
    var textWidth: CGFloat {
        
        let size = CGSize(width: Int.max, height: Int.max)
        guard let text = self.text else { return 0 }
        let textWidth = (text as NSString).boundingRect(with: size,
                                                        options: .usesLineFragmentOrigin,
                                                        attributes: [NSFontAttributeName: self.font],
                                                        context: nil).size.width
        return textWidth
    }
}

internal extension UILabel {
    
    class var `default`: UILabel {
        let label = UILabel(frame: .zero)
        label.font = Component.font
        label.textColor = Component.tintColor
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
}

internal extension Bundle {
    
    class var current: Bundle {
        return Bundle(for: ZVRefreshComponent.self)
    }
    
    class var resource: Bundle? {
        
        guard let path = self.current.path(forResource: "Resource", ofType: "bundle") else {
            return nil
        }
        
        return Bundle(path: path)
    }
}

func localized(string key: String, comment: String = "") -> String {
    guard let bundle = Bundle.resource else { return "" }
    return NSLocalizedString(key, tableName: tableName(), bundle: bundle, value: "", comment: comment.isEmpty ? key: comment)
}

func tableName() -> String {
    guard let language = Locale.preferredLanguages.first else { return "en"}
    if language.hasPrefix("zh-Hant") {
        return "zh-Hant"
    } else if language.hasPrefix("zh-Hans") {
        return "zh-Hans"
    } else {
        return "en"
    }
}
