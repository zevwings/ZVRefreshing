//
//  ZRefreshBackFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshBackFooter: ZVRefreshFooter {
    
    private var lastBottomDelta: CGFloat = 0.0
    private var lastRefreshCount: Int = 0
    
    // MARK: Observers

    override open func scrollView(_ scrollView: UIScrollView, contentOffsetDidChanged value: [NSKeyValueChangeKey : Any]?) {
        
        super.scrollView(scrollView, contentSizeDidChanged: value)
        
        guard refreshState != .refreshing else { return }
        
        scrollViewOriginalInset = scrollView.contentInset
        let currentOffsetY = scrollView.contentOffset.y
        
        guard currentOffsetY > _happenOffsetY() else { return }
        
        let pullingPercent = (currentOffsetY - _happenOffsetY()) / frame.size.height
        
        if refreshState == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            let normal2pullingOffsetY = _happenOffsetY() + frame.size.height
            if refreshState == .idle && currentOffsetY > normal2pullingOffsetY {
                refreshState = .pulling
            } else if refreshState == .pulling && currentOffsetY <= normal2pullingOffsetY {
                refreshState = .idle
            }
        } else if refreshState == .pulling {
            beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    override open func scrollView(_ scrollView: UIScrollView, contentSizeDidChanged value: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(scrollView, contentSizeDidChanged: value)
        
        let contentHeight = scrollView.contentSize.height + ignoredScrollViewContentInsetBottom
        let scrollHeight = scrollView.frame.size.height - scrollViewOriginalInset.top - scrollViewOriginalInset.bottom + ignoredScrollViewContentInsetBottom
        
        frame.origin.y = max(contentHeight, scrollHeight)
    }
    
    // MARK: Update State
    
    open override func update(refreshState newValue: State) {
        let checked = checkState(newValue)
        guard checked.isIdenticalState == false else { return }
        super.update(refreshState: newValue)
    }
    
    override func doOn(refreshing oldState: ZVRefreshComponent.State) {
        super.doOn(refreshing: oldState)
        
        guard let scrollView = scrollView else { return }
        
        lastRefreshCount = scrollView.totalDataCount
        UIView.animate(withDuration: AnimationDuration.fast, animations: {
            var bottom = self.frame.size.height + self.scrollViewOriginalInset.bottom
            if self._heightForContentBreakView() < 0 {
                bottom -= self._heightForContentBreakView()
            }
            self.lastBottomDelta = bottom - scrollView.contentInset.bottom
            scrollView.contentInset.bottom = bottom
            scrollView.contentOffset.y = self._happenOffsetY() + self.frame.size.height
        }, completion: { finished in
            self.executeRefreshCallback()
        })
    }
    
    override func doOn(idle oldState: ZVRefreshComponent.State) {
        super.doOn(idle: oldState)
        
        guard let scrollView = scrollView else { return }
        
        if oldState == .refreshing {
            UIView.animate(withDuration: AnimationDuration.slow, animations: {
                scrollView.contentInset.bottom -= self.lastBottomDelta
                if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
            }, completion: { finished in
                self.pullingPercent = 0.0
                self.endRefreshingCompletionHandler?()
            })
        }
        if .refreshing == oldState && _heightForContentBreakView() > CGFloat(0.0)
            && scrollView.totalDataCount != lastRefreshCount{
            self.scrollView?.contentOffset.y = scrollView.contentOffset.y
        }
    }
    
    override func doOn(noMoreData oldState: ZVRefreshComponent.State) {
        super.doOn(noMoreData: oldState)
        
        guard let scrollView = scrollView else { return }
        
        if oldState == .refreshing {
            UIView.animate(withDuration: AnimationDuration.slow, animations: {
                scrollView.contentInset.bottom -= self.lastBottomDelta
                if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
            }, completion: { finished in
                self.pullingPercent = 0.0
                self.endRefreshingCompletionHandler?()
            })
        }
        if .refreshing == oldState && _heightForContentBreakView() > CGFloat(0.0)
            && scrollView.totalDataCount != lastRefreshCount{
            self.scrollView?.contentOffset.y = scrollView.contentOffset.y
        }
    }
}

// MARK: - Private

private extension ZVRefreshBackFooter {
    
    private func _heightForContentBreakView() -> CGFloat {
        
        guard let scrollView = scrollView else { return 0.0 }
        
        let h = scrollView.frame.size.height - scrollViewOriginalInset.bottom - scrollViewOriginalInset.top
        let height = scrollView.contentSize.height - h
        return height
    }
    
    private func _happenOffsetY() -> CGFloat {
        
        let deletaH = _heightForContentBreakView()
        if deletaH > 0 {
            return deletaH - scrollViewOriginalInset.top
        } else {
            return -scrollViewOriginalInset.top
        }
    }
}

