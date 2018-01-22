//
//  ZRefreshAutoNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZVRefreshAutoNormalFooter: ZVRefreshAutoStateFooter {

    private(set) lazy var activityIndicator : ZVActivityIndicatorView = {
        var activityIndicator = ZVActivityIndicatorView()
        activityIndicator.color = .lightGray
        return activityIndicator
    }()
    
    // MARK: Subviews
    public override func prepare() {
        super.prepare()
        
        if activityIndicator.superview == nil {
            addSubview(activityIndicator)
        }
    }
    
    public override func placeSubViews() {
        super.placeSubViews()
        
        if activityIndicator.constraints.count > 0 { return }
        
        var centerX = frame.size.width * 0.5
        if !stateLabel.isHidden {
            centerX -= (stateLabel.getTextWidth() * 0.5 + labelInsetLeft)
        }
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
        
        let centerY = frame.size.height * 0.5
        activityIndicator.center = CGPoint(x: centerX, y: centerY)
    }

    // MARK: Getter & Setter
    
    public override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            _set(refreshState: newValue)
        }
    }
}

// MARK: - Override

extension ZVRefreshAutoNormalFooter {
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            activityIndicator.color = newValue
        }
    }
}

// MARK: - Private

private extension ZVRefreshAutoNormalFooter {
    
    func _set(refreshState newValue: State) {
        
        guard checkState(newValue).result == false else { return }

        super.refreshState = newValue
        switch newValue {
        case .noMoreData, .idle:
            activityIndicator.stopAnimating()
            break
        case .refreshing:
            activityIndicator.startAnimating()
            break
        default: break
            
        }
    }
}
