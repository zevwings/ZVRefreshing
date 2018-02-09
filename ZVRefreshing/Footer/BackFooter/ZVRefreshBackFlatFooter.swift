//
//  ZRefreshBackStateNormalFooter.swift
//
//  Created by zevwings on 16/4/1.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class ZVRefreshBackFlatFooter: ZVRefreshBackStateFooter {
    
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
            activityIndicator = ZVActivityIndicatorView(frame: .init(x: 0, y: 0, width: 24, height: 24))
            activityIndicator?.tintColor = .lightGray
            activityIndicator?.hidesWhenStopped = false
            addSubview(activityIndicator!)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        if let activityIndicator = activityIndicator, activityIndicator.constraints.count == 0 {
            
            var activityIndicatorCenterX = frame.width * 0.5
            if let stateLabel = stateLabel, !stateLabel.isHidden {
                activityIndicatorCenterX -= (stateLabel.textWidth * 0.5 + labelInsetLeft + activityIndicator.frame.width * 0.5)
            }
            
            let activityIndicatorCenterY = frame.height * 0.5
            activityIndicator.center = CGPoint(x: activityIndicatorCenterX, y: activityIndicatorCenterY)
        }
    }
    
    // MARK: - Do On State
    
    override open func doOnIdle(with oldState: State) {
        super.doOnIdle(with: oldState)
        
        if oldState == .refreshing {
            UIView.animate(withDuration: AnimationDuration.fast, animations: {
                self.activityIndicator?.alpha = 0.0
            }, completion: { _ in
                self.activityIndicator?.alpha = 1.0
                self.activityIndicator?.stopAnimating()
            })
        } else {
            activityIndicator?.stopAnimating()
        }
    }

    override public func doOnNoMoreData(with oldState: State) {
        super.doOnNoMoreData(with: oldState)

        activityIndicator?.stopAnimating()
    }
    
    override open func doOnRefreshing(with oldState: State) {
        super.doOnRefreshing(with: oldState)
        
        activityIndicator?.startAnimating()
    }
}

// MARK: - System Override

extension ZVRefreshBackFlatFooter {
    override open var tintColor: UIColor! {
        didSet {
            activityIndicator?.tintColor = tintColor
        }
    }
}

