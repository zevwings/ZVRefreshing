//
//  NSObject+Addition.swift
//  ZVRefreshing
//
//  Created by zevwings on 19/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

// MARK: - Swizzle

typealias SwizzleObject = (cls: AnyClass, selector: Selector)

/// 交换实例方法 m1 和 m2 的功能方法
///
/// - Parameters:
///   - m1: Selector
///   - m2: Selector
// swiftlint:disable:next identifier_name
func SwizzleMethodInstanceMethod(origin: SwizzleObject, target: SwizzleObject) {

    guard
        let originalMethod = class_getInstanceMethod(origin.cls, origin.selector),
        let swizzledMethod = class_getInstanceMethod(target.cls, target.selector)
        else { return }

    let didAddMethod: Bool = class_addMethod(origin.cls, origin.selector,
                                             method_getImplementation(swizzledMethod),
                                             method_getTypeEncoding(swizzledMethod))
    if didAddMethod {
        class_replaceMethod(target.cls, target.selector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
