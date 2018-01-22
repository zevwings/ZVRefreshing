//
//  Resource.swift
//  ZVRefreshing
//
//  Created by 张伟 on 22/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

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
