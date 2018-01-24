//
//  ZRefreshNormalHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

open class ZVRefreshNormalHeader: ZVRefreshStateHeader {
    
    public private(set) lazy var activityIndicator: ZVActivityIndicatorView = {
        let activityIndicator = ZVActivityIndicatorView()
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = false
        return activityIndicator
    }()
    
    // MARK: Subviews
    
    open override func prepare() {
        super.prepare()
        
        if activityIndicator.superview == nil {
            addSubview(activityIndicator)
        }
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        
        var centerX = frame.size.width * 0.5
        
        if !stateLabel.isHidden {
            var labelWidth: CGFloat = 0.0
            if lastUpdatedTimeLabel.isHidden {
                labelWidth = stateLabel.textWidth
            } else {
                labelWidth = max(lastUpdatedTimeLabel.textWidth, stateLabel.textWidth)
            }
            centerX -= (labelWidth * 0.5 + labelInsetLeft)
        }
        
        let centerY = frame.size.height * 0.5
        let center = CGPoint(x: centerX, y: centerY)
        
        if activityIndicator.constraints.count == 0 {
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
            activityIndicator.center = center
        }
    }

    // MARK: Getter & Setter
    
    open override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            setRefreshState(newValue)
        }
    }
    
    open override var pullingPercent: CGFloat {
        didSet {
            activityIndicator.progress = pullingPercent
        }
    }
}

// MARK: - Override

extension ZVRefreshNormalHeader {
    
    open override var tintColor: UIColor! {
        didSet {
            super.tintColor = tintColor
            activityIndicator.color = tintColor
        }
    }
}

// MARK: - Private

private extension ZVRefreshNormalHeader {
    
    func setRefreshState(_ newValue: State) {
        
        guard checkState(newValue).result == false else { return }
        super.refreshState = newValue
        
        if newValue == .idle {
            if refreshState == .refreshing {
                UIView.animate(withDuration: AnimationDuration.slow, animations: {
                    self.activityIndicator.alpha = 0.0
                }, completion: { finished in
                    guard self.refreshState == .idle else { return }
                    self.activityIndicator.stopAnimating()
                })
            } else {
                activityIndicator.stopAnimating()
            }
        } else if newValue == .pulling {
            activityIndicator.stopAnimating()
        } else if newValue == .refreshing {
            activityIndicator.startAnimating()
        }
    }
}
