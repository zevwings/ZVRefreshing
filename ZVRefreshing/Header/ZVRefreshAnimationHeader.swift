//
//  ZRefreshAnimationHeader.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/4/1.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshAnimationHeader: ZVRefreshStateHeader {

    // MARK: - Property
    
    public private(set) var animationView: UIImageView?
    
    public var stateImages: [RefreshState: [UIImage]]?
    public var stateDurations: [RefreshState: TimeInterval]?

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
        
        if let animationView = animationView, animationView.constraints.isEmpty {
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

    // MARK: - State Update

    open override func refreshStateUpdate(
        _ state: ZVRefreshComponent.RefreshState,
        oldState: ZVRefreshComponent.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)

        switch state {
        case .idle:
            stopAnimating()
        case .refreshing:
            startAnimating()
        default:
            break
        }
    }
}

// MARK: - Public

extension ZVRefreshAnimationHeader: ZVRefreshAnimationComponentConvertor {}
