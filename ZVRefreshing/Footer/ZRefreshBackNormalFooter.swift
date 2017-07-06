//
//  ZRefreshBackStateNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshBackNormalFooter: RefreshBackStateFooter {
    
    fileprivate(set) lazy var arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage.resource(named: "arrow.png")
        return arrowView
    }()
    
    fileprivate lazy var activityIndicator : UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    open var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            self.activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    override var state: RefreshState {
        get {
            return super.state
        }
        set {
            let result = self.checkState(newValue)
            if result.0 { return }
            super.state = newValue
            
            if newValue == .idle {
                if result.1 == .refreshing {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
                    UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                        self.activityIndicator.alpha = 0.0
                        }, completion: { (flag) in
                            self.activityIndicator.alpha = 1.0
                            self.activityIndicator.stopAnimating()
                            self.arrowView.isHidden = false
                    })
                } else {
                    self.arrowView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                        self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
                        }, completion: { (flag) in
                    })
                }
            } else if newValue == .pulling {
                self.arrowView.isHidden = false
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                    self.arrowView.transform = CGAffineTransform.identity
                })
            } else if newValue == .refreshing {
                self.arrowView.isHidden = true
                self.activityIndicator.startAnimating()
            } else if newValue == .noMoreData {
                self.arrowView.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Override
    override open func prepare() {
        super.prepare()
        
        if self.arrowView.superview == nil {
            self.addSubview(self.arrowView)
        }
        
        self.activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        self.activityIndicator.hidesWhenStopped = true
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
        }
    }
    
    override open func placeSubViews() {
        super.placeSubViews()

        var arrowCenterX = self.frame.width * 0.5
        if (!self.stateLabel.isHidden) {
            arrowCenterX -= 100
        }
        let arrowCenterY = self.frame.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if (self.arrowView.constraints.count == 0 && self.arrowView.image != nil) {
            self.arrowView.isHidden = false
            var rect = self.arrowView.frame
            rect.size = self.arrowView.image!.size
            self.arrowView.frame = rect
            self.arrowView.center = arrowCenter
        } else {
            self.arrowView.isHidden = true
        }
        
        if (self.activityIndicator.constraints.count == 0) {
            self.activityIndicator.center = arrowCenter;
        }
    }
}
