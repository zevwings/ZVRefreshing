//
//  ZRefreshBackStateNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZVRefreshBackNormalFooter: ZVRefreshBackStateFooter {
    
    public fileprivate(set) lazy var activityIndicator : ZVActivityIndicatorView = {
        var activityIndicator = ZVActivityIndicatorView()
        activityIndicator.color = .lightGray
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
            let checked = self.checkState(newValue)
            guard checked.result == false else { return }
            super.state = newValue
            
            switch newValue {
            case .idle:
                if checked.oldState == .refreshing {
                    UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                        self.activityIndicator.alpha = 0.0
                    }, completion: { finished in
                        self.activityIndicator.alpha = 1.0
                        self.activityIndicator.stopAnimating()
                    })
                } else {
                    self.activityIndicator.stopAnimating()
                }
                break
            case .pulling:
                self.activityIndicator.stopAnimating()
                break
            case .refreshing:
                self.activityIndicator.startAnimating()
                break
            case .noMoreData:
                self.activityIndicator.stopAnimating()
                break
            default:
                break
            }
        }
    }
    
    override public var pullingPercent: CGFloat {
        get {
            return super.pullingPercent
        }
        set {
            super.pullingPercent = newValue
            self.activityIndicator.percent = newValue
        }
    }
}

extension ZVRefreshBackNormalFooter {
    
    override public func prepare() {
        super.prepare()
        
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        var centerX = self.width * 0.5
        if !self.stateLabel.isHidden {
            centerX -= (self.stateLabel.textWidth * 0.5 + self.labelInsetLeft)
        }
        
        let centerY = self.height * 0.5

        if self.activityIndicator.constraints.count == 0 {
            
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
            self.activityIndicator.center = CGPoint(x: centerX, y: centerY)
        }
    }
}
