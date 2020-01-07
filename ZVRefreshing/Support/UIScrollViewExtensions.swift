//
//  Extensions.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/3/30.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

private struct AssociatedKeys {
    static var refreshHeader = "com.zevwings.refreshing.header"
    static var refreshFooter = "com.zevwings.refreshing.footer"
    static var reloadHandler = "com.zevwings.refreshing.reloadhandler"
}

public extension UIScrollView {

    var refreshHeader: ZVRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshHeader) as? ZVRefreshHeader
        }
        set {
            guard refreshHeader != newValue else { return }
            refreshHeader?.removeFromSuperview()
            willChangeValue(forKey: "refreshHeader")
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.refreshHeader,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            didChangeValue(forKey: "refreshHeader")
            guard let refreshHeader = refreshHeader else { return }
            addSubview(refreshHeader)
            sendSubviewToBack(refreshHeader)
        }
    }

    var refreshFooter: ZVRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshFooter) as? ZVRefreshFooter
        }
        set {
            guard refreshFooter != newValue else { return }
            refreshFooter?.removeFromSuperview()
            willChangeValue(forKey: "refreshFooter")
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.refreshFooter,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            didChangeValue(forKey: "refreshFooter")
            guard let refreshFooter = refreshFooter else { return }
            addSubview(refreshFooter)
            sendSubviewToBack(refreshFooter)
//            onDeinit {
//                print("refresh footer ....")
//            }
        }
    }

    func removeRefreshControls() {
        print("removeRefreshControls")
        refreshHeader?.removeScrollViewObservers()
        refreshHeader?.removeFromSuperview()
        refreshHeader = nil
        refreshFooter?.removeScrollViewObservers()
        refreshFooter?.removeFromSuperview()
        refreshFooter = nil
    }

//    internal func addDeinitializer() {
//        if deinitializationObserver == nil {
//            print("add onDeinit")
//            onDeinit {
//                print("onDeinit")
//                self.removeRefreshControls()
//                self.removeDeinitializationObserver()
//            }
//        }
//    }
}

extension UIScrollView {

    typealias ReloadDataHandler = (_ totalCount: Int) -> Void

    private struct ReloadDataHandlerWrapper {
        var reloadDataHanader: ReloadDataHandler
        init(value: @escaping ReloadDataHandler) {
            self.reloadDataHanader = value
        }
    }

    var reloadDataHandler: ReloadDataHandler? {
        get {
            let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.reloadHandler) as? ReloadDataHandlerWrapper
            return wrapper?.reloadDataHanader
        }
        set {
            if let reloadDataHanader = newValue {
                let wrapper = ReloadDataHandlerWrapper(value: reloadDataHanader)
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.reloadHandler,
                    wrapper,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            } else {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.reloadHandler,
                    nil,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }

    var totalDataCount: Int {

        var totalCount: Int = 0
        if let tableView = self as? UITableView {
            for section in 0 ..< tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
        } else if let collectionView = self as? UICollectionView {
            for section in 0 ..< collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }

    fileprivate func executeReloadDataBlock() {
        reloadDataHandler?(totalDataCount)
    }
}

// MARK: - UICollectionView

extension UICollectionView {

    static let once: Void = {
        SwizzleMethodInstanceMethod(
            origin: (UICollectionView.self, #selector(reloadData)),
            target: (UICollectionView.self, #selector(_reloadData))
        )
    }()

    @objc private func _reloadData() {
        _reloadData()
        executeReloadDataBlock()
    }
}

// MARK: - UITableView

extension UITableView {

    static let once: Void = {
        SwizzleMethodInstanceMethod(
            origin: (UITableView.self, #selector(reloadData)),
            target: (UITableView.self, #selector(_reloadData))
        )
    }()

    @objc private func _reloadData() {
        _reloadData()
        executeReloadDataBlock()
    }
}

// MARK: - UIApplication

extension UIApplication {

    override open var next: UIResponder? {

        UITableView.once
        UICollectionView.once

        return super.next
    }
}

//extension UIScrollView : ObservableDeinitialization {
//
//}
