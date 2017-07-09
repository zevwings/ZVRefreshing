//
//  ZRefreshAutoStateFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class RefreshAutoStateFooter: RefreshAutoFooter {
    
    public fileprivate(set) lazy var stateLabel: UILabel = RefreshingLabel()
    fileprivate var stateTitles:[RefreshState: String] = [:]
    
    override open var state: RefreshState {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).0 { return }
            super.state = newValue
            
            if self.stateLabel.isHidden && newValue == .refreshing {
                self.stateLabel.text = nil
            } else {
                self.stateLabel.text = self.stateTitles[newValue]
            }
        }
    }
}

extension RefreshAutoStateFooter {
    
    public func setTitle(_ title: String?, forState state: RefreshState) {
        if title == nil {return}
        self.stateTitles.updateValue(title!, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }
}

extension RefreshAutoStateFooter {
    
    override open func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        self.setTitle(Constants.Footer.Auto.idle , forState: .idle)
        self.setTitle(Constants.Footer.Auto.refreshing, forState: .refreshing)
        self.setTitle(Constants.Footer.Auto.noMoreData, forState: .noMoreData)
        
        self.stateLabel.isUserInteractionEnabled = true
        self.stateLabel.addGestureRecognizer(.init(target: self, action: #selector(RefreshAutoStateFooter.stateLabelClicked)))
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
