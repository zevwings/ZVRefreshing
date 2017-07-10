//
//  Constrants.swift

//
//  Created by ZhangZZZZ on 16/3/28.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public typealias RefreshHandler = () -> ()
public typealias BeginRefreshingCompletionHandler = () -> ()
public typealias EndRefreshingCompletionHandler = () -> ()

internal typealias ReloadDataHandler = @convention(block) (_ totalCount: Int) -> ()

public enum ZVRefreshState: String {
    
    case idle        = "idle"
    case pulling     = "pulling"
    case willRefresh = "willRefresh"
    case refreshing  = "refreshing"
    case noMoreData  = "noMoreData"
    
    static func mapState(with stateString: String?) -> ZVRefreshState {
        
        guard let value = stateString else { return .idle }
        switch value {
        case "idle":
            return .idle
        case "pulling":
            return .pulling
        case "willRefresh":
            return .willRefresh
        case "refreshing":
            return .refreshing
        case "noMoreData":
            return .noMoreData
        default:
            return .idle
        }
    }
}

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
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
}

extension UIScrollView {
    
    var offsetY: CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
    }
    
    var offsetX: CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
            
        }
    }
    
    var contentWidth: CGFloat {
        get {
            return self.contentSize.width
        }
        set {
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
    }
    
    var contentHeight: CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
    }
    
    var insetTop: CGFloat {
        get {
            return self.contentInset.top
        }
        set {
            var inset = self.contentInset
            inset.top = newValue
            self.contentInset = inset
        }
    }
    
    var insetBottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            self.contentInset = inset
        }
    }
    
    var insetLeft: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            var inset = self.contentInset
            inset.left = newValue
            self.contentInset = inset
        }
    }
    
    var insetRight: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            var inset = self.contentInset
            inset.right = newValue
            self.contentInset = inset
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
