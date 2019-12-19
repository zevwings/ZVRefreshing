//
//  ZRefreshAutoAnimationFooter.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/4/1.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshAutoAnimationFooter: ZVRefreshAutoStateFooter {
    
    // MARK: - Property
    
    public private(set) var animationView: UIImageView?
    
    public var stateImages: [RefreshState: [UIImage]]?
    public var stateDurations: [RefreshState: TimeInterval]?
    
    // MARK: - Subviews
    
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
                let width = (frame.width - stateLabel.textWidth) * 0.5 - labelInsetLeft
                animationView.frame = .init(x: 0, y: 0, width: width, height: frame.height)
                animationView.contentMode = .right
            } else {
                animationView.contentMode = .center
                animationView.frame = bounds
            }
        }
    }

    // MARK: - Do On State
    
    override open func doOnRefreshing(with oldState: RefreshState) {
        super.doOnRefreshing(with: oldState)
        
        startAnimating()
    }
    
    override open func doOnIdle(with oldState: RefreshState) {
        super.doOnIdle(with: oldState)
        
        stopAnimating()
    }

    override open func doOnNoMoreData(with oldState: RefreshState) {
        super.doOnNoMoreData(with: oldState)
        
        stopAnimating()
    }
}

extension ZVRefreshAutoAnimationFooter: ZVRefreshAnimationComponentConvertor {}
