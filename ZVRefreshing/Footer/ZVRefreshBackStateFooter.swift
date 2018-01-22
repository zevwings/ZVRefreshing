//
//  ZRefreshBackStateFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshBackStateFooter: ZVRefreshBackFooter {
    
    public private(set) lazy var stateLabel: UILabel = .default
    public var labelInsetLeft: CGFloat = 24.0
    private var _stateTitles:[State: String] = [:]
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            stateLabel.textColor = newValue
        }
    }
    
    open override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            if checkState(newValue).result { return }
            super.refreshState = newValue
            stateLabel.text = _stateTitles[newValue]
        }
    }
    
    open override func prepare() {
        super.prepare()
        
        if stateLabel.superview == nil {
            addSubview(stateLabel)
        }
        
        setTitle(localized(string: Constants.Footer.Back.idle), forState: .idle)
        setTitle(localized(string: Constants.Footer.Back.pulling), forState: .pulling)
        setTitle(localized(string: Constants.Footer.Back.refreshing), forState: .refreshing)
        setTitle(localized(string: Constants.Footer.Back.noMoreData), forState: .noMoreData)
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        if stateLabel.constraints.count > 0 { return }
        stateLabel.frame = bounds
    }

}

extension ZVRefreshBackStateFooter {
    
    public func setTitle(_ title: String, forState state: State) {
        _stateTitles.updateValue(title, forKey: state)
        stateLabel.text = _stateTitles[refreshState]
    }
}

extension ZVRefreshBackStateFooter {
    
}
