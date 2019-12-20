//
//  ZRefreshAutoFooter.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/3/31.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshAutoFooter: ZVRefreshFooter {

    // MARK: - Property
    
    public var isAutomaticallyRefresh: Bool = true
    private var _triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    // MARK: - State Update

    open override func refreshStateUpdate(
        _ state: ZVRefreshComponent.RefreshState,
        oldState: ZVRefreshComponent.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)

        switch state {
        case .refreshing:
            executeRefreshCallback()
        default:
            break
        }
    }
    
    // MARK: - Observers

    open override func scrollView(
        _ scrollView: UIScrollView,
        contentSize oldValue: CGSize?,
        newValue: CGSize?
    ) {
        super.scrollView(scrollView, contentSize: oldValue, newValue: newValue)

        frame.origin.y = scrollView.contentSize.height
    }

    open override func scrollView(
        _ scrollView: UIScrollView,
        contentOffset oldValue: CGPoint?,
        newValue: CGPoint?
    ) {
        guard refreshState == .idle, isAutomaticallyRefresh, frame.origin.y != 0 else { return }
        super.scrollView(scrollView, contentOffset: oldValue, newValue: newValue)

        if scrollView.contentInset.top + scrollView.contentSize.height > scrollView.frame.height {
            //swiftlint:disable:next line_length
            if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.height + frame.height * _triggerAutomaticallyRefreshPercent + scrollView.contentInset.bottom - frame.height) {
                if oldValue != nil && newValue != nil && newValue!.y > oldValue!.y {
                    beginRefreshing()
                }
            }
        }
    }

    open override func pan(
        _ pan: UIPanGestureRecognizer,
        state oldValue: UIGestureRecognizer.State?,
        newValue: UIGestureRecognizer.State?
    ) {
        super.pan(pan, state: oldValue, newValue: newValue)
        
        guard refreshState == .idle else { return }
        guard let scrollView = scrollView else { return }

        if scrollView.panGestureRecognizer.state == .ended {
            if scrollView.contentInset.top + scrollView.contentSize.height <= scrollView.frame.height {
                if scrollView.contentOffset.y >= -scrollView.contentInset.top {
                    beginRefreshing()
                }
            } else {
                //swiftlint:disable:next line_length
                if scrollView.contentOffset.y >= (scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.frame.height) {
                    beginRefreshing()
                }
            }
        }
    }
}

// MARK: - System Override

extension ZVRefreshAutoFooter {
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        guard let scrollView = scrollView else { return }
        
        if newSuperview == nil {
            if isHidden == false {
                scrollView.contentInset.bottom -= frame.height
            }
        } else {
            if isHidden == false {
                scrollView.contentInset.bottom += frame.height
            }
            frame.origin.y = scrollView.contentSize.height
        }
    }
    
    override open var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            guard let scrollView = scrollView else { return }
            
            let isHidden = self.isHidden
            super.isHidden = newValue
            if isHidden {
                if !newValue {
                    scrollView.contentInset.bottom += frame.height
                    frame.origin.y = scrollView.contentSize.height
                }
            } else {
                if newValue {
                    refreshState = .idle
                    scrollView.contentInset.bottom -= frame.height
                }
            }
        }
    }
}
