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
    
    public private(set) lazy var activityIndicator: ZVActivityIndicatorView = {
        let activityIndicator = ZVActivityIndicatorView()
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = false
        return activityIndicator
    }()
    
    // MARK: didSet
    
    override open var pullingPercent: CGFloat {
        didSet {
            activityIndicator.progress = pullingPercent
        }
    }
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()
        
        if activityIndicator.superview == nil {
            addSubview(activityIndicator)
        }
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        var centerX = frame.size.width * 0.5
        
        if !stateLabel.isHidden {
            var labelWidth: CGFloat = 0.0
            if lastUpdatedTimeLabel.isHidden {
                labelWidth = stateLabel.textWidth
            } else {
                labelWidth = max(lastUpdatedTimeLabel.textWidth, stateLabel.textWidth)
            }
            centerX -= (labelWidth * 0.5 + labelInsetLeft)
        }
        
        let centerY = frame.size.height * 0.5
        let center = CGPoint(x: centerX, y: centerY)
        
        if activityIndicator.constraints.count == 0 {
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
            activityIndicator.center = center
        }
    }
    
    // MARK: - Do On
    
    override open func doOn(idle oldState: State) {
        super.doOn(idle: oldState)
        
        if refreshState == .refreshing {
            UIView.animate(withDuration: AnimationDuration.slow, animations: {
                self.activityIndicator.alpha = 0.0
            }, completion: { finished in
                guard self.refreshState == .idle else { return }
                self.activityIndicator.stopAnimating()
            })
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    override open func doOn(pulling oldState: State) {
        super.doOn(pulling: oldState)
        
        activityIndicator.stopAnimating()
    }
    
    override open func doOn(refreshing oldState: State) {
        super.doOn(refreshing: oldState)
        
        activityIndicator.startAnimating()
    }
}

// MARK: - System Override

extension ZVRefreshNormalHeader {
    
    override open var tintColor: UIColor! {
        didSet {
            super.tintColor = tintColor
            activityIndicator.color = tintColor
        }
    }
}
