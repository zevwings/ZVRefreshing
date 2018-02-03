//
//  ZVRefreshBackDIYFooter.swift
//  Example
//
//  Created by zevwings on 2017/7/17.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class ZVRefreshBackArrowIndicatorFooter: ZVRefreshBackStateFooter {
    
    // MARK: - Property
    
    private var arrowView: UIImageView?
    
    private var activityIndicator: UIActivityIndicatorView?
    
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
            arrowView?.tintColor = .green
            arrowView?.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
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
        
        var arrowCenterX = frame.width * 0.5
        if let stateLabel = stateLabel, !stateLabel.isHidden {
            arrowCenterX -= 100
        }
        let arrowCenterY = frame.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if let arrowView = arrowView, arrowView.constraints.count == 0, arrowView.image != nil {
            arrowView.isHidden = false
            arrowView.frame.size = arrowView.image!.size
            arrowView.center = arrowCenter
        } else {
            arrowView?.isHidden = true
        }
        
        if activityIndicator?.constraints.count == 0 {
            activityIndicator?.center = arrowCenter
        }
    }

    // MARK: - Do On State
    
    override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        if oldState == .refreshing {
            arrowView?.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
            UIView.animate(withDuration: 0.15, animations: {
                self.activityIndicator?.alpha = 0.0
            }, completion: { _ in
                self.activityIndicator?.alpha = 1.0
                self.activityIndicator?.stopAnimating()
                self.arrowView?.isHidden = false
            })
        } else {
            arrowView?.isHidden = false
            activityIndicator?.stopAnimating()
            UIView.animate(withDuration: 0.15, animations: {
                self.arrowView?.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
            })
        }
    }
    
    override func doOnPulling(with oldState: ZVRefreshComponent.State) {
        super.doOnPulling(with: oldState)
        
        arrowView?.isHidden = false
        activityIndicator?.stopAnimating()
        UIView.animate(withDuration: 0.15, animations: {
            self.arrowView?.transform = CGAffineTransform.identity
        })
    }
    
    override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)
        
        arrowView?.isHidden = true
        activityIndicator?.startAnimating()
    }
    
    override func doOnNoMoreData(with oldState: State) {
        super.doOnNoMoreData(with: oldState)
        
        arrowView?.isHidden = true
        activityIndicator?.stopAnimating()
    }
}
