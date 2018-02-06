//
//  ZRefreshAutoStateFooter.swift
//
//  Created by zevwings on 16/3/31.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshAutoStateFooter : ZVRefreshAutoFooter {
    
    // MARK: - Property
    
    public var labelInsetLeft: CGFloat = 12.0
    
    public var stateTitles: [State : String]?
    public private(set) var stateLabel: UILabel?
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()

        if stateLabel == nil {
            stateLabel = .default
            addSubview(stateLabel!)
        }
        
        setTitle(localized(string: LocalizedKey.Footer.Auto.idle) , for: .idle)
        setTitle(localized(string: LocalizedKey.Footer.Auto.refreshing), for: .refreshing)
        setTitle(localized(string: LocalizedKey.Footer.Auto.noMoreData), for: .noMoreData)
        
        addTarget(self, action: #selector(stateLabelClicked), for: .touchUpInside)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if let stateLabel = stateLabel, stateLabel.constraints.count == 0 {
            stateLabel.frame = bounds
        }
    }
    
    // MARK: - Do On State
    
    override open func doOnAnyState(with oldState: State) {
        super.doOnAnyState(with: oldState)
        
        setCurrentStateTitle()
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
    
    @objc func stateLabelClicked() {
        if refreshState == .idle { beginRefreshing() }
    }
}

// MARK: - ZVRefreshStateComponent

extension ZVRefreshAutoStateFooter : ZVRefreshStateComponentConvertor {}

