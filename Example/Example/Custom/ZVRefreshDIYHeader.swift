//
//  ZVRefreshDIYHeader.swift
//  Example
//
//  Created by zevwings on 2017/7/17.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class ZVRefreshDIYHeader: ZVRefreshStateHeader {
    
    // MARK: - Property
    
    private lazy var _arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "arrow.png")
        return arrowView
    }()
    
    private lazy var _activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = activityIndicatorViewStyle
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: getter & setter
    
//    open override var refreshState: State {
//        get {
//            return super.refreshState
//        }
//        set {
//            guard checkState(newValue).isIdenticalState == false else { return }
//            super.refreshState = newValue
//        }
//    }
    
    // MARK: didSet
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            _activityIndicator.activityIndicatorViewStyle = activityIndicatorViewStyle
            setNeedsLayout()
        }
    }
    
    // MARK: - Do On State
    
    open override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        if refreshState == .refreshing {
            _arrowView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.15, animations: {
                self._activityIndicator.alpha = 0.0
            }, completion: { _ in
                guard self.refreshState == .idle else { return }
                self._activityIndicator.alpha = 1.0
                self._activityIndicator.stopAnimating()
                self._arrowView.isHidden = false
            })
        } else {
            _activityIndicator.stopAnimating()
            _arrowView.isHidden = false
            UIView.animate(withDuration: 0.15, animations: {
                self._arrowView.transform = CGAffineTransform.identity
            })
        }
    }

    override func doOnPulling(with oldState: ZVRefreshComponent.State) {
        super.doOnPulling(with: oldState)
        
        _activityIndicator.stopAnimating()
        _arrowView.isHidden = false
        UIView.animate(withDuration: 0.15, animations: {
            self._arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
        })
    }
    
    override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)

        _activityIndicator.alpha = 1.0
        _activityIndicator.startAnimating()
        _arrowView.isHidden = true

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
        
        var centerX = self.frame.width * 0.5
        if !self.stateLabel.isHidden {
            centerX -= 100
        }
        let centerY = self.frame.height * 0.5
        let center = CGPoint(x: centerX, y: centerY)
        
        if self._arrowView.constraints.count == 0 && self._arrowView.image != nil {
            self._arrowView.isHidden = false
            self._arrowView.frame.size = self._arrowView.image!.size
            self._arrowView.center = center
        } else {
            self._arrowView.isHidden = true
        }
        
        if self._activityIndicator.constraints.count == 0 {
            self._activityIndicator.center = center
        }
    }
}

