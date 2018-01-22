//
//  DispatchQueue+Addition.swift
//  ZVRefreshing
//
//  Created by 张伟 on 19/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    class func once(token: String, block:() -> Void) {
        
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) { return }
        _onceTracker.append(token)
        block()
    }
}
