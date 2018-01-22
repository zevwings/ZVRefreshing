//
//  ZRefreshAutoAnimationFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAutoAnimationFooter: ZVRefreshAutoStateFooter {
    
    private(set) lazy var animationView: UIImageView = {
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
        if stateLabel.isHidden {
            animationView.contentMode = .scaleAspectFit
        } else {
            animationView.contentMode = .scaleAspectFit
            animationView.frame.size.width = frame.size.width * 0.5 - 90
        }
    }

    // MARK: Getter & Setter
    
    open override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            _set(refreshState: newValue)
        }
    }
}

// MARK: - Public

extension ZVRefreshAutoAnimationFooter {
    
    /// 为相应状态设置图片
    public func setImages(_ images: [UIImage], state: State) {
        setImages(images, duration: Double(images.count) * 0.1, state: state)
    }
    
    /// 为相应状态设置图片
    public func setImages(_ images: [UIImage], duration: TimeInterval, state: State){
        
        guard images.count > 0 else { return }
        
        _stateImages[state] = images
        _stateDurations[state] = duration
        guard let image = images.first, image.size.height < frame.size.height else { return }
        frame.size.height = image.size.height
    }
}

// MARK: - Private

private extension ZVRefreshAutoAnimationFooter {
    
    func _set(refreshState newValue: State) {
        
        guard checkState(newValue).result == false else { return }
        super.refreshState = newValue
        
        switch newValue {
        case .refreshing:
            
            guard let images = _stateImages[newValue], images.count > 0 else { return }
            
            animationView.stopAnimating()
            animationView.isHidden = false
            
            if images.count == 1 {
                animationView.image = images.last
            } else {
                animationView.animationImages = images
                animationView.animationDuration = _stateDurations[newValue] ?? 0.0
                animationView.startAnimating()
            }
            break
        case .noMoreData, .idle:
            
            animationView.stopAnimating()
            animationView.isHidden = false
            break
        default: break
        }
    }
}
