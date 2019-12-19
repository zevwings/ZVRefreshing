//
//  ZRefreshHeader.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/3/30.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshHeader: ZVRefreshComponent {
    
    // MARK: - Property
    
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0

    private var insetTop: CGFloat = 0.0
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        frame.size.height = ComponentHeader.height
        frame.origin.y = -frame.height - ignoredScrollViewContentInsetTop
    }

    // MARK: - Observers
    
    override open func scrollView(
        _ scrollView: UIScrollView,
        contentOffsetDidChanged value: [NSKeyValueChangeKey : Any]?
    ) {
        guard refreshState != .refreshing else {
       
            //swiftlint:disable line_length
            var insetT = -scrollView.contentOffset.y > scrollViewOriginalInset.top ? -scrollView.contentOffset.y : scrollViewOriginalInset.top
            insetT = insetT > frame.height + scrollViewOriginalInset.top ? frame.height + scrollViewOriginalInset.top : insetT
            //swiftlint:enable line_length
            scrollView.contentInset.top = insetT
            insetTop = scrollViewOriginalInset.top - insetT
            
            return
        }
        
        scrollViewOriginalInset = scrollView.contentInset
        
        let offsetY = scrollView.contentOffset.y
        let happenOffsetY = -scrollViewOriginalInset.top
        
        guard offsetY <= happenOffsetY else { return }
        
        let normal2pullingOffsetY = happenOffsetY - frame.height
        let percent = (happenOffsetY - offsetY) / frame.height
        
        if scrollView.isDragging {
            pullingPercent = percent
            if refreshState == .idle && offsetY < normal2pullingOffsetY {
                refreshState = .pulling
            } else if refreshState == .pulling && offsetY >= normal2pullingOffsetY {
                refreshState = .idle
            }
        } else if refreshState == .pulling {
            beginRefreshing()
        } else if percent < 1 {
            pullingPercent = percent
        }
    }
    
    // MARK: - Do On State
    
    override open func doOnIdle(with oldState: RefreshState) {
        super.doOnIdle(with: oldState)
        
        guard oldState == .refreshing else { return }
        
        UIView.animate(withDuration: AnimationDuration.slow, animations: {
            self.scrollView?.contentInset.top += self.insetTop
            if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
        }, completion: { _  in
            self.pullingPercent = 0.0
        })
    }
    
    override open func doOnRefreshing(with oldState: RefreshState) {
        super.doOnRefreshing(with: oldState)
        
        UIView.animate(withDuration: AnimationDuration.fast, animations: {
            guard let scorllView = self.scrollView else { return }
            let top = self.scrollViewOriginalInset.top + self.frame.height
            scorllView.contentInset.top = top
            var offset = scorllView.contentOffset
            offset.y = -top
            scorllView.setContentOffset(offset, animated: false)
        }, completion: { _ in
            self.executeRefreshCallback()
        })
    }
}
