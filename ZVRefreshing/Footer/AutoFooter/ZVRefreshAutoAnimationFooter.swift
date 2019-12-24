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
    
    public var stateImages: [RefreshState: [UIImage]] = [:]
    public var stateDurations: [RefreshState: TimeInterval] = [:]
    
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

    // MARK: - State Update
    
    open override func refreshStateUpdate(
        _ state: ZVRefreshControl.RefreshState,
        oldState: ZVRefreshControl.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)

        switch state {
        case .refreshing:
            startAnimating()
        case .idle, .noMoreData:
            stopAnimating()
        default:
            break
        }
    }

    open func setImages(_ images: [UIImage], for state: RefreshState) {
        setImages(images, duration: Double(images.count) * 0.1, for: state)
    }

    open func setImages(_ images: [UIImage], duration: TimeInterval, for state: RefreshState) {

        guard !images.isEmpty else { return }

        stateImages[state] = images
        stateDurations[state] = duration
        if let image = images.first, image.size.height > frame.height {
            frame.size.height = image.size.height
        }
    }

    open func pullAnimation(with pullPercent: CGFloat) {

        guard let images = stateImages[.idle], !images.isEmpty, refreshState == .idle else { return }

        animationView?.stopAnimating()

        var idx = Int(CGFloat(images.count) * pullingPercent)
        if idx >= images.count { idx = images.count - 1 }
        animationView?.image = images[idx]

        if pullingPercent > 1.0 {
            startAnimating()
        }
    }

    open func startAnimating() {

        guard let images = stateImages[.refreshing], !images.isEmpty else { return }

        animationView?.stopAnimating()

        if images.count == 1 {
            animationView?.image = images.last
        } else {
            animationView?.animationImages = images
            animationView?.animationDuration = stateDurations[.refreshing] ?? 0.0
            animationView?.startAnimating()
        }
    }

    open func stopAnimating() {
        animationView?.stopAnimating()
    }
}
