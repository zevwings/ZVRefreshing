//
//  ZRefreshFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class RefreshFooter: RefreshComponent {

    /// 忽略的UIScrollView.contentInset.bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0
    
    /// 是否自动隐藏
    public var isAutomaticallyHidden: Bool = true
    public var pageSize: Int = 0
    public var stateLabelHidden: Bool = false

    override open func willMove(toSuperview newSuperview: UIView?) {
        // 判断superview是否为nil
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
    
    /// 设置组件是否为RefreshState.noMoreData
    public var isNoMoreData: Bool = false {
        didSet {
            if self.isNoMoreData {
                self.state = .noMoreData
            } else {
                self.state = .idle
            }
        }
    }
}

extension RefreshFooter {

    public func endRefreshingWithNoMoreData() {
        self.state = .noMoreData
    }
    
    public func resetNoMoreData() {
        self.state = .idle
    }
}

extension RefreshFooter {
    
    override open func prepare() {
        self.height = Component.Footer.height
    }
}
