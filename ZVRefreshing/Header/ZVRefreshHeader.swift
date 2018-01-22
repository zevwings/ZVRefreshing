//
//  ZRefreshHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshHeader: ZVRefreshComponent {
    
    /// 用于存储上次更新时间
    public var lastUpdatedTimeKey: String = Config.lastUpdatedTimeKey
    
    /// 需要忽略的ScrollView.contentInset.top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0

    /// 上次更新时间
    internal var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
    }

    private var insetTop: CGFloat = 0.0
    
    // MARK: Subviews
    open override func prepare() {
        super.prepare()
        lastUpdatedTimeKey = Config.lastUpdatedTimeKey
        height = Component.Header.height
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        y = -height - ignoredScrollViewContentInsetTop
    }

    // MARK: Observers
    open override func scrollView(_ scrollView: UIScrollView, contentOffsetDidChanged value: [NSKeyValueChangeKey : Any]?) {
        
        if refreshState == .refreshing {
            guard window != nil else { return }
            
            var insetT = -scrollView.offsetY > scrollViewOriginalInset.top ? -scrollView.offsetY : scrollViewOriginalInset.top
            insetT = insetT > height + scrollViewOriginalInset.top ? height + scrollViewOriginalInset.top : insetT
            
            scrollView.insetTop = insetT
            insetTop = scrollViewOriginalInset.top - insetT
            return
        }
        
        scrollViewOriginalInset = scrollView.contentInset
        
        let offsetY = scrollView.offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        
        guard offsetY <= happenOffsetY else { return }
        
        let normal2pullingOffsetY = happenOffsetY - height
        let pullingPercent = (happenOffsetY - offsetY) / height
        
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

// MARK: - Private

private extension ZVRefreshHeader {
    
    func set(refreshState newValue: State) {
        
        let checked = checkState(newValue)
        guard checked.result == false else { return }
        super.refreshState = newValue
        
        if newValue == .idle {
            
            guard checked.oldState == .refreshing else { return }
            
            UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey)
            UserDefaults.standard.synchronize()
            
            UIView.animate(withDuration: Config.AnimationDuration.slow, animations: {
                self.scrollView?.insetTop += self.insetTop
                if self.isAutomaticallyChangeAlpha {
                    self.alpha = 0.0
                }
            }, completion: { finished in
                self.pullingPercent = 0.0
                self.endRefreshingCompletionHandler?()
            })
        } else if newValue == .refreshing {
            
            UIView.animate(withDuration: Config.AnimationDuration.slow, animations: {
                let top = self.scrollViewOriginalInset.top + self.height
                self.scrollView?.insetTop = top
                self.scrollView?.offsetY = -top
            }, completion: { finished in
                self.executeRefreshCallback()
            })
        }
    }
}
