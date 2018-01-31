//
//  ZRefreshHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshHeader: ZVRefreshComponent {
    
    struct StorageKey {
        static let lastUpdatedTime = "com.zevwings.refreshing.lastUpdateTime"
    }
    
    /// 用于存储上次更新时间
    public var lastUpdatedTimeKey: String = StorageKey.lastUpdatedTime
    
    /// 需要忽略的ScrollView.contentInset.top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0

    /// 上次更新时间
    internal var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
    }

    private var insetTop: CGFloat = 0.0
    
    // MARK: Subviews
    
    override open func prepare() {
        super.prepare()
        
        lastUpdatedTimeKey = StorageKey.lastUpdatedTime
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        frame.size.height = ComponentHeader.height
        frame.origin.y = -frame.size.height - ignoredScrollViewContentInsetTop
    }

    // MARK: Observers
    
    override open func scrollView(_ scrollView: UIScrollView, contentOffsetDidChanged value: [NSKeyValueChangeKey : Any]?) {
        
        guard refreshState != .refreshing else {
            
            guard window != nil else { return }
            
            var insetT = -scrollView.contentOffset.y > scrollViewOriginalInset.top ? -scrollView.contentOffset.y : scrollViewOriginalInset.top
            insetT = insetT > frame.size.height + scrollViewOriginalInset.top ? frame.size.height + scrollViewOriginalInset.top : insetT
            
            scrollView.contentInset.top = insetT
            insetTop = scrollViewOriginalInset.top - insetT
            
            return
        }
        
        scrollViewOriginalInset = scrollView.contentInset
        
        let offsetY = scrollView.contentOffset.y
        let happenOffsetY = -scrollViewOriginalInset.top
        
        guard offsetY <= happenOffsetY else { return }
        
        let normal2pullingOffsetY = happenOffsetY - frame.size.height
        let pullingPercent = (happenOffsetY - offsetY) / frame.size.height
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if refreshState == .idle && offsetY < normal2pullingOffsetY {
                refreshState = .pulling
            } else if refreshState == .pulling && offsetY >= normal2pullingOffsetY {
                refreshState = .idle
            }
        } else if refreshState == .pulling {
            beginRefreshing()
        }else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    // MARK: Update State
    
    override open func update(refreshState newValue: State) {
        let checked = checkState(newValue)
        guard checked.result == false else { return }
        super.update(refreshState: newValue)
        
        if newValue == .idle {
            
            guard checked.oldState == .refreshing else { return }
            
            UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey)
            UserDefaults.standard.synchronize()
            
            UIView.animate(withDuration: AnimationDuration.slow, animations: {
                self.scrollView?.contentInset.top += self.insetTop
                if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
            }, completion: { finished in
                self.pullingPercent = 0.0
                self.endRefreshingCompletionHandler?()
            })
        } else if newValue == .refreshing {
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: AnimationDuration.fast, animations: {
                    let top = self.scrollViewOriginalInset.top + self.frame.size.height
                    self.scrollView?.contentInset.top = top
                    var offset = self.scrollView!.contentOffset
                    offset.y = -top
                    self.scrollView?.setContentOffset(offset, animated: false)
                }, completion: { finished in
                    self.executeRefreshCallback()
                })
            }
        }
    }
}
