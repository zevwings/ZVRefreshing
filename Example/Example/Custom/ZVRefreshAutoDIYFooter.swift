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
    
    // MARK: - Property
    
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
    
    // MARK: - Subviews
    
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
        if let stateLabel = stateLabel, !stateLabel.isHidden {
            loadingCenterX -= 100
        }
        let loadingCenterY = self.frame.height * 0.5
        self._activityIndicator.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }

    // MARK: - Do On State
    
    override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        _activityIndicator.stopAnimating()
    }
    
    override func doOnNoMoreData(with oldState: State) {
        super.doOnNoMoreData(with: oldState)
        
        _activityIndicator.stopAnimating()
    }
    
    override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)
        _activityIndicator.startAnimating()
    }
    

}

extension ZVRefreshAutoDIYFooter {
    
}
