//
//  ZRefreshNormalHeader.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/3/30.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class ZVRefreshFlatHeader: ZVRefreshStateHeader {
    
    // MARK: - Property
    
    public private(set) var activityIndicator: ActivityIndicatorView?
    
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
            activityIndicator = ActivityIndicatorView(frame: .init(x: 0, y: 0, width: 24, height: 24))
            activityIndicator?.tintColor = .lightGray
            activityIndicator?.hidesWhenStopped = false
            addSubview(activityIndicator!)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        if let activityIndicator = activityIndicator, activityIndicator.constraints.isEmpty {
            
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
    
    // MARK: - State Update

    public override func refreshStateUpdate(
        _ state: ZVRefreshControl.RefreshState,
        oldState: ZVRefreshControl.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)

        switch state {
        case .idle:
            if refreshState == .refreshing {
                UIView.animate(withDuration: AnimationDuration.slow, animations: {
                    self.activityIndicator?.alpha = 0.0
                }, completion: { _ in
                    guard self.refreshState == .idle else { return }
                    self.activityIndicator?.stopAnimating()
                })
            } else {
                activityIndicator?.stopAnimating()
            }
        case .refreshing:
            activityIndicator?.startAnimating()
        default:
            break
        }
    }
}

// MARK: - System Override

extension ZVRefreshFlatHeader {
    
    override open var tintColor: UIColor! {
        didSet {
            activityIndicator?.tintColor = tintColor
        }
    }
}
