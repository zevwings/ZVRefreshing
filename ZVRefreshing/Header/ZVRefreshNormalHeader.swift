//
//  ZRefreshNormalHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshNormalHeader: ZVRefreshStateHeader {
    
    public fileprivate(set) lazy var activityIndicator: ZVActivityIndicatorView = {
        let indicator = ZVActivityIndicatorView()
        indicator.color = .lightGray
        return indicator
    }()
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            self.activityIndicator.color = newValue
        }
    }
    
    override open var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            if self.checkState(newValue).result { return }
            super.refreshState = newValue
            
            if newValue == .idle {
                if self.refreshState == .refreshing {
                    UIView.animate(withDuration: Config.AnimationDuration.slow, animations: {
                        }, completion: { finished in
                            guard self.refreshState == .idle else { return }
                            self.activityIndicator.stopAnimating()
                    })
                } else {
                    self.activityIndicator.stopAnimating()
                }
            } else if newValue == .pulling {
                self.activityIndicator.stopAnimating()
            } else if newValue == .refreshing {
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    override open var pullingPercent: CGFloat {
        get {
            return super.pullingPercent
        }
        set {
            super.pullingPercent = newValue
            self.activityIndicator.percent = newValue
        }
    }
}

extension ZVRefreshNormalHeader {
    
    override open func prepare() {
        super.prepare()
        
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
        }
    }

    open override func placeSubViews() {
        super.placeSubViews()
        
        var centerX = self.width * 0.5
        if !self.stateLabel.isHidden {
            var labelWidth: CGFloat = 0.0
            if self.lastUpdatedTimeLabel.isHidden {
                labelWidth = self.stateLabel.textWidth
            } else {
                labelWidth = max(self.lastUpdatedTimeLabel.textWidth, self.stateLabel.textWidth)
            }
            centerX -= (labelWidth * 0.5 + self.labelInsetLeft)
        }

        let centerY = self.height * 0.5
        let center = CGPoint(x: centerX, y: centerY)

        if self.activityIndicator.constraints.count == 0 {
            
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
            self.activityIndicator.center = center
        }
    }
}
