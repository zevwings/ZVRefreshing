//
//  ZRefreshAutoStateFooter.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/3/31.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshAutoStateFooter : ZVRefreshAutoFooter {
    
    // MARK: - Property
    
    public var labelInsetLeft: CGFloat = 12.0
    
    public var stateTitles: [RefreshState : String]?
    public private(set) var stateLabel: UILabel?
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()

        if stateLabel == nil {
            stateLabel = .default
            addSubview(stateLabel!)
        }
        
        setTitle(with: LocalizedKey.AutoFooter.idle , for: .idle)
        setTitle(with: LocalizedKey.AutoFooter.refreshing, for: .refreshing)
        setTitle(with: LocalizedKey.AutoFooter.noMoreData, for: .noMoreData)
        
        addTarget(self, action: #selector(_stateLabelClicked), for: .touchUpInside)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if let stateLabel = stateLabel, stateLabel.constraints.count == 0 {
            stateLabel.frame = bounds
        }
    }
    
    // MARK: - Do On State
    
    override open func doOnAnyState(with oldState: RefreshState) {
        super.doOnAnyState(with: oldState)
        
        setTitleForCurrentState()
    }
}

// MARK: - System Override

extension ZVRefreshAutoStateFooter {
    
    override open var tintColor: UIColor! {
        didSet {
            stateLabel?.textColor = tintColor
        }
    }
}

// MARK: - Private

private extension ZVRefreshAutoStateFooter {
    
    @objc func _stateLabelClicked() {
        if refreshState == .idle { beginRefreshing() }
    }
}

// MARK: - ZVRefreshStateComponent

extension ZVRefreshAutoStateFooter : ZVRefreshStateComponentConvertor {}

