//
//  ZRefreshAutoStateFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAutoStateFooter: ZVRefreshAutoFooter {
    
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
            if self.checkState(newValue).0 { return }
            super.state = newValue
            
            if self.stateLabel.isHidden && newValue == .refreshing {
                self.stateLabel.text = nil
            } else {
                self.stateLabel.text = self._stateTitles[newValue]
            }
        }
    }
}

extension ZVRefreshAutoStateFooter {
    
    public func setTitle(_ title: String?, forState state: State) {
        if title == nil {return}
        self._stateTitles.updateValue(title!, forKey: state)
        self.stateLabel.text = self._stateTitles[self.state]
    }
}

extension ZVRefreshAutoStateFooter {
    
    override open func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
                
        self.setTitle(localized(string: Constants.Footer.Auto.idle) , forState: .idle)
        self.setTitle(localized(string: Constants.Footer.Auto.refreshing), forState: .refreshing)
        self.setTitle(localized(string: Constants.Footer.Auto.noMoreData), forState: .noMoreData)
        
        self.stateLabel.isUserInteractionEnabled = true
        self.stateLabel.addGestureRecognizer(.init(target: self, action: #selector(ZVRefreshAutoStateFooter.stateLabelClicked)))
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if self.stateLabel.constraints.count > 0 { return }
        self.stateLabel.frame = self.bounds
    }
    
    internal func stateLabelClicked() {
        if self.state == .idle { self.beginRefreshing() }
    }
}
