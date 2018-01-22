//
//  ZRefreshAutoFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAutoFooter: ZVRefreshFooter {

    public var isAutomaticallyRefresh: Bool = true
    private var _triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    // MARK: Observers

    open override func scrollView(_ scrollView: UIScrollView, contentSizeDidChanged value: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(scrollView, contentSizeDidChanged: value)
        
        y = scrollView.contentHeight
    }
    
    open override func scrollView(_ scrollView: UIScrollView, contentOffsetDidChanged value: [NSKeyValueChangeKey : Any]?) {
        
        guard refreshState == .idle, isAutomaticallyRefresh, y != 0 else { return }
        
        super.scrollView(scrollView, contentSizeDidChanged: value)
        
        if scrollView.insetTop + scrollView.contentHeight > scrollView.height {
            if scrollView.offsetY >= (scrollView.contentHeight - scrollView.height + height * _triggerAutomaticallyRefreshPercent + scrollView.insetBottom - height) {
                let old = (value?[.oldKey] as? NSValue)?.cgPointValue
                let new = (value?[.newKey] as? NSValue)?.cgPointValue
                if old != nil && new != nil && new!.y > old!.y {
                    beginRefreshing()
                }
            }
        }
    }
    
    open override func panGestureRecognizer(_ panGestureRecognizer: UIPanGestureRecognizer, stateValueChanged value: [NSKeyValueChangeKey : Any]?) {
        
        super.panGestureRecognizer(panGestureRecognizer, stateValueChanged: value)
        
        guard refreshState == .idle else { return }

        guard let scrollView = scrollView else { return }

        if scrollView.panGestureRecognizer.state == .ended {
            if scrollView.insetTop + scrollView.contentHeight <= scrollView.height {
                if scrollView.offsetY >= -scrollView.insetTop {
                    beginRefreshing()
                }
            } else {
                if scrollView.offsetY >= (scrollView.contentHeight + scrollView.insetBottom - scrollView.height) {
                    beginRefreshing()
                }
            }
        }
    }
    
    // MARK: Getter & Setter
    
    open override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            set(refreshState: newValue)
        }
    }
    
}

// MARK: - Override

extension ZVRefreshAutoFooter {
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if scrollView == nil { return }
        if newSuperview == nil {
            if isHidden == false {
                scrollView?.insetBottom -= height
            }
        } else {
            if isHidden == false {
                scrollView?.insetBottom += height
            }
            y = scrollView!.contentHeight
        }
    }
    
    open override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            set(isHidden: newValue)
        }
    }


//    open override func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
//        super.scrollViewContentSizeDidChanged(change)
//        guard let scrollView = self.scrollView else { return }
//        self.y = scrollView.contentHeight
//    }
    
//    open override func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
//        super.scrollViewContentOffsetDidChanged(change)
//
//        guard self.refreshState == .idle, self.isAutomaticallyRefresh, self.y != 0 else { return }
//        guard let scrollView = self.scrollView else { return }
//
//        if scrollView.insetTop + scrollView.contentHeight > scrollView.height {
//            if scrollView.offsetY >= (scrollView.contentHeight - scrollView.height + self.height * self._triggerAutomaticallyRefreshPercent + scrollView.insetBottom - self.height) {
//                let old = (change?[.oldKey] as? NSValue)?.cgPointValue
//                let new = (change?[.newKey] as? NSValue)?.cgPointValue
//                if old != nil && new != nil && new!.y > old!.y {
//                    self.beginRefreshing()
//                }
//            }
//        }
//    }
    
//    open override func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
//        super.scrollViewPanStateDidChanged(change)
//        
//        guard self.refreshState == .idle else { return }
//        guard let scrollView = self.scrollView else { return }
//
//        if scrollView.panGestureRecognizer.state == .ended {
//            if scrollView.insetTop + scrollView.contentHeight <= scrollView.height {
//                if scrollView.offsetY >= -scrollView.insetTop {
//                    self.beginRefreshing()
//                }
//            } else {
//                if scrollView.offsetY >= (scrollView.contentHeight + scrollView.insetBottom - scrollView.height) {
//                    self.beginRefreshing()
//                }
//            }
//        }
//    }
}


private extension ZVRefreshAutoFooter {
    
    func set(isHidden newValue: Bool) {
        guard let scrollView = scrollView else { return }
        let isHidden = self.isHidden
        super.isHidden = newValue
        if isHidden {
            if !newValue {
                scrollView.insetBottom += height
                y = scrollView.contentHeight
            }
        } else {
            if newValue {
                refreshState = .idle
                scrollView.insetBottom -= height
            }
        }
    }
    
    func set(refreshState newValue: State) {
        
        let checked = checkState(newValue)
        guard checked.result == false else { return }
        super.refreshState = newValue
        
        if newValue == .refreshing {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.executeRefreshCallback()
            })
        } else if refreshState == .noMoreData || refreshState == .idle {
            if checked.oldState == .refreshing {
                endRefreshingCompletionHandler?()
            }
        }
    }
}
