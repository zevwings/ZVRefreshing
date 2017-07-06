//
//  ZRefreshHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshHeader: RefreshComponent {
    
    /// 用于存储上次更新时间
    public var lastUpdatedTimeKey: String = Config.lastUpdatedTimeKey
    
    /// 需要忽略的ScrollView.contentInset.top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0

    /// 上次更新时间
    internal var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date
    }

    fileprivate var insetTop: CGFloat = 0.0

    override var state: RefreshState {
        get {
            return super.state
        }
        set {
            let checked = self.checkState(newValue)
            guard checked.result == false else { return }
            super.state = newValue
            
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

extension RefreshHeader {
    
    override func prepare() {
        super.prepare()
        self.lastUpdatedTimeKey = Config.lastUpdatedTimeKey
        self.height = Component.Header.height
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        self.y = -self.height - self.ignoredScrollViewContentInsetTop
    }
}

extension RefreshHeader {
    
    public override func endRefreshing() {
        
        guard let scrollView = self.scrollView else { return }
        
        if scrollView.isKind(of: UICollectionView.self) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 / Double(NSEC_PER_SEC), execute: { 
                super.endRefreshing()
            })
        } else {
            super.endRefreshing()
        }
    }
}

extension RefreshHeader {
    
    internal override func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChanged(change)
        
        guard let scrollView = self.scrollView else { return }
        
        if self.state == .refreshing {
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
            if self.state == .idle && offsetY < normal2pullingOffsetY {
                self.state = .pulling
            } else if self.state == .pulling && offsetY >= normal2pullingOffsetY {
                self.state = .idle
            }
        } else if self.state == .pulling {
            self.beginRefreshing()
        }else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
}
