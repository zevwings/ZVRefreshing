//
//  Resource.swift
//  ZVRefreshing
//
//  Created by zevwings on 22/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

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

func localized(string key: String, comment: String = "") -> String {
    
    guard let bundle = Bundle.current else { return "" }
    
    var tableName = ""
    guard let language = Locale.preferredLanguages.first else { return "en"}
    if language.hasPrefix("zh-Hant") {
        tableName = "zh-Hant"
    } else if language.hasPrefix("zh-Hans") {
        tableName = "zh-Hans"
    } else {
        tableName = "en"
    }

    return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: "", comment: comment.isEmpty ? key: comment)
}
