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

typealias ZVReloadDataHandler = (_ totalCount: Int) -> ()

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

struct ActivityIndicator {
    static let width = 24.0
}
