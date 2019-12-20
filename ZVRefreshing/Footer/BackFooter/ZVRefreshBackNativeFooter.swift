//
//  ZVRefreshBackDIYFooter.swift
//  ZVRefreshing
//
//  Created by zevwings on 2017/7/17.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit

public class ZVRefreshBackNativeFooter: ZVRefreshBackStateFooter {
    
    // MARK: - Property
    
    private var arrowView: UIImageView?
    private var activityIndicator: UIActivityIndicatorView?
    
    public var activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray {
        didSet {
            activityIndicator?.style = activityIndicatorViewStyle
            setNeedsLayout()
        }
    }
    
    // MARK: - Subviews
    
    override public func prepare() {
        super.prepare()
        
        self.labelInsetLeft = 24.0
        
        if arrowView == nil {
            arrowView = UIImageView()
            arrowView?.contentMode = .scaleAspectFit
            arrowView?.image = UIImage.arrow
            arrowView?.tintColor = .lightGray
            arrowView?.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
            addSubview(arrowView!)
        }
        
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView()
            activityIndicator?.style = activityIndicatorViewStyle
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.color = .lightGray
            addSubview(activityIndicator!)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        var centerX = frame.width * 0.5
        if let stateLabel = stateLabel, !stateLabel.isHidden {
            let labelWith = stateLabel.textWidth
            let activityIndicatorOffset = (activityIndicator?.frame.width ?? 0.0) * 0.5
            centerX -= (labelWith * 0.5 + labelInsetLeft + activityIndicatorOffset)
        }
        let centerY = frame.height * 0.5
        let center = CGPoint(x: centerX, y: centerY)
        
        if let arrowView = arrowView, arrowView.constraints.isEmpty && arrowView.image != nil {
            arrowView.isHidden = false
            arrowView.frame.size = arrowView.image!.size
            arrowView.center = center
        } else {
            arrowView?.isHidden = true
        }
        
        if let activityIndicator = activityIndicator, activityIndicator.constraints.isEmpty {
            activityIndicator.center = center
        }
    }

    // MARK: - State Update
    
    open override func refreshStateUpdate(
        _ state: ZVRefreshComponent.RefreshState,
        oldState: ZVRefreshComponent.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)
        switch state {
        case .idle:
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
                    self.arrowView?.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi))
                })
            }
        case .pulling:
            arrowView?.isHidden = false
            activityIndicator?.stopAnimating()
            UIView.animate(withDuration: 0.15, animations: {
                self.arrowView?.transform = CGAffineTransform.identity
            })
        case .refreshing:
            arrowView?.isHidden = true
            activityIndicator?.startAnimating()
        case .noMoreData:
            arrowView?.isHidden = true
            activityIndicator?.stopAnimating()
        default:
            break
        }
    }
}
