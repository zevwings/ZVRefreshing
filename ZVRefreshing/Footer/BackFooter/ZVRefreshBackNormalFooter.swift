//
//  ZRefreshBackStateNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class ZVRefreshBackNormalFooter: ZVRefreshBackStateFooter {
    
    public private(set) lazy var activityIndicator : ZVActivityIndicatorView = {
        var activityIndicator = ZVActivityIndicatorView()
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = false
        return activityIndicator
    }()
    
    // MARK: Subviews
    
    override public func prepare() {
        super.prepare()
        
        if activityIndicator.superview == nil {
            addSubview(activityIndicator)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        var centerX = frame.size.width * 0.5
        if !stateLabel.isHidden {
            centerX -= (stateLabel.textWidth * 0.5 + labelInsetLeft)
        }
        
        let centerY = frame.size.height * 0.5
        
        if activityIndicator.constraints.count == 0 {
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
            activityIndicator.center = CGPoint(x: centerX, y: centerY)
        }
    }

    // MARK: Getter & Setter
    
    override public var pullingPercent: CGFloat {
        didSet {
            activityIndicator.progress = pullingPercent
        }
    }
    
    open override func update(refreshState newValue: State) {
        let checked = checkState(newValue)
        guard checked.result == false else { return }
        super.update(refreshState: newValue)
        
        switch newValue {
        case .idle:
            if checked.oldState == .refreshing {
                UIView.animate(withDuration: AnimationDuration.fast, animations: {
                    self.activityIndicator.alpha = 0.0
                }, completion: { finished in
                    self.activityIndicator.alpha = 1.0
                    self.activityIndicator.stopAnimating()
                })
            } else {
                activityIndicator.stopAnimating()
            }
            break
        case .pulling:
            activityIndicator.stopAnimating()
            break
        case .refreshing:
            activityIndicator.startAnimating()
            break
        case .noMoreData:
            activityIndicator.stopAnimating()
            break
        default:
            break
        }
    }
}

// MARK: - Override

extension ZVRefreshBackNormalFooter {
    override open var tintColor: UIColor! {
        didSet {
            activityIndicator.color = tintColor
        }
    }
}

