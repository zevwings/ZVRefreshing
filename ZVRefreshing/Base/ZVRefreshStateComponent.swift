//
//  ZVRefreshStateComponent.swift
//  Pods-Example
//
//  Created by 张伟 on 01/02/2018.
//

import UIKit

public protocol ZVRefreshStateComponent: class {
    
    var stateLabel: UILabel { get }

    var stateTitles: [ZVRefreshComponent.State : String] { get set }
    
    func setTitle(_ title: String, for state: ZVRefreshComponent.State)
}

public extension ZVRefreshStateComponent where Self: ZVRefreshComponent {
    
    func setTitle(_ title: String, for state: ZVRefreshComponent.State) {
        stateTitles[state] = title
        stateLabel.text = stateTitles[refreshState]
    }
}
