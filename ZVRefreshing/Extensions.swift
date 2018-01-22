//
//  Extensions.swift
//  Refresh
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public protocol ZVRefreshComponentProtocol: class {
    associatedtype T: ZVRefreshComponent
    
    var header: T? { get set }
    
}

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
    
    public static let once: Void = {
        UITableView.exchangeInstanceMethod(m1: #selector(UITableView.reloadData),
                                           m2: #selector(UITableView._reloadData))
    }()

    @objc func _reloadData() {
        self._reloadData()
        self.executeReloadDataBlock()
    }
}

extension UICollectionView {
    
    public static let once: Void = {
        UICollectionView.exchangeInstanceMethod(m1: #selector(UICollectionView.reloadData),
                                                m2: #selector(UICollectionView._reloadData))
    }()
    
    @objc func _reloadData() {
        self._reloadData()
        self.executeReloadDataBlock()
    }
}
