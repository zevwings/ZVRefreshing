//
//  Extensions.swift
//  Refresh
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public extension UIScrollView {
    
    private struct AssociationKey {
        static var header  = "com.zevwings.assocaiationkey.header"
        static var footer  = "com.zevwings.assocaiationkey.footer"
    }
    
    private struct Storage {
        static var handler: ZVReloadDataHandler?
    }
    
    public var refreshHeader: ZVRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &AssociationKey.header) as? ZVRefreshHeader
        }
        set {
            if (self.refreshHeader != newValue) {
                self.refreshHeader?.removeFromSuperview()
                if newValue != nil { self.insertSubview(newValue!, at: 0) }
                self.willChangeValue(forKey: "refreshHeader")
                objc_setAssociatedObject(self, &AssociationKey.header, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "refreshHeader")
            }
        }
    }
    
    public var refreshFooter: ZVRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &AssociationKey.footer) as? ZVRefreshFooter
        }
        set {
            if (self.refreshFooter != newValue) {
                self.refreshFooter?.removeFromSuperview()
                if newValue != nil { self.insertSubview(newValue!, at: 0) }
                self.willChangeValue(forKey: "refreshFooter")
                objc_setAssociatedObject(self, &AssociationKey.footer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "refreshFooter")
            }
        }
    }
    
    var totalDataCount: Int {
        
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
    
    internal var reloadDataHandler: ZVReloadDataHandler? {
        get {
            return Storage.handler
        }
        set {
            Storage.handler = newValue
        }
    }

    func executeReloadDataBlock() {
        self.reloadDataHandler?(self.totalDataCount)
    }
}

extension UITableView {
    

    class func once() {

        struct OnceToken {
            static var token = "com.zevwings.once.table.exchange"
        }

        if self !== UITableView.self { return }
        
        DispatchQueue.once(token: OnceToken.token) {
            UITableView.exchangeInstanceMethod(m1: #selector(UITableView.reloadData),
                                               m2: #selector(UITableView._reloadData))
        }
    }

    @objc func _reloadData() {
        self._reloadData()
        self.executeReloadDataBlock()
    }
}

extension UICollectionView {
    
    class func once() {
        
        struct OnceToken {
            static var token = "com.zevwings.once.collection.exchange"
        }
        
        if self !== UICollectionView.self { return }
        
        DispatchQueue.once(token: OnceToken.token) {
            UICollectionView.exchangeInstanceMethod(m1: #selector(UICollectionView.reloadData),
                                                    m2: #selector(UICollectionView._reloadData))
        }
    }
    
    @objc func _reloadData() {
        self._reloadData()
        self.executeReloadDataBlock()
    }
}

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


