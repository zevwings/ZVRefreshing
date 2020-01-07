//
//  ZRefreshAutoNormalFooter.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/3/31.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class ZVRefreshAutoFlatFooter: ZVRefreshAutoStateFooter {

    // MARK: - Property
    
    public private(set) var activityIndicator : ActivityIndicatorView?
    
    // MARK: - Subviews
    
    override public func prepare() {
        super.prepare()
        
        if activityIndicator == nil {
            activityIndicator = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
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
                let leftPadding = stateLabel.textWidth * 0.5 +
                    labelInsetLeft +
                    activityIndicator.frame.width * 0.5
                activityIndicatorCenterX -= leftPadding
            }
            
            let activityIndicatorCenterY = frame.height * 0.5
            activityIndicator.center = CGPoint(x: activityIndicatorCenterX, y: activityIndicatorCenterY)
        }
    }
    
    // MARK: - State Update

    open override func refreshStateUpdate(
        _ state: ZVRefreshControl.RefreshState,
        oldState: ZVRefreshControl.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)

        switch state {
        case .idle, .noMoreData:
            activityIndicator?.stopAnimating()
        case .refreshing:
            activityIndicator?.startAnimating()
        default:
            break
        }
    }
}

// MARK: - Override

extension ZVRefreshAutoFlatFooter {
    
    override public var tintColor: UIColor! {
        didSet {
            activityIndicator?.tintColor = tintColor
        }
    }
}
