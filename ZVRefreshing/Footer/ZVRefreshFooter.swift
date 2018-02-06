//
//  ZRefreshFooter.swift
//
//  Created by zevwings on 16/3/31.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshFooter: ZVRefreshComponent {

    // MARK: - Property
    
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0
    
    public var isAutomaticallyHidden: Bool = true
    
    public var minimumRowsForAutomaticallyHidden: Int = 0
    
    // MARK: getter & setter
    
    public var isNoMoreData: Bool = false {
        didSet {
            if isNoMoreData {
                endRefreshingWithNoMoreData()
            } else {
                endRefreshing()
            }
        }
    }
    
    // MARK: - State Control
    
    public func endRefreshingWithNoMoreData() {
        self.refreshState = .noMoreData
    }
    
    public func resetNoMoreData() {
        self.refreshState = .idle
    }
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()
        frame.size.height = ComponentFooter.height
    }
}

// MARK: - System Override

extension ZVRefreshFooter {
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        
        guard let superview = newSuperview as? UIScrollView else { return }
        super.willMove(toSuperview: superview)
        
        if  superview.isKind(of: UITableView.classForCoder()) ||
            superview.isKind(of: UICollectionView.classForCoder()) {
            
            superview.reloadDataHandler = { totalCount in
                if self.isAutomaticallyHidden {
                    self.isHidden = (totalCount <= self.minimumRowsForAutomaticallyHidden)
                }
            }
        }
    }
}

