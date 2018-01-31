//
//  ZRefreshBackAnimationFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshBackAnimationFooter: ZVRefreshBackStateFooter {

    private(set) lazy var  animationView: UIImageView = {
        let animationView = UIImageView()
        animationView.backgroundColor = .clear
        return animationView
    }()
    
    private var _stateImages: [State: [UIImage]] = [:]
    private var _stateDurations: [State: TimeInterval] = [:]
    
    // MARK: Getter & Setter
    
    override open var pullingPercent: CGFloat {
        didSet {
            let images = _stateImages[.idle] ?? []
            if refreshState != .idle || images.count == 0 { return }
            animationView.stopAnimating()
            var index = Int(CGFloat(images.count) * pullingPercent)
            if index >= images.count {
                index = images.count - 1
            }
            animationView.image = images[index]
            
        }
    }
    
    // MARK: Subviews
    
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
            animationView.contentMode = .center
        } else {
            animationView.contentMode = .right
            animationView.frame.size.width = frame.size.width * 0.5 - 90
        }
    }
    
    // MARK: Update State
    
    open override func update(refreshState newValue: State) {
        
        guard checkState(newValue).isIdenticalState == false else { return }
        super.update(refreshState: newValue)
    }
    
    override func doOn(pulling oldState: ZVRefreshComponent.State) {
        super.doOn(pulling: oldState)
        
        guard let images = _stateImages[.pulling], images.count > 0 else { return }
        animationView.stopAnimating()
        
        if images.count == 1 {
            animationView.image = images.last
        } else {
            animationView.animationImages = images
            animationView.animationDuration = _stateDurations[.pulling] ?? 0
            animationView.startAnimating()
        }
    }
    
    override func doOn(refreshing oldState: ZVRefreshComponent.State) {
        super.doOn(refreshing: oldState)
        
        guard let images = _stateImages[.refreshing], images.count > 0 else { return }
        animationView.stopAnimating()
        
        if images.count == 1 {
            animationView.image = images.last
        } else {
            animationView.animationImages = images
            animationView.animationDuration = _stateDurations[.refreshing] ?? 0
            animationView.startAnimating()
        }
    }
    
    override func doOn(idle oldState: ZVRefreshComponent.State) {
        super.doOn(idle: oldState)
        
        animationView.stopAnimating()
    }
}

// MARK: - Public

extension ZVRefreshBackAnimationFooter {
    
    public func setImages(_ images: [UIImage], state: State){
        setImages(images, duration: Double(images.count) * 0.1, state: state)
    }
    
    public func setImages(_ images: [UIImage], duration: TimeInterval, state: State){
        if images.count == 0 { return }
        
        _stateImages.updateValue(images, forKey: state)
        _stateDurations.updateValue(duration, forKey: state)
        if let image = images.first {
            if image.size.height > frame.size.height {
                frame.size.height = image.size.height
            }
        }
    }
}

