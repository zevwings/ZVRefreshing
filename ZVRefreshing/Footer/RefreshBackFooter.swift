//
//  ZRefreshBackFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshBackFooter: RefreshFooter {
    
    fileprivate var lastBottomDelta: CGFloat = 0.0
    fileprivate var lastRefreshCount: Int = 0
    
    override var state: RefreshState {
        get {
            return super.state
        }
        set {
            if self.scrollView == nil { return }
            
            let checked = self.checkState(newValue)
            if checked.result { return }
            super.state = newValue
            
            if newValue == .noMoreData || newValue == .idle {
                
                if checked.oldState == .refreshing {
                    UIView.animate(withDuration: Config.AnimationDuration.slow, animations: {
                        self.scrollView?.insetBottom -= self.lastBottomDelta
                        if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
                        }, completion: { finished in
                            self.pullingPercent = 0.0
                    })
                }
                let deltaH: CGFloat = self.heightForContentBreakView()
                if .refreshing == checked.oldState && deltaH > CGFloat(0.0) && self.scrollView!.totalDataCount != self.lastRefreshCount{
                    self.scrollView!.contentOffset.y = self.scrollView!.contentOffset.y
                }
            } else if newValue == .refreshing{
                
                self.lastRefreshCount = self.scrollView!.totalDataCount
                UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                    var bottom = self.frame.height + self.scrollViewOriginalInset.bottom
                    let deltaH = self.heightForContentBreakView()
                    if deltaH < 0 {
                        bottom -= deltaH
                    }
                    self.lastBottomDelta = bottom - self.scrollView!.contentInset.bottom
                    self.scrollView?.contentInset.bottom = bottom;
                    self.scrollView?.contentOffset.y = self.happenOffsetY() + self.frame.height
                    }, completion: { (flag) in
                        self.executeRefreshCallback()
                })
            }
        }
    }
    
}

extension RefreshBackFooter {
    
    override public func endRefreshing() {
        if let scrollView = self.scrollView {
            
            if scrollView.isKind(of: UICollectionView.classForCoder()) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01)) / Double(NSEC_PER_SEC), execute: {
                    super.endRefreshing()
                })
            } else {
                super.endRefreshing()
            }
        }
    }
    
    override open func endRefreshingWithNoMoreData() {
        if let scrollView = self.scrollView {
            
            if scrollView.isKind(of: UICollectionView.classForCoder()) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01)) / Double(NSEC_PER_SEC), execute: {
                    super.endRefreshingWithNoMoreData()
                })
            } else {
                super.endRefreshingWithNoMoreData()
            }
        }
    }
}

extension RefreshBackFooter {
    
    override func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        
        super.scrollViewContentOffsetDidChanged(change)
        
        if self.state == .refreshing { return }
        if self.scrollView == nil { return }
        
        self.scrollViewOriginalInset = self.scrollView!.contentInset
        let currentOffsetY = self.scrollView!.contentOffset.y
        let happenOffsetY = self.happenOffsetY()
        if currentOffsetY <= happenOffsetY { return }
        
        let pullingPercent = (currentOffsetY - happenOffsetY) / self.frame.height
        
        if (self.state == .noMoreData) {
            self.pullingPercent = pullingPercent
            return
        }
        
        if self.scrollView!.isDragging {
            self.pullingPercent = pullingPercent
            let normal2pullingOffsetY = happenOffsetY + self.frame.height
            if self.state == .idle && currentOffsetY > normal2pullingOffsetY {
                self.state = .pulling
            } else if self.state == .pulling && currentOffsetY <= normal2pullingOffsetY {
                self.state = .idle
            }
        } else if (self.state == .pulling) {
            self.beginRefreshing()
        } else if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent
        }
        
    }
    override func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        
        super.scrollViewContentSizeDidChanged(change)
        
        let contentHeight = self.scrollView!.contentSize.height + self.ignoredScrollViewContentInsetBottom
        let scrollHeight = self.scrollView!.frame.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom
        
        self.y = max(contentHeight, scrollHeight)
    }
    
    // MARK: - Private
    fileprivate func heightForContentBreakView() -> CGFloat {
        let h = self.scrollView!.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top
        let height = self.scrollView!.contentSize.height - h
        return height
    }
    
    fileprivate func happenOffsetY() -> CGFloat {
        let deletaH = self.heightForContentBreakView()
        if deletaH > 0 {
            return deletaH - self.scrollViewOriginalInset.top
        } else {
            return -self.scrollViewOriginalInset.top
        }
    }

}
