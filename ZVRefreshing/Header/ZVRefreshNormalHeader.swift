//
//  ZRefreshNormalHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

open class ZVRefreshNormalHeader: ZVRefreshStateHeader {
    
    // MARK: - Property
    
    public private(set) var activityIndicator: ZVActivityIndicatorView?
    
    // MARK: didSet
    
    override open var pullingPercent: CGFloat {
        didSet {
            activityIndicator?.progress = pullingPercent
        }
    }
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()
        
        if activityIndicator == nil {
            activityIndicator = ZVActivityIndicatorView(frame: .init(x: 0, y: 0, width: 24, height: 24))
            activityIndicator?.color = .lightGray
            activityIndicator?.hidesWhenStopped = false
            addSubview(activityIndicator!)
        }
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if let activityIndicator = activityIndicator, activityIndicator.constraints.count == 0 {
            
            var activityIndicatorCenterX = frame.width * 0.5
            if let stateLabel = stateLabel, !stateLabel.isHidden {
                var maxLabelWidth: CGFloat = 0.0
                if let lastUpdatedTimeLabel = lastUpdatedTimeLabel, !lastUpdatedTimeLabel.isHidden {
                    maxLabelWidth = max(lastUpdatedTimeLabel.textWidth, stateLabel.textWidth)
                } else {
                    maxLabelWidth = stateLabel.textWidth
                }
                activityIndicatorCenterX -= (maxLabelWidth * 0.5 + labelInsetLeft + activityIndicator.frame.width * 0.5)
            }
            
            let activityIndicatorCenterY = frame.height * 0.5
            let activityIndicatorCenter = CGPoint(x: activityIndicatorCenterX, y: activityIndicatorCenterY)
            activityIndicator.center = activityIndicatorCenter
        }
    }
    
    // MARK: - Do On State
    
    open override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        if refreshState == .refreshing {
            UIView.animate(withDuration: AnimationDuration.slow, animations: {
                self.activityIndicator?.alpha = 0.0
            }, completion: { isFinished in
                guard self.refreshState == .idle else { return }
                self.activityIndicator?.stopAnimating()
            })
        } else {
            activityIndicator?.stopAnimating()
        }
    }
    
    open override func doOnPulling(with oldState: ZVRefreshComponent.State) {
        super.doOnPulling(with: oldState)
        activityIndicator?.stopAnimating()
    }
    
    open override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)
        activityIndicator?.startAnimating()
    }
}

// MARK: - System Override

extension ZVRefreshNormalHeader {
    
    override open var tintColor: UIColor! {
        didSet {
            activityIndicator?.color = tintColor
        }
    }
}
