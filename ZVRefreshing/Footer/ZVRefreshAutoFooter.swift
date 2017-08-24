//
//  ZRefreshAutoFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAutoFooter: ZVRefreshFooter {

    public var isAutomaticallyRefresh: Bool = true
    fileprivate var _triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    override open var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            let checked = self.checkState(newValue)
            guard checked.result == false else { return }
            super.refreshState = newValue
            
            if newValue == .refreshing {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.executeRefreshCallback()
                })
            } else if refreshState == .noMoreData || refreshState == .idle {
                if checked.oldState == .refreshing {
                    self.endRefreshingCompletionHandler?()
                }
            }
        }
    }
    
    open override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            guard let scrollView = self.scrollView else { return }
            let isHidden = self.isHidden
            super.isHidden = newValue
            if isHidden {
                if !newValue {
                    scrollView.insetBottom += self.height
                    self.y = scrollView.contentHeight
                }
            } else {
                if newValue {
                    self.refreshState = .idle
                    scrollView.insetBottom -= self.height
                }
            }
        }
    }
    
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if self.scrollView == nil { return }
        if newSuperview == nil {
            if self.isHidden == false {
                self.scrollView?.insetBottom -= self.height
            }
        } else {
            if self.isHidden == false {
                self.scrollView?.insetBottom += self.height
            }
            self.y = self.scrollView!.contentHeight
        }
    }
}

extension ZVRefreshAutoFooter {
    
    override open func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChanged(change)
        guard let scrollView = self.scrollView else { return }
        self.y = scrollView.contentHeight
    }
    
    override open func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChanged(change)
        
        guard self.refreshState == .idle, self.isAutomaticallyRefresh, self.y != 0 else { return }
        guard let scrollView = self.scrollView else { return }
    
        if scrollView.insetTop + scrollView.contentHeight > scrollView.height {
            if scrollView.offsetY >= (scrollView.contentHeight - scrollView.height + self.height * self._triggerAutomaticallyRefreshPercent + scrollView.insetBottom - self.height) {
                let old = (change?[.oldKey] as? NSValue)?.cgPointValue
                let new = (change?[.newKey] as? NSValue)?.cgPointValue
                if old != nil && new != nil && new!.y > old!.y {
                    self.beginRefreshing()
                }
            }
        }
    }
    
    override open func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChanged(change)
        
        guard self.refreshState == .idle else { return }
        guard let scrollView = self.scrollView else { return }

        if scrollView.panGestureRecognizer.state == .ended {
            if scrollView.insetTop + scrollView.contentHeight <= scrollView.height {
                if scrollView.offsetY >= -scrollView.insetTop {
                    self.beginRefreshing()
                }
            } else {
                if scrollView.offsetY >= (scrollView.contentHeight + scrollView.insetBottom - scrollView.height) {
                    self.beginRefreshing()
                }
            }
        }
    }
}
