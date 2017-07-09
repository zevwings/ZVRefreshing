//
//  ZRefreshAutoFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class RefreshAutoFooter: RefreshFooter {

    public var isAutomaticallyRefresh: Bool = true
    fileprivate var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    override open var state: RefreshState {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).result { return }
            super.state = newValue
            
            if newValue == .refreshing {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.executeRefreshCallback()
                })
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
                    self.state = .idle
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

extension RefreshAutoFooter {
    
    override func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChanged(change)
        guard let scrollView = self.scrollView else { return }
        self.y = scrollView.contentHeight
    }
    
    override func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChanged(change)
        
        guard self.state == .idle, self.isAutomaticallyRefresh, self.y != 0 else { return }
        guard let scrollView = self.scrollView else { return }
    
        if scrollView.insetTop + scrollView.contentHeight > scrollView.height {
            if scrollView.offsetY >= (scrollView.contentHeight - scrollView.height + self.height * self.triggerAutomaticallyRefreshPercent + scrollView.insetBottom - self.height) {
                let old = (change?[.oldKey] as? NSValue)?.cgPointValue
                let new = (change?[.newKey] as? NSValue)?.cgPointValue
                if old != nil && new != nil && new!.y > old!.y {
                    self.beginRefreshing()
                }
            }
        }
    }
    
    override func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChanged(change)
        
        guard self.state == .idle else { return }
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
