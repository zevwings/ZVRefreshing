//
//  ZRefreshBackStateFooter.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/4/1.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshBackStateFooter: ZVRefreshBackFooter {
    
    // MARK: - Property
    
    public var labelInsetLeft: CGFloat = 12.0
    
    public var stateTitles: [RefreshState : String] = [:]
    public private(set) var stateLabel: UILabel?
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()
        
        if stateLabel == nil {
            stateLabel = .default
            addSubview(stateLabel!)
        }
        
        setTitle(with: LocalizedKey.BackFooter.idle, for: .idle)
        setTitle(with: LocalizedKey.BackFooter.pulling, for: .pulling)
        setTitle(with: LocalizedKey.BackFooter.refreshing, for: .refreshing)
        setTitle(with: LocalizedKey.BackFooter.noMoreData, for: .noMoreData)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if let stateLabel = stateLabel, stateLabel.constraints.isEmpty {
            stateLabel.frame = bounds
        }
    }
    
    // MARK: - State Update
    
    open override func refreshStateUpdate(
        _ state: ZVRefreshComponent.RefreshState,
        oldState: ZVRefreshComponent.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)
        setTitleForCurrentState()
    }

    open func setTitle(_ title: String, for state: RefreshState) {
           stateTitles[state] = title
           stateLabel?.text = stateTitles[refreshState]
           setNeedsLayout()
       }

       open func setTitle(with localizedKey: String, for state: RefreshState) {
           let title = ZVLocalizedString(localizedKey)
           setTitle(title, for: state)
       }

       open func setTitleForCurrentState() {
           guard let stateLabel = stateLabel else { return }
           if stateLabel.isHidden && refreshState == .refreshing {
               stateLabel.text = nil
           } else {
               stateLabel.text = stateTitles[refreshState]
           }
       }
}

// MARK: - Override

extension ZVRefreshBackStateFooter {
    
    override open var tintColor: UIColor! {
        didSet {
            stateLabel?.textColor = tintColor
        }
    }
}
