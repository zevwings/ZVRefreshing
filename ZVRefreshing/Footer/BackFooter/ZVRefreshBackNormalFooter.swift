//
//  ZRefreshBackStateNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class ZVRefreshBackNormalFooter: ZVRefreshBackStateFooter {
    
    // MARK: - Property
    
    public private(set) var activityIndicator : ZVActivityIndicatorView?
    
    // MARK: didSet
    
    override public var pullingPercent: CGFloat {
        didSet {
            activityIndicator?.progress = pullingPercent
        }
    }
    
    // MARK: - Subviews
    
    override public func prepare() {
        super.prepare()

        if activityIndicator == nil {
            activityIndicator = ZVActivityIndicatorView()
            activityIndicator?.color = .lightGray
            activityIndicator?.hidesWhenStopped = false
            addSubview(activityIndicator!)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        if let activityIndicator = activityIndicator, activityIndicator.constraints.count == 0 {
            
            var activityIndicatorCenterX = frame.width * 0.5
            if let stateLabel = stateLabel, !stateLabel.isHidden {
                activityIndicatorCenterX -= (stateLabel.textWidth * 0.5 + labelInsetLeft)
            }
            
            let activityIndicatorCenterY = frame.height * 0.5
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
            activityIndicator.center = CGPoint(x: activityIndicatorCenterX, y: activityIndicatorCenterY)
        }
    }
    
    // MARK: - Do On State
    
    open override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        if oldState == .refreshing {
            UIView.animate(withDuration: AnimationDuration.fast, animations: {
                self.activityIndicator?.alpha = 0.0
            }, completion: { finished in
                self.activityIndicator?.alpha = 1.0
                self.activityIndicator?.stopAnimating()
            })
        } else {
            activityIndicator?.stopAnimating()
        }
    }

    public override func doOnNoMoreData(with oldState: ZVRefreshComponent.State) {
        super.doOnNoMoreData(with: oldState)

        activityIndicator?.stopAnimating()
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

extension ZVRefreshBackNormalFooter {
    override open var tintColor: UIColor! {
        didSet {
            activityIndicator?.color = tintColor
        }
    }
}

