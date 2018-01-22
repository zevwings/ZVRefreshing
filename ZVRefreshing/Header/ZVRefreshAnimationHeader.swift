//
//  ZRefreshAnimationHeader.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAnimationHeader: ZVRefreshStateHeader {

    public private(set) lazy var animationView: UIImageView = {
        let animationView = UIImageView()
        animationView.backgroundColor = .clear
        return animationView
    }()
    
    private var _stateImages: [State: [UIImage]] = [:]
    private var _stateDurations: [State: TimeInterval] = [:]

    // MARK: Subviews
    
    open override func prepare() {
        super.prepare()
        if animationView.superview == nil {
            addSubview(animationView)
        }
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        if animationView.constraints.count > 0 { return }
        animationView.frame = bounds
        if stateLabel.isHidden && lastUpdatedTimeLabel.isHidden {
            animationView.contentMode = .center
        } else {
            animationView.contentMode = .right
            animationView.size.width = width * 0.5 - 90
        }
    }

    // MARK: Getter & Setter
    
    open override var pullingPercent: CGFloat {
        didSet {
            didSet(pullingPercent: pullingPercent)
        }
    }
    
    open override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            set(refreshState: newValue)
        }
    }
}

// MARK: - Public

public extension ZVRefreshAnimationHeader {
    
    public func setImages(_ images: [UIImage], forState state: State){
        setImages(images, duration: Double(images.count) * 0.1, forState: state)
    }
    
    public func setImages(_ images: [UIImage], duration: TimeInterval, forState state: State){
        if images.count == 0 { return }
        
        _stateImages.updateValue(images, forKey: state)
        _stateDurations.updateValue(duration, forKey: state)
        if let image = images.first {
            if image.size.height > height {
                size.height = image.size.height
            }
        }
    }
}

// MARK: - Private

private extension ZVRefreshAnimationHeader {
    
    func set(refreshState newValue: State) {
        if checkState(newValue).result { return }
        super.refreshState = newValue
        
        if newValue == .pulling || newValue == .refreshing {
            let images = _stateImages[newValue]
            if images?.count == 0 { return }
            animationView.stopAnimating()
            if images?.count == 1{
                animationView.image = images?.last
            } else {
                animationView.animationImages = images
                animationView.animationDuration = _stateDurations[newValue] ?? 0.0
                animationView.startAnimating()
            }
        } else if newValue == .idle {
            animationView.stopAnimating()
        }
    }
    
    func didSet(pullingPercent: CGFloat) {
        let imgs = _stateImages[.idle] ?? []
        if refreshState != .idle || imgs.count == 0 { return }
        animationView.stopAnimating()
        var index = Int(CGFloat(imgs.count) * pullingPercent)
        if index >= imgs.count {
            index = imgs.count - 1
        }
        animationView.image = imgs[index]

    }
}
