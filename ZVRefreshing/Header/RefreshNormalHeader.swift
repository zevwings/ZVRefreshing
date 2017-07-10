//
//  ZRefreshNormalHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshNormalHeader: RefreshStateHeader {
    
    public fileprivate(set) lazy var arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage.resource(named: "arrow.png")
        return arrowView
    }()
    
    public fileprivate(set) lazy var activityIndicator : UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            self.activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    override public var state: RefreshState {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).result { return }
            super.state = newValue
            
            if newValue == .idle {
                if self.state == .refreshing {
                    self.arrowView.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: Config.AnimationDuration.slow, animations: {
                        self.activityIndicator.alpha = 0.0
                        }, completion: { finished in
                            guard self.state == .idle else { return }
                            self.activityIndicator.alpha = 1.0
                            self.activityIndicator.stopAnimating()
                            self.arrowView.isHidden = false
                    })
                } else {
                    self.activityIndicator.stopAnimating()
                    self.arrowView.isHidden = false
                    UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                        self.arrowView.transform = CGAffineTransform.identity
                    })
                }
            } else if newValue == .pulling {
                self.activityIndicator.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
                })
            } else if newValue == .refreshing {
                self.activityIndicator.alpha = 1.0
                self.activityIndicator.startAnimating()
                self.arrowView.isHidden = true
            }
        }
    }
}

extension RefreshNormalHeader {
    
    override public func prepare() {
        super.prepare()
        
        if self.arrowView.superview == nil {
            self.addSubview(self.arrowView)
        }
        
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        var centerX = self.width * 0.5
        if !self.stateLabel.isHidden {
            let labelWidth = max(self.lastUpdatedTimeLabel.textWidth, self.stateLabel.textWidth)
            centerX -= (labelWidth * 0.5 + self.labelInsetLeft)
        }
        let centerY = self.height * 0.5
        let center = CGPoint(x: centerX, y: centerY)
        
        if self.arrowView.constraints.count == 0 && self.arrowView.image != nil {
            self.arrowView.isHidden = false
            self.arrowView.size = self.arrowView.image!.size
            self.arrowView.center = center
        } else {
            self.arrowView.isHidden = true
        }
        
        if self.activityIndicator.constraints.count == 0 {
            self.activityIndicator.center = center
        }
    }
}
