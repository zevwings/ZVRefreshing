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
    
    // MARK: - Property
    
    private lazy var _arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "arrow.png")
        return arrowView
    }()
    
    private lazy var _activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            _activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            setNeedsLayout()
        }
    }
    
    // MARK: - Subviews
    
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

    // MARK: - Do On State
    
    override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        if oldState == .refreshing {
            _arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
            UIView.animate(withDuration: 0.15, animations: {
                self._activityIndicator.alpha = 0.0
            }, completion: { _ in
                self._activityIndicator.alpha = 1.0
                self._activityIndicator.stopAnimating()
                self._arrowView.isHidden = false
            })
        } else {
            _arrowView.isHidden = false
            _activityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.15, animations: {
                self._arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
            }, completion: { _ in
            })
        }
    }
    
    override func doOnPulling(with oldState: ZVRefreshComponent.State) {
        super.doOnPulling(with: oldState)
        
        _arrowView.isHidden = false
        _activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.15, animations: {
            self._arrowView.transform = CGAffineTransform.identity
        })
    }
    
    override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)
        
        _arrowView.isHidden = true
        _activityIndicator.startAnimating()
    }
    
    override func doOnNoMoreData(with oldState: State) {
        super.doOnNoMoreData(with: oldState)
        
        _arrowView.isHidden = true
        _activityIndicator.stopAnimating()
    }
}
