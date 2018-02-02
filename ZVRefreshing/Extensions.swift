//
//  Extensions.swift
//  Refresh
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public protocol ZVRefreshComponentConfigration: class {
    
    associatedtype H: ZVRefreshComponent
    
    associatedtype F: ZVRefreshComponent
    
    var header: H? { get set }
    
    var footer: F? { get set }
    
}

public protocol ZVRefreshFooterConfigration: class {
    
    associatedtype T: ZVRefreshFooter
    
    var footer: T? { get set }
    
    func refreshFooter(_ refreshFooter: T)
}

public extension UIScrollView {
    
    private struct AssociationKey {
        static var header  = "com.zevwings.assocaiationkey.header"
        static var footer  = "com.zevwings.assocaiationkey.footer"
        static var handler  = "com.zevwings.assocaiationkey.handler"
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



class ClosureWrapper {
    var closure: ZVReloadDataHandler?
    
    init(_ closure: ZVReloadDataHandler?) {
        self.closure = closure
    }
    
    deinit {
        print("ClosureWrapper deinit.")
    }
}

extension UIScrollView {
    
    var reloadDataHandler: ZVReloadDataHandler? {
        get {
            let cl = objc_getAssociatedObject(self, &AssociationKey.handler)
//
            return (cl as? ClosureWrapper)?.closure
        }
        set {
//            print("reloadDataHandler set new value")
//            let cl = ClosureWrapper(newValue)
//            print("cl \(cl)")
//            objc_setAssociatedObject(self, &AssociationKey.handler, cl, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
            
            let collectionView = self as! UICollectionView
            for section in 0 ..< collectionView.numberOfSections  {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
    
    func executeReloadDataBlock() {
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
    
    static let once: Void = {
        UITableView.exchangeInstanceMethod(m1: #selector(UITableView.reloadData),
                                           m2: #selector(UITableView._reloadData))
    }()
    
    @objc func _reloadData() {
        _reloadData()
        executeReloadDataBlock()
    }
}

extension UICollectionView {
    
    static let once: Void = {
        UICollectionView.exchangeInstanceMethod(m1: #selector(UICollectionView.reloadData),
                                                m2: #selector(UICollectionView._reloadData))
    }()
    
    @objc func _reloadData() {
        _reloadData()
        executeReloadDataBlock()
    }
}
