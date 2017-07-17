//
//  ZVRefreshBackDIYFooter.swift
//  Example
//
//  Created by zevwings on 2017/7/17.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class ZVRefreshBackDIYFooter: ZVRefreshBackStateFooter {
    
    fileprivate lazy var _arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "arrow.png")
        return arrowView
    }()
    
    fileprivate lazy var _activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            self._activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    override var state: State {
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
                    self._arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
                    UIView.animate(withDuration: 0.15, animations: {
                        self._activityIndicator.alpha = 0.0
                    }, completion: { _ in
                        self._activityIndicator.alpha = 1.0
                        self._activityIndicator.stopAnimating()
                        self._arrowView.isHidden = false
                    })
                } else {
                    self._arrowView.isHidden = false
                    self._activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.15, animations: {
                        self._arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
                    }, completion: { _ in
                    })
                }
                break
            case .pulling:
                self._arrowView.isHidden = false
                self._activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.15, animations: {
                    self._arrowView.transform = CGAffineTransform.identity
                })
                break
            case .refreshing:
                self._arrowView.isHidden = true
                self._activityIndicator.startAnimating()
                break
            case .noMoreData:
                self._arrowView.isHidden = true
                self._activityIndicator.stopAnimating()
                break
            default:
                break
            }
        }
    }
}

extension ZVRefreshBackDIYFooter {
    
    override func prepare() {
        super.prepare()
        
        if self._arrowView.superview == nil {
            self.addSubview(self._arrowView)
        }
        
        if self._activityIndicator.superview == nil {
            self.addSubview(self._activityIndicator)
        }
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        
        var arrowCenterX = self.frame.width * 0.5
        if !self.stateLabel.isHidden {
            arrowCenterX -= 100
        }
        let arrowCenterY = self.frame.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if self._arrowView.constraints.count == 0 && self._arrowView.image != nil {
            self._arrowView.isHidden = false
            self._arrowView.frame.size = self._arrowView.image!.size
            self._arrowView.center = arrowCenter
        } else {
            self._arrowView.isHidden = true
        }
        
        if self._activityIndicator.constraints.count == 0 {
            self._activityIndicator.center = arrowCenter
        }
    }
}
