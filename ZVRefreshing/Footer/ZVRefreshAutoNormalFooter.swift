//
//  ZRefreshAutoNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZVRefreshAutoNormalFooter: ZVRefreshAutoStateFooter {

    fileprivate(set) lazy var  activityIndicator : ZVActivityIndicatorView = {
        var activityIndicator = ZVActivityIndicatorView()
        activityIndicator.color = UIColor.lightGray
        return activityIndicator
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
    
    override public var state: State {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).result { return }
            super.state = newValue
            if newValue == .noMoreData || newValue == .idle {
                self.activityIndicator.stopAnimating()
            } else if newValue == .refreshing {
                self.activityIndicator.startAnimating()
            }
        }
    }
}

extension ZVRefreshAutoNormalFooter {
    
    override public func prepare() {
        super.prepare()
        
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        if self.activityIndicator.constraints.count > 0 { return }
        
        var centerX = self.width * 0.5
        if !self.stateLabel.isHidden {
            centerX -= (self.stateLabel.textWidth * 0.5 + self.labelInsetLeft)
        }
        
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)

        let centerY = self.height * 0.5
        self.activityIndicator.center = CGPoint(x: centerX, y: centerY)
    }
}
