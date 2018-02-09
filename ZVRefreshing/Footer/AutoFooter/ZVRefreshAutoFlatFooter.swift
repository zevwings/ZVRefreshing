//
//  ZRefreshAutoNormalFooter.swift
//
//  Created by zevwings on 16/3/31.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class ZVRefreshAutoFlatFooter: ZVRefreshAutoStateFooter {

    // MARK: - Property
    
    public private(set) var activityIndicator : ZVActivityIndicatorView?
    
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
        
        activityIndicator?.stopAnimating()
    }

    override open func doOnNoMoreData(with oldState: State) {
        super.doOnNoMoreData(with: oldState)
        
        activityIndicator?.stopAnimating()
    }
    
    override open func doOnRefreshing(with oldState: State) {
        super.doOnRefreshing(with: oldState)
        
        activityIndicator?.startAnimating()
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

