//
//  ZRefreshBackStateFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshBackStateFooter: RefreshBackFooter {
    
    fileprivate(set) lazy var stateLabel = RefreshingLabel()
    fileprivate var stateTitles:[RefreshState: String] = [:]
    
    open override var stateLabelHidden: Bool {
        didSet {
            self.stateLabel.isHidden = true
        }
    }
    
    override var state: RefreshState {
        get {
            return super.state
        }
        set {
            
            if self.checkState(newValue).result { return }
            super.state = newValue
            self.stateLabel.text = self.stateTitles[newValue]
        }
    }
    
    open func setTitle(_ title: String?, forState state: RefreshState) {
        if title == nil {return}
        self.stateTitles.updateValue(title!, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }

    fileprivate func titleForState(_ state: RefreshState) -> String? {
        return self.stateTitles[state]
    }
    
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
        self.stateLabel.frame = self.bounds;
    }
}
