//
//  ZRefreshBackFooter.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/4/1.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshBackFooter: ZVRefreshFooter {
    
    // MARK: - Property
    
    private var lastBottomDelta: CGFloat = 0.0
    private var lastRefreshCount: Int = 0
    
    // MARK: - Observers

    open override func scrollView(
        _ scrollView: UIScrollView,
        contentOffset oldValue: CGPoint?,
        newValue: CGPoint?
    ) {
        super.scrollView(scrollView, contentOffset: oldValue, newValue: newValue)
        
        guard refreshState != .refreshing else { return }
        
        defaultContentInset = scrollView.contentInset
        let currentOffsetY = scrollView.contentOffset.y
        
        guard currentOffsetY > _happenOffsetY else { return }
        
        let pullingPercent = (currentOffsetY - _happenOffsetY) / frame.height
        
        if refreshState == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            let normal2pullingOffsetY = _happenOffsetY + frame.height
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

    open override func scrollView(
        _ scrollView: UIScrollView,
        contentSize oldValue: CGSize?,
        newValue: CGSize?
    ) {
        super.scrollView(scrollView, contentSize: oldValue, newValue: newValue)

        let contentHeight = scrollView.contentSize.height + ignoredScrollViewContentInsetBottom
        
        //swiftlint:disable:next line_length
        let scrollHeight = scrollView.frame.height - defaultContentInset.top - defaultContentInset.bottom + ignoredScrollViewContentInsetBottom
        
        frame.origin.y = max(contentHeight, scrollHeight)
    }
    
    // MARK: - State Update

    open override func refreshStateUpdate(
        _ state: ZVRefreshComponent.RefreshState,
        oldState: ZVRefreshComponent.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)

        guard let scrollView = scrollView else { return }

        switch state {
        case .idle, .noMoreData:
            if oldState == .refreshing {
                UIView.animate(withDuration: AnimationDuration.slow, animations: {
                    scrollView.contentInset.bottom -= self.lastBottomDelta
                    if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
                }, completion: { _ in
                    self.pullingPercent = 0.0
                })
            }
            if .refreshing == oldState &&
                _heightForContentBreakView > CGFloat(0.0) &&
                scrollView.totalDataCount != lastRefreshCount {
                scrollView.contentOffset.y = scrollView.contentOffset.y
            }
        case .refreshing:
            lastRefreshCount = scrollView.totalDataCount
            UIView.animate(withDuration: AnimationDuration.fast, animations: {
                var bottom = self.frame.height + self.defaultContentInset.bottom
                if self._heightForContentBreakView < 0 {
                    bottom -= self._heightForContentBreakView
                }
                self.lastBottomDelta = bottom - scrollView.contentInset.bottom
                scrollView.contentInset.bottom = bottom
                scrollView.contentOffset.y = self._happenOffsetY + self.frame.height
            }, completion: { _ in
                self.executeRefreshCallback()
            })
        default:
            break
        }
    }
}

// MARK: - Private

private extension ZVRefreshBackFooter {
    
    private var _heightForContentBreakView: CGFloat {
        
        guard let scrollView = scrollView else { return 0.0 }
        
        let height = scrollView.frame.height - defaultContentInset.bottom - defaultContentInset.top
        return scrollView.contentSize.height - height
    }
    
    private var _happenOffsetY: CGFloat {
        
        let deletaH = _heightForContentBreakView
        if deletaH > 0 {
            return deletaH - defaultContentInset.top
        } else {
            return -defaultContentInset.top
        }
    }
}
