//
//  NSObject+Addition.swift
//  ZVRefreshing
//
//  Created by zevwings on 19/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

extension NSObject {
    
    class func exchangeInstanceMethod(origin: Selector, target: Selector) {

        guard let originalMethod = class_getInstanceMethod(self, origin),
            let swizzledMethod = class_getInstanceMethod(self, target) else { return }

        let didAddMethod: Bool = class_addMethod(self, origin,
                                                 method_getImplementation(swizzledMethod),
                                                 method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(self, target,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
