//
//  ZRefreshAutoStateFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAutoStateFooter: ZVRefreshAutoFooter {
    
    public private(set) lazy var stateLabel: UILabel = { [unowned self] in
        let label: UILabel = .default
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(.init(target: self,
                                         action: #selector(ZVRefreshAutoStateFooter.stateLabelClicked)))
        return label
    }()
    
    public var labelInsetLeft: CGFloat = 24.0
    private var _stateTitles:[State: String] = [:]
    
    // MARK: Subviews
    
    open override func prepare() {
        super.prepare()
        
        if stateLabel.superview == nil {
            addSubview(stateLabel)
        }
        
        setTitle(localized(string: Constants.Footer.Auto.idle) , forState: .idle)
        setTitle(localized(string: Constants.Footer.Auto.refreshing), forState: .refreshing)
        setTitle(localized(string: Constants.Footer.Auto.noMoreData), forState: .noMoreData)
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        
        if stateLabel.constraints.count > 0 { return }
        stateLabel.frame = bounds
    }
    
    // MARK: Getter & Setter

    open override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            set(refreshState: newValue)
        }
    }
}

// MARK: - Override

extension ZVRefreshAutoStateFooter {
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            stateLabel.textColor = newValue
        }
    }
}

// MARK: - Public

public extension ZVRefreshAutoStateFooter {
    
    func setTitle(_ title: String?, forState state: State) {
        if title == nil {return}
        _stateTitles.updateValue(title!, forKey: state)
        stateLabel.text = _stateTitles[refreshState]
    }
}

// MARK: - Private

private extension ZVRefreshAutoStateFooter {
    
    @objc func stateLabelClicked() {
        if refreshState == .idle { beginRefreshing() }
    }
    
    func set(refreshState newValue: State) {
        
        if checkState(newValue).0 { return }
        super.refreshState = newValue
        
        if stateLabel.isHidden && newValue == .refreshing {
            stateLabel.text = nil
        } else {
            stateLabel.text = _stateTitles[newValue]
        }
    }
}
