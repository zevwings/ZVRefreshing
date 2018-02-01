//
//  ZRefreshAutoAnimationFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit


open class ZVRefreshAutoAnimationFooter: ZVRefreshAutoStateFooter {
    
    // MARK: - Property
    
    public private(set) lazy var animationView: UIImageView = {
        let animationView = UIImageView()
        animationView.backgroundColor = .clear
        return animationView
    }()
    
    public var stateImages: [State: [UIImage]] = [:]
    public var stateDurations: [State: TimeInterval] = [:]
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()

        if animationView.superview == nil {
            addSubview(animationView)
        }
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        if animationView.constraints.count > 0 { return }
        animationView.frame = bounds
        if stateLabel.isHidden {
            animationView.contentMode = .scaleAspectFit
        } else {
            animationView.contentMode = .scaleAspectFit
            animationView.frame.size.width = frame.size.width * 0.5 - 90
        }
    }

    // MARK: - Do On State
    
    open override func doOnAnyState(with oldState: ZVRefreshComponent.State) {
        super.doOnAnyState(with: oldState)
        
        guard let images = stateImages[.refreshing], images.count > 0 else { return }
        
        animationView.stopAnimating()
        animationView.isHidden = false
        
        if images.count == 1 {
            animationView.image = images.last
        } else {
            animationView.animationImages = images
            animationView.animationDuration = stateDurations[.refreshing] ?? 0.0
            animationView.startAnimating()
        }
    }
    
    open override func doOnIdle(with oldState: ZVRefreshComponent.State) {
        super.doOnIdle(with: oldState)
        
        animationView.stopAnimating()
        animationView.isHidden = false
    }

    open override func doOnNoMoreData(with oldState: ZVRefreshComponent.State) {
        super.doOnNoMoreData(with: oldState)
        
        animationView.stopAnimating()
        animationView.isHidden = false
    }
}

extension ZVRefreshAutoAnimationFooter: ZVRefreshAnimationComponent {}

