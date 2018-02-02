//
//  ZRefreshAnimationHeader.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAnimationHeader: ZVRefreshStateHeader {

    // MARK: - Property
    
    public private(set) var animationView: UIImageView?
    
    public var stateImages: [State: [UIImage]] = [:]
    public var stateDurations: [State: TimeInterval] = [:]

    // MARK: didSet
    
    override open var pullingPercent: CGFloat {
        didSet {
            pullAnimation(with: pullingPercent)
        }
    }
    
    // MARK: Subviews
    
    override open func prepare() {
        super.prepare()
    
        if animationView == nil {
            animationView = UIImageView()
            animationView?.backgroundColor = .clear
            addSubview(animationView!)
        }
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if let animationView = animationView, animationView.constraints.count == 0 {
            if let stateLabel = stateLabel, !stateLabel.isHidden {
                var animationViewWith: CGFloat = 0
                if let lastUpdatedTimeLabel = lastUpdatedTimeLabel, !lastUpdatedTimeLabel.isHidden {
                    let maxLabelWith = max(lastUpdatedTimeLabel.textWidth, stateLabel.textWidth)
                    animationViewWith = (frame.width - maxLabelWith) * 0.5 - labelInsetLeft
                } else {
                    animationViewWith = (frame.width - stateLabel.textWidth) * 0.5 - labelInsetLeft
                }
                animationView.frame = .init(x: 0, y: 0, width: animationViewWith, height: frame.height)
                animationView.contentMode = .right
            } else {
                animationView.contentMode = .center
                animationView.frame = bounds
            }
        }
    }

    // MARK: - Do On State
    
    open override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        stopAnimating()
    }
    
    open override func doOnRefreshing(with oldState: ZVRefreshComponent.State) {
        super.doOnRefreshing(with: oldState)

        startAnimating()
    }
}

// MARK: - Public

extension ZVRefreshAnimationHeader: ZVRefreshAnimationComponent {}

