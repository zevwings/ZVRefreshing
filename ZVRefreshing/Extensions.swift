//
//  Extensions.swift
//  Refresh
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit


private var headerAssociationKey: UInt8 = 0
private var footerAssociationKey: UInt8 = 0
private var reloadDataClosureKey: UInt8 = 0

public extension UIScrollView {
    
    public var header: RefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &headerAssociationKey) as? RefreshHeader
        }
        set {
            if (self.header != newValue) {
                self.header?.removeFromSuperview()
                if newValue != nil { self.insertSubview(newValue!, at: 0) }
                self.willChangeValue(forKey: "com.zevwings.value.header")
                objc_setAssociatedObject(self, &headerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValue(forKey: "com.zevwings.value.header")
            }
        }
    }
    
    public var footer: RefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &footerAssociationKey) as? RefreshFooter
        }
        set {
            if (self.footer != newValue) {
                self.footer?.removeFromSuperview()
                if newValue != nil { self.insertSubview(newValue!, at: 0) }
                self.willChangeValue(forKey: "com.zevwings.value.footer")
                objc_setAssociatedObject(self, &footerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValue(forKey: "com.zevwings.value.footer")
            }
        }
    }
    
    var totalDataCount: Int {
        get {
            var totalCount: Int = 0
            if self.isKind(of: UITableView.classForCoder()) {
                let tableView = self as? UITableView
                for section in 0 ..< tableView!.numberOfSections {
                    totalCount += tableView!.numberOfRows(inSection: section)
                }
            } else if self.isKind(of: UICollectionView.classForCoder()) {
                let collectionView = self as? UICollectionView
                
                for section in 0 ..< collectionView!.numberOfSections  {
                    totalCount += collectionView!.numberOfItems(inSection: section)
                }
            }
            return totalCount
        }
    }
    
    internal var reloadDataClosure: ReloadDataClosure? {
        get {
            let value = objc_getAssociatedObject(self, &reloadDataClosureKey)
            let closure = unsafeBitCast(value, to: ReloadDataClosure.self)
            return closure
        }
        set {
            var value: AnyObject? = nil
            if newValue != nil {
                value = unsafeBitCast(
                    newValue,
                    to: AnyObject.self
                )
            }
            objc_setAssociatedObject(self, &reloadDataClosureKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    func executeReloadDataBlock() {
        self.reloadDataClosure?(self.totalDataCount)
    }
}

//extension UITableView {
//    
//    override open class func initialize() {
//        struct Static {
//            static var token: Int = 0
//        }
//        
//        if self !== UITableView.self {
//            return
//        }
//        
//        dispatch_once(&Static.token) {
//            self.exchangeInstanceMethod(m1: #selector(UITableView.reloadData),
//                                        m2: #selector(UITableView.refreshReloadData))
//        }
//    }
//
//    func refreshReloadData() {
//        self.refreshReloadData()
//        self.executeReloadDataBlock()
//    }
//}
//
//extension UICollectionView {
//    
//    override open class func initialize() {
//        struct Static {
//            static var token: Int = 0
//        }
//        
//        if self !== UICollectionView.self {
//            return
//        }
//        
//        dispatch_once(&Static.token) {
//            self.exchangeClassMethod(m1: #selector(UICollectionView.reloadData),
//                                     m2: #selector(UICollectionView.refreshReloadData))
//        }
//    }
//    
//    func refreshReloadData() {
//        self.refreshReloadData()
//        self.executeReloadDataBlock()
//    }
//}
//
//extension NSObject {
//    
//    class func exchangeInstanceMethod(m1: Selector, m2: Selector) {
//        
//        let method1 = class_getInstanceMethod(self, m1)
//        let method2 = class_getInstanceMethod(self, m2)
//        
//        let didAddMethod = class_addMethod(self, m1, method_getImplementation(method2), method_getTypeEncoding(method2))
//        
//        if didAddMethod {
//            class_replaceMethod(self, m2, method_getImplementation(method1), method_getTypeEncoding(method1))
//        } else {
//            method_exchangeImplementations(method1, method2);
//        }
//    }
//    
//    class func exchangeClassMethod(m1: Selector, m2: Selector) {
//        
//        let method1 = class_getClassMethod(self, m1)
//        let method2 = class_getClassMethod(self, m2)
//        let didAddMethod = class_addMethod(self, m1, method_getImplementation(method2), method_getTypeEncoding(method2))
//        
//        if didAddMethod {
//            class_replaceMethod(self, m2, method_getImplementation(method1), method_getTypeEncoding(method1))
//        } else {
//            method_exchangeImplementations(method1, method2);
//        }
//    }
//}
