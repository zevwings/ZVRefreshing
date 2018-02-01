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
    
    public private(set) lazy var activityIndicator : ZVActivityIndicatorView = {
        var activityIndicator = ZVActivityIndicatorView()
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = false
        return activityIndicator
    }()
    
    // MARK: didSet
    
    override public var pullingPercent: CGFloat {
        didSet {
            activityIndicator.progress = pullingPercent
        }
    }
    
    // MARK: - Subviews
    
    override public func prepare() {
        super.prepare()
        
        if activityIndicator.superview == nil {
            addSubview(activityIndicator)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        var centerX = frame.size.width * 0.5
        if !stateLabel.isHidden {
            centerX -= (stateLabel.textWidth * 0.5 + labelInsetLeft)
        }
        
        let centerY = frame.size.height * 0.5
        
        if activityIndicator.constraints.count == 0 {
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
            activityIndicator.center = CGPoint(x: centerX, y: centerY)
        }
    }
    
    // MARK: - Do On
    
    override open func doOn(noMoreData oldState: State) {
        super.doOn(noMoreData: oldState)
        
        activityIndicator.stopAnimating()
    }
    
    override open func doOn(refreshing oldState: State) {
        super.doOn(refreshing: oldState)
        
        activityIndicator.startAnimating()
    }
    
    override open func doOn(pulling oldState: State) {
        super.doOn(pulling: oldState)
        
        activityIndicator.stopAnimating()
    }
    
    override open func doOn(idle oldState: State) {
        super.doOn(idle: oldState)
        
        if oldState == .refreshing {
            UIView.animate(withDuration: AnimationDuration.fast, animations: {
                self.activityIndicator.alpha = 0.0
            }, completion: { finished in
                self.activityIndicator.alpha = 1.0
                self.activityIndicator.stopAnimating()
            })
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - System Override

extension ZVRefreshBackNormalFooter {
    override open var tintColor: UIColor! {
        didSet {
            activityIndicator.color = tintColor
        }
    }
}

