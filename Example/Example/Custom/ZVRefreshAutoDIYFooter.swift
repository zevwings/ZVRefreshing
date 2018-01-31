//
//  ZVRefreshAutoDIYFooter.swift
//  Example
//
//  Created by zevwings on 2017/7/17.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class ZVRefreshAutoDIYFooter: ZVRefreshAutoStateFooter {
    
    private lazy var _activityIndicator: UIActivityIndicatorView = {
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
    
    override func update(refreshState newValue: ZVRefreshComponent.State) {
        guard checkState(newValue).result == false else { return }
        super.update(refreshState: newValue)
        
        if newValue == .noMoreData || newValue == .idle {
            self._activityIndicator.stopAnimating()
        } else if newValue == .refreshing {
            self._activityIndicator.startAnimating()
        }
    }
    
    override func prepare() {
        super.prepare()
        
        if self._activityIndicator.superview == nil {
            self.addSubview(self._activityIndicator)
        }
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        if self._activityIndicator.constraints.count > 0 { return }
        
        var loadingCenterX = self.frame.width * 0.5
        if !self.stateLabel.isHidden {
            loadingCenterX -= 100
        }
        let loadingCenterY = self.frame.height * 0.5
        self._activityIndicator.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }

}

extension ZVRefreshAutoDIYFooter {
    
}
