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
        return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date
    }

    fileprivate var insetTop: CGFloat = 0.0

    override open var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            let checked = self.checkState(newValue)
            guard checked.result == false else { return }
            super.refreshState = newValue
            
            if newValue == .idle {
                guard checked.oldState == .refreshing else { return }
                
                UserDefaults.standard.set(Date(), forKey: self.lastUpdatedTimeKey)
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
}

extension ZVRefreshHeader {
    
    override open func prepare() {
        super.prepare()
        self.lastUpdatedTimeKey = Config.lastUpdatedTimeKey
        self.height = Component.Header.height
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        self.y = -self.height - self.ignoredScrollViewContentInsetTop
    }
}

extension ZVRefreshHeader {
    
     override open func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChanged(change)
        
        guard let scrollView = self.scrollView else { return }
        
        if self.refreshState == .refreshing {
            guard self.window != nil else { return }
            
            var insetT = -self.scrollView!.offsetY > self.scrollViewOriginalInset.top ? -self.scrollView!.offsetY : self.scrollViewOriginalInset.top
            insetT = insetT > self.height + self.scrollViewOriginalInset.top ? self.height + self.scrollViewOriginalInset.top : insetT
            
            self.scrollView?.insetTop = insetT
            self.insetTop = self.scrollViewOriginalInset.top - insetT
            return
        }
        
        self.scrollViewOriginalInset = scrollView.contentInset
        
        let offsetY = scrollView.offsetY
        let happenOffsetY = -self.scrollViewOriginalInset.top
        
        guard offsetY <= happenOffsetY else { return }
        
        let normal2pullingOffsetY = happenOffsetY - self.height
        let pullingPercent = (happenOffsetY - offsetY) / self.height
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.refreshState == .idle && offsetY < normal2pullingOffsetY {
                self.refreshState = .pulling
            } else if self.refreshState == .pulling && offsetY >= normal2pullingOffsetY {
                self.refreshState = .idle
            }
        } else if self.refreshState == .pulling {
            self.beginRefreshing()
        }else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
}
