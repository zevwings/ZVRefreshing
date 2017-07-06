//
//  ZRefreshAutoStateFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshAutoStateFooter: ZRefreshAutoFooter {
    
    open fileprivate(set) lazy var stateLabel: UILabel = RefreshingLabel()
    fileprivate var stateTitles:[RefreshState: String] = [:]
    
    open override var stateLabelHidden: Bool {
        didSet {
            self.stateLabel.isHidden = self.stateLabelHidden
        }
    }
    
    override var state: RefreshState {
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
    
    open func setTitle(_ title: String?, forState state: RefreshState) {
        if title == nil {return}
        self.stateTitles.updateValue(title!, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
    internal func stateLabelClicked() {
        if self.state == .idle {
            self.beginRefreshing()
        }
    }
    
    override open func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        self.setTitle(Constants.Footer.Auto.idle , forState: .idle)
        self.setTitle(Constants.Footer.Auto.refreshing, forState: .refreshing)
        self.setTitle(Constants.Footer.Auto.noMoreData, forState: .noMoreData)

        self.stateLabel.isUserInteractionEnabled = true;
        self.stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ZRefreshAutoStateFooter.stateLabelClicked)))
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if self.stateLabel.constraints.count > 0 { return }
        self.stateLabel.frame = self.bounds;
    }
}
