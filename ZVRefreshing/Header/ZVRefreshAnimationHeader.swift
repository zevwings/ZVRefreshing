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
    
    override open func prepare() {
        super.prepare()
        
        if animationView.superview == nil {
            addSubview(animationView)
        }
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        guard animationView.constraints.count == 0 else { return }
        
        animationView.frame = bounds
        if stateLabel.isHidden && lastUpdatedTimeLabel.isHidden {
            animationView.contentMode = .center
        } else {
            animationView.contentMode = .right
            animationView.frame.size.width = frame.size.width * 0.5 - 90
        }
    }

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
    
    open override func update(refreshState newValue: State) {
        guard checkState(newValue).result == false else { return }
        super.update(refreshState: newValue)
        
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
}

// MARK: - Public

public extension ZVRefreshAnimationHeader {
    
    public func setImages(_ images: [UIImage], forState state: State){
        setImages(images, duration: Double(images.count) * 0.1, forState: state)
    }
    
    public func setImages(_ images: [UIImage], duration: TimeInterval, forState state: State){
        
        guard images.count != 0 else { return }
        
        _stateImages.updateValue(images, forKey: state)
        _stateDurations.updateValue(duration, forKey: state)
        if let image = images.first {
            if image.size.height > frame.size.height {
                frame.size.height = image.size.height
            }
        }
    }
}
