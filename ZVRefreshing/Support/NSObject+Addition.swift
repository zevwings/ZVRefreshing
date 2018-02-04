//
//  NSObject+Addition.swift
//  ZVRefreshing
//
//  Created by zevwings on 19/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

extension NSObject {
    
    class func exchangeInstanceMethod(m1: Selector, m2: Selector) {
        
        let method1 = class_getInstanceMethod(self, m1)
        let method2 = class_getInstanceMethod(self, m2)
        
        let didAddMethod = class_addMethod(self, m1, method_getImplementation(method2!), method_getTypeEncoding(method2!))
        
        if didAddMethod {
            class_replaceMethod(self, m2, method_getImplementation(method1!), method_getTypeEncoding(method1!))
        } else {
            method_exchangeImplementations(method1!, method2!)
        }
    }
}
