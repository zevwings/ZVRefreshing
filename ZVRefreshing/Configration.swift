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

struct AnimationDuration {
    static let fast = 0.25
    static let slow = 0.4
}

struct ComponentHeader {
    static let height: CGFloat = 54.0
}

struct ComponentFooter {
    static let height: CGFloat = 44.0
}

struct LocalizedKey {
    
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
