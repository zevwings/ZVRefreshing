//
//  ZRefreshBackStateFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class RefreshBackStateFooter: RefreshBackFooter {
    
    public fileprivate(set) lazy var stateLabel: UILabel = RefreshingLabel()
    fileprivate var stateTitles:[RefreshState: String] = [:]
    
    override open var state: RefreshState {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).result { return }
            super.state = newValue
            self.stateLabel.text = self.stateTitles[newValue]
        }
    }
}

extension RefreshBackStateFooter {
    
    public func setTitle(_ title: String, forState state: RefreshState) {
        self.stateTitles.updateValue(title, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }
}

extension RefreshBackStateFooter {
    
    override open func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        self.setTitle(Constants.Footer.Back.idle, forState: .idle)
        self.setTitle(Constants.Footer.Back.pulling, forState: .pulling)
        self.setTitle(Constants.Footer.Back.refreshing, forState: .refreshing)
        self.setTitle(Constants.Footer.Back.noMoreData, forState: .noMoreData)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        if self.stateLabel.constraints.count > 0 { return }
        self.stateLabel.frame = self.bounds
    }
}
