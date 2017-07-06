//
//  ZRefreshAutoFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshAutoFooter: RefreshFooter {

    open var automaticallyRefresh: Bool = true
    fileprivate var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    override var state: RefreshState {
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
            let isHidden = self.isHidden
            super.isHidden = newValue
            if isHidden {
                if !newValue {
                    self.scrollView?.contentInset.bottom += self.frame.height
                    self.frame.origin.y = self.scrollView!.contentSize.height
                }
            } else {
                if newValue {
                    self.state = .idle
                    self.scrollView?.contentInset.bottom -= self.frame.height
                }
            }
        }
    }
    
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if self.scrollView == nil { return }
        if newSuperview == nil {
            if self.isHidden == false {
                self.scrollView?.contentInset.bottom -= self.frame.height
            }
        } else {
            if self.isHidden == false {
                self.scrollView?.contentInset.bottom += self.frame.height
            }
            self.frame.origin.y = self.scrollView!.contentSize.height
        }
    }
    
    override func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        
        super.scrollViewContentSizeDidChanged(change)
        self.frame.origin.y = self.scrollView!.contentSize.height
    }
    
    override func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        
        super.scrollViewContentOffsetDidChanged(change)
        if self.state != .idle || !self.automaticallyRefresh || self.frame.origin.y == 0 {
            return
        }
        
        if let scrollView = self.scrollView {
            if scrollView.contentInset.top + scrollView.contentSize.height > scrollView.frame.height {
                if scrollView.contentOffset.y >=
                    (scrollView.contentSize.height - scrollView.frame.height +
                        self.frame.height * self.triggerAutomaticallyRefreshPercent +
                        scrollView.contentInset.bottom - self.frame.height) {
                    let old = (change?[.oldKey] as? NSValue)?.cgPointValue
                    let new = (change?[.newKey] as? NSValue)?.cgPointValue
                    if old != nil && new != nil && new!.y > old!.y {
                        self.beginRefreshing()
                    }
                }
            }
        }
    }
    
    override func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChanged(change)
        if self.state != .idle { return }

        if let scrollView = self.scrollView {
            if scrollView.panGestureRecognizer.state == .ended {
                if (scrollView.contentInset.top + scrollView.contentSize.height) <= scrollView.frame.height {
                    if scrollView.contentOffset.y >= -scrollView.contentInset.top {
                        self.beginRefreshing()
                    }
                } else {
                    if scrollView.contentOffset.y >= (scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.frame.height) {
                        self.beginRefreshing()
                    }
                }
            }
        }
    }
}
