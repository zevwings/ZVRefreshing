//
//  ZRefreshBackStateFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshBackStateFooter: ZVRefreshBackFooter {
    
    public fileprivate(set) lazy var stateLabel: UILabel = ZVRefreshingLabel()
    public var labelInsetLeft: CGFloat = 24.0
    fileprivate var _stateTitles:[State: String] = [:]
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            self.stateLabel.textColor = newValue
        }
    }
    
    override open var state: State {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).result { return }
            super.state = newValue
            self.stateLabel.text = self._stateTitles[newValue]
        }
    }
    
}

extension ZVRefreshBackStateFooter {
    
    public func setTitle(_ title: String, forState state: State) {
        self._stateTitles.updateValue(title, forKey: state)
        self.stateLabel.text = self._stateTitles[self.state]
    }
}

extension ZVRefreshBackStateFooter {
    
    override open func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        self.setTitle(localized(string: Constants.Footer.Back.idle), forState: .idle)
        self.setTitle(localized(string: Constants.Footer.Back.pulling), forState: .pulling)
        self.setTitle(localized(string: Constants.Footer.Back.refreshing), forState: .refreshing)
        self.setTitle(localized(string: Constants.Footer.Back.noMoreData), forState: .noMoreData)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        if self.stateLabel.constraints.count > 0 { return }
        self.stateLabel.frame = self.bounds
    }
}
