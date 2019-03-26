//
//  Extensions.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/3/30.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

public extension UIScrollView {
    
    private struct _StorageKey {
        static var refreshHeader = "com.zevwings.refreshing.header"
        static var refreshFooter = "com.zevwings.refreshing.footer"
        static var reloadHandler = "com.zevwings.refreshing.reloadhandler"
    }

    var refreshHeader: ZVRefreshHeader? {
        get {
            if let refreshHeader = objc_getAssociatedObject(self, &_StorageKey.refreshHeader) as? ZVRefreshHeader {
                return refreshHeader;
            } else {
                return nil
            }
        }
        set {
            guard refreshHeader != newValue else { return }
            refreshHeader?.removeFromSuperview()
            willChangeValue(forKey: "refreshHeader")
            objc_setAssociatedObject(self, &_StorageKey.refreshHeader, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "refreshHeader")
            
            guard let _refreshHeader = refreshHeader else { return }
            insertSubview(_refreshHeader, at: 0)
        }
    }

    var refreshFooter: ZVRefreshFooter? {
        get {
            if let refreshFooter = objc_getAssociatedObject(self, &_StorageKey.refreshFooter) as? ZVRefreshFooter {
                return refreshFooter;
            } else {
                return nil
            }
        }
        set {
            guard refreshFooter != newValue else { return }
            refreshFooter?.removeFromSuperview()

            willChangeValue(forKey: "refreshFooter")
            objc_setAssociatedObject(self, &_StorageKey.refreshFooter, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "refreshFooter")

            guard let _refreshFooter = refreshFooter else { return }
            insertSubview(_refreshFooter, at: 0)
        }
    }

    internal var reloadDataHandler: ZVReloadDataHandler? {
        get {
            if let wrapper = objc_getAssociatedObject(self, &_StorageKey.reloadHandler) as? ZVReloadDataHandlerWrapper {
                return wrapper.reloadDataHanader
            } else {
                return nil
            }
        }
        set {
            let wrapper = ZVReloadDataHandlerWrapper(value: newValue)
            objc_setAssociatedObject(self, &_StorageKey.reloadHandler, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var totalDataCount: Int {
        
        var totalCount: Int = 0
        if isKind(of: UITableView.classForCoder()) {
            
            let tableView = self as? UITableView
            for section in 0 ..< tableView!.numberOfSections {
                totalCount += tableView!.numberOfRows(inSection: section)
            }
        } else if isKind(of: UICollectionView.classForCoder()) {
            
            let collectionView = self as! UICollectionView
            for section in 0 ..< collectionView.numberOfSections  {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
    
    internal func executeReloadDataBlock() {
        reloadDataHandler?(totalDataCount)
    }
}


extension UIApplication {
    
    override open var next: UIResponder? {
        
        UITableView.once
        UICollectionView.once
        
        return super.next
    }
}

extension UITableView {
    
    fileprivate static let once: Void = {
        UITableView.exchangeInstanceMethod(m1: #selector(UITableView.reloadData),
                                           m2: #selector(UITableView._reloadData))
    }()
    
    @objc private func _reloadData() {
        _reloadData()
        executeReloadDataBlock()
    }
}

extension UICollectionView {
    
    fileprivate static let once: Void = {
        UICollectionView.exchangeInstanceMethod(m1: #selector(UICollectionView.reloadData),
                                                m2: #selector(UICollectionView._reloadData))
    }()
    
    @objc private func _reloadData() {
        _reloadData()
        executeReloadDataBlock()
    }
}

// wrap and unwrap `ZVReloadDataHandler` as an `AnyObject` value
fileprivate struct ZVReloadDataHandlerWrapper {
    var reloadDataHanader: ZVReloadDataHandler?
    init(value: ZVReloadDataHandler?) {
        self.reloadDataHanader = value
    }
}
