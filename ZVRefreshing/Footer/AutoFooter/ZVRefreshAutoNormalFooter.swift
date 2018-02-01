//
//  ZRefreshAutoNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class ZVRefreshAutoNormalFooter: ZVRefreshAutoStateFooter {

    // MARK: - Property
    
    public private(set) lazy var activityIndicator : ZVActivityIndicatorView = {
        var activityIndicator = ZVActivityIndicatorView()
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = false
        return activityIndicator
    }()
    
    // MARK: - Subviews
    
    override public func prepare() {
        super.prepare()
        
        if activityIndicator.superview == nil {
            addSubview(activityIndicator)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        if activityIndicator.constraints.count > 0 { return }
        
        var centerX = frame.size.width * 0.5
        if !stateLabel.isHidden {
            centerX -= (stateLabel.textWidth * 0.5 + labelInsetLeft)
        }
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
        
        let centerY = frame.size.height * 0.5
        activityIndicator.center = CGPoint(x: centerX, y: centerY)
    }
    
    // MARK: - Do On State
    
    open override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)
        
        activityIndicator.startAnimating()
    }
    
    open override func doOnNoMoreData(with oldState: ZVRefreshComponent.State) {
        super.doOnNoMoreData(with: oldState)
        
        activityIndicator.stopAnimating()
    }
    
    open override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        activityIndicator.stopAnimating()
    }
}

// MARK: - Override

extension ZVRefreshAutoNormalFooter {
    
    override open var tintColor: UIColor! {
        didSet {
            activityIndicator.color = tintColor
        }
    }
}

