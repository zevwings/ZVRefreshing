//
//  ZRefreshAutoStateFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAutoStateFooter: ZVRefreshAutoFooter {
    
    // MARK: - Property
    
    public var labelInsetLeft: CGFloat = 24.0
    private var _stateTitles:[State: String] = [:]

    public private(set) lazy var stateLabel: UILabel = { [unowned self] in
        let label: UILabel = .default
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(.init(target: self, action: #selector(stateLabelClicked)))
        return label
    }()    
    
    // MARK: getter & setter
    
    open override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            guard checkState(newValue).isIdenticalState == false else { return }
            super.refreshState = newValue
            
            if stateLabel.isHidden && newValue == .refreshing {
                stateLabel.text = nil
            } else {
                stateLabel.text = _stateTitles[newValue]
            }
        }
    }

    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()
        
        if stateLabel.superview == nil {
            addSubview(stateLabel)
        }
        
        setTitle(localized(string: LocalizedKey.Footer.Auto.idle) , forState: .idle)
        setTitle(localized(string: LocalizedKey.Footer.Auto.refreshing), forState: .refreshing)
        setTitle(localized(string: LocalizedKey.Footer.Auto.noMoreData), forState: .noMoreData)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if stateLabel.constraints.count > 0 { return }
        stateLabel.frame = bounds
    }
}

// MARK: - System Override

extension ZVRefreshAutoStateFooter {
    
    override open var tintColor: UIColor! {
        didSet {
            stateLabel.textColor = tintColor
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
}
