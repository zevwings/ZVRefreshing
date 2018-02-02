//
//  ZVRefreshDIYHeader.swift
//  Example
//
//  Created by zevwings on 2017/7/17.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class ZVRefreshArrowIndicatorHeader: ZVRefreshStateHeader {
    
    // MARK: - Property
    
    private var arrowView: UIImageView?
    
    private var activityIndicator: UIActivityIndicatorView?
    
    // MARK: didSet
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            activityIndicator?.activityIndicatorViewStyle = activityIndicatorViewStyle
            setNeedsLayout()
        }
    }

    // MARK: - Subviews
    
    override func prepare() {
        super.prepare()
        
        if arrowView == nil {
            
            arrowView = UIImageView()
            arrowView?.image = UIImage(named: "arrow.png")

            addSubview(arrowView!)
        }
        
        if activityIndicator == nil {

            activityIndicator = UIActivityIndicatorView()
            activityIndicator?.activityIndicatorViewStyle = activityIndicatorViewStyle
            activityIndicator?.hidesWhenStopped = true

            addSubview(activityIndicator!)
        }
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        
        var centerX = frame.width * 0.5
        if let stateLabel = stateLabel, !stateLabel.isHidden {
            centerX -= 100
        }
        let centerY = frame.height * 0.5
        let center = CGPoint(x: centerX, y: centerY)
        
        if let arrowView = arrowView, arrowView.constraints.count == 0 && arrowView.image != nil {
            arrowView.isHidden = false
            arrowView.frame.size = arrowView.image!.size
            arrowView.center = center
        } else {
            arrowView?.isHidden = true
        }
        
        if let activityIndicator = activityIndicator, activityIndicator.constraints.count == 0 {
            activityIndicator.center = center
        }
    }
    
    // MARK: - Do On State
    
    open override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        if refreshState == .refreshing {
            arrowView?.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.15, animations: {
                self.activityIndicator?.alpha = 0.0
            }, completion: { _ in
                guard self.refreshState == .idle else { return }
                self.activityIndicator?.alpha = 1.0
                self.activityIndicator?.stopAnimating()
                self.arrowView?.isHidden = false
            })
        } else {
            activityIndicator?.stopAnimating()
            arrowView?.isHidden = false
            UIView.animate(withDuration: 0.15, animations: {
                self.arrowView?.transform = CGAffineTransform.identity
            })
        }
    }
    
    override func doOnPulling(with oldState: ZVRefreshComponent.State) {
        super.doOnPulling(with: oldState)
        
        activityIndicator?.stopAnimating()
        arrowView?.isHidden = false
        UIView.animate(withDuration: 0.15, animations: {
            self.arrowView?.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
        })
    }
    
    override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)
        
        activityIndicator?.alpha = 1.0
        activityIndicator?.startAnimating()
        arrowView?.isHidden = true
    }
}

