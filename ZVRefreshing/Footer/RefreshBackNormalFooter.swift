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
            let checked = self.checkState(newValue)
            guard checked.result == false else { return }
            super.state = newValue
            
            switch newValue {
            case .idle:
                if checked.oldState == .refreshing {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
                    UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                        self.activityIndicator.alpha = 0.0
                    }, completion: { finished in
                        self.activityIndicator.alpha = 1.0
                        self.activityIndicator.stopAnimating()
                        self.arrowView.isHidden = false
                    })
                } else {
                    self.arrowView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                        self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
                    }, completion: { finished in
                    })
                }
                break
            case .pulling:
                self.arrowView.isHidden = false
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
                    self.arrowView.transform = CGAffineTransform.identity
                })
                break
            case .refreshing:
                self.arrowView.isHidden = true
                self.activityIndicator.startAnimating()
                break
            case .noMoreData:
                self.arrowView.isHidden = true
                self.activityIndicator.stopAnimating()
                break
            default:
                break
            }
        }
    }
}

extension RefreshBackNormalFooter {
    
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
        
        var arrowCenterX = self.width * 0.5
        if !self.stateLabel.isHidden {
            arrowCenterX -= 100
        }
        let arrowCenterY = self.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if self.arrowView.constraints.count == 0 && self.arrowView.image != nil {
            self.arrowView.isHidden = false
            self.arrowView.size = self.arrowView.image!.size
            self.arrowView.center = arrowCenter
        } else {
            self.arrowView.isHidden = true
        }
        
        if self.activityIndicator.constraints.count == 0 {
            self.activityIndicator.center = arrowCenter
        }
    }
}
