//
//  ZRefreshFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshFooter: ZVRefreshComponent {

    /// 忽略的UIScrollView.contentInset.bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0
    
    /// 是否自动隐藏
    public var isAutomaticallyHidden: Bool = true
    
    // MARK: Getter & Setter
    
    /// 设置组件是否为RefreshState.noMoreData
    public var isNoMoreData: Bool = false {
        didSet {
            if isNoMoreData {
                refreshState = .noMoreData
            } else {
                refreshState = .idle
            }
        }
    }
    
    // MARK: State Control
    public func endRefreshingWithNoMoreData() {
        refreshState = .noMoreData
    }
    
    public func resetNoMoreData() {
        refreshState = .idle
    }
    
    // MARK: Subviews
    override open func prepare() {
        frame.size.height = ComponentFooter.height
    }
}

// MARK: - Override

extension ZVRefreshFooter {
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        
        guard let superview = newSuperview as? UIScrollView else { return }
        super.willMove(toSuperview: superview)
        
        if  superview.isKind(of: UITableView.classForCoder()) ||
            superview.isKind(of: UICollectionView.classForCoder()) {
            superview.reloadDataHandler = { totalCount in
                if self.isAutomaticallyHidden {
                    self.isHidden = (totalCount == 0)
                }
            }
        }
    }
}

