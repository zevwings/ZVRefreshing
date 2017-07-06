//
//  ZRefreshAutoNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshAutoNormalFooter: RefreshAutoStateFooter {

    fileprivate(set) lazy var  activityIndicator : UIActivityIndicatorView = {
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
    
    override var state: RefreshState {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).result { return }
            super.state = newValue
            if newValue == .noMoreData || newValue == .idle {
                self.activityIndicator.stopAnimating()
            } else if newValue == .refreshing {
                self.activityIndicator.startAnimating()
            }
        }
    }
}

extension RefreshAutoNormalFooter {
    
    override func prepare() {
        super.prepare()
        
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
        }
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        if self.activityIndicator.constraints.count > 0 { return }
        
        var loadingCenterX = self.width * 0.5
        if !self.stateLabel.isHidden {
            loadingCenterX -= 100
        }
        let loadingCenterY = self.height * 0.5
        self.activityIndicator.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }
}
