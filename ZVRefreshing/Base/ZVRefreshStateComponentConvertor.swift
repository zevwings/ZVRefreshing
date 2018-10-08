//
//  ZVRefreshStateComponent.swift
//  Pods-Example
//
//  Created by zevwings on 01/02/2018.
//

import UIKit

public protocol ZVRefreshStateComponentConvertor: class {
    
    var stateLabel: UILabel? { get }

    var stateTitles: [ZVRefreshComponent.RefreshState : String]? { get set }
 
    func setCurrentStateTitle()
    
    func setTitle(_ title: String, for state: ZVRefreshComponent.RefreshState)
}

public extension ZVRefreshStateComponentConvertor where Self: ZVRefreshComponent {
    
    func setCurrentStateTitle() {
        guard let _stateLabel = stateLabel else { return }
        if _stateLabel.isHidden && refreshState == .refreshing {
            _stateLabel.text = nil
        } else {
            _stateLabel.text = stateTitles?[refreshState]
        }
    }
    
    func setTitle(_ title: String, for state: RefreshState) {
        if stateTitles == nil { stateTitles = [:] }
        stateTitles?[state] = title
        stateLabel?.text = stateTitles?[refreshState]
    }
}
