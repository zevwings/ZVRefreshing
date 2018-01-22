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
