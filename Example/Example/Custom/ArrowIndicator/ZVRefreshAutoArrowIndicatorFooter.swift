//
//  ZVRefreshAutoDIYFooter.swift
//  Example
//
//  Created by zevwings on 2017/7/17.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class ZVRefreshAutoArrowIndicatorFooter: ZVRefreshAutoStateFooter {
    
    // MARK: - Property
    
    private var activityIndicator: UIActivityIndicatorView?
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            activityIndicator?.activityIndicatorViewStyle = activityIndicatorViewStyle
        }
    }
    
    // MARK: - Subviews
    
    override func prepare() {
        super.prepare()
        
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView()
            activityIndicator?.activityIndicatorViewStyle = activityIndicatorViewStyle
            activityIndicator?.hidesWhenStopped = true
            addSubview(activityIndicator!)
        }
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        
        guard let activityIndicator = activityIndicator, activityIndicator.constraints.count == 0 else { return }
        
        var loadingCenterX = frame.width * 0.5
        if let stateLabel = stateLabel, !stateLabel.isHidden {
            loadingCenterX -= 100
        }
        let loadingCenterY = frame.height * 0.5
        activityIndicator.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }

    // MARK: - Do On State
    
    override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        activityIndicator?.stopAnimating()
    }
    
    override func doOnNoMoreData(with oldState: State) {
        super.doOnNoMoreData(with: oldState)
        
        activityIndicator?.stopAnimating()
    }
    
    override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)
        
        activityIndicator?.startAnimating()
    }
}

