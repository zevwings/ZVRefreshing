//
//  ZVRefreshStateComponent.swift
//  ZVRefreshing
//
//  Created by zevwings on 01/02/2018.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

public protocol ZVRefreshStateComponentConvertor: class {
    
    var stateLabel: UILabel? { get }

    var stateTitles: [ZVRefreshComponent.RefreshState : String]? { get set }
    
    func setTitle(_ title: String, for state: ZVRefreshComponent.RefreshState)
}

public extension ZVRefreshStateComponentConvertor where Self: ZVRefreshComponent {
    
    func setTitle(_ title: String, for state: RefreshState) {
        if stateTitles == nil { stateTitles = [:] }
        stateTitles?[state] = title
        stateLabel?.text = stateTitles?[refreshState]
        setNeedsLayout()
    }
    
    func setTitle(with localizedKey: String, for state: RefreshState) {
        let title = ZVLocalizedString(localizedKey)
        setTitle(title, for: state)
    }
    
    func setTitleForCurrentState() {
        guard let _stateLabel = stateLabel else { return }
        if _stateLabel.isHidden && refreshState == .refreshing {
            _stateLabel.text = nil
        } else {
            _stateLabel.text = stateTitles?[refreshState]
        }
    }
}
