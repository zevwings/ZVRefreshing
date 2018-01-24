//
//  Extensions.swift
//  Refresh
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public protocol ZVRefreshHeaderConfigration: class {
    
    associatedtype T: ZVRefreshHeader
    
    var header: T? { get set }
    
}

public protocol ZVRefreshFooterConfigration: class {
    
    associatedtype T: ZVRefreshFooter
    
    var footer: T? { get set }
    
}

public extension UIScrollView {
    
    private struct AssociationKey {
        static var header  = "com.zevwings.assocaiationkey.header"
        static var footer  = "com.zevwings.assocaiationkey.footer"
    }
    
    public var refreshHeader: ZVRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &AssociationKey.header) as? ZVRefreshHeader
        }
        set {
            if (refreshHeader != newValue) {
                refreshHeader?.removeFromSuperview()
                if newValue != nil { insertSubview(newValue!, at: 0) }
                willChangeValue(forKey: "refreshHeader")
                objc_setAssociatedObject(self, &AssociationKey.header, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValue(forKey: "refreshHeader")
            }
        }
    }
    
    public var refreshFooter: ZVRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &AssociationKey.footer) as? ZVRefreshFooter
        }
        set {
            if (refreshFooter != newValue) {
                refreshFooter?.removeFromSuperview()
                if newValue != nil { insertSubview(newValue!, at: 0) }
                willChangeValue(forKey: "refreshFooter")
                objc_setAssociatedObject(self, &AssociationKey.footer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValue(forKey: "refreshFooter")
            }
        }
    }
}

extension UITableView {
    
    internal static let once: Void = {
        UITableView.exchangeInstanceMethod(m1: #selector(UITableView.reloadData),
                                           m2: #selector(UITableView._reloadData))
    }()

    @objc func _reloadData() {
        _reloadData()
        executeReloadDataBlock()
    }
}

extension UICollectionView {
    
    internal static let once: Void = {
        UICollectionView.exchangeInstanceMethod(m1: #selector(UICollectionView.reloadData),
                                                m2: #selector(UICollectionView._reloadData))
    }()
    
    @objc func _reloadData() {
        _reloadData()
        executeReloadDataBlock()
    }
}

extension UIScrollView {
    
    private struct Storage {
        static var handler: ZVReloadDataHandler?
    }
    
    internal var reloadDataHandler: ZVReloadDataHandler? {
        get {
            return Storage.handler
        }
        set {
            Storage.handler = newValue
        }
    }
    
    var totalDataCount: Int {
        
        var totalCount: Int = 0
        if isKind(of: UITableView.classForCoder()) {
            let tableView = self as? UITableView
            for section in 0 ..< tableView!.numberOfSections {
                totalCount += tableView!.numberOfRows(inSection: section)
            }
        } else if isKind(of: UICollectionView.classForCoder()) {
            let collectionView = self as? UICollectionView
            
            for section in 0 ..< collectionView!.numberOfSections  {
                totalCount += collectionView!.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
    
    func executeReloadDataBlock() {
        reloadDataHandler?(totalDataCount)
    }
}
