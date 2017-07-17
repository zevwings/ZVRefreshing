//
//  ZRefreshAutoAnimationFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshAutoAnimationFooter: ZVRefreshAutoStateFooter {
    
    fileprivate(set) lazy var animationView: UIImageView = {
        let animationView = UIImageView()
        animationView.backgroundColor = UIColor.clear
        return animationView
    }()
    
    fileprivate var _stateImages: [ZVRefreshState: [UIImage]] = [:]
    fileprivate var _stateDurations: [ZVRefreshState: TimeInterval] = [:]
    
    override open var state: ZVRefreshState {
        get {
            return super.state
        }
        set {
            guard self.checkState(newValue).result == false else { return }
            super.state = newValue
            
            switch newValue {
            case .refreshing:
                
                guard let images = self._stateImages[newValue], images.count > 0 else { return }
                
                self.animationView.stopAnimating()
                self.animationView.isHidden = false
                
                if images.count == 1 {
                    self.animationView.image = images.last
                } else {
                    self.animationView.animationImages = images
                    self.animationView.animationDuration = self._stateDurations[newValue] ?? 0.0
                    self.animationView.startAnimating()
                }
                break
            case .noMoreData, .idle:
                self.animationView.stopAnimating()
                self.animationView.isHidden = false
                break
            default: break
            }
        }
    }
}

extension ZVRefreshAutoAnimationFooter {
    
    /// 为相应状态设置图片
    public func setImages(_ images: [UIImage], state: ZVRefreshState) {
        self.setImages(images, duration: Double(images.count) * 0.1, state: state)
    }
    
    /// 为相应状态设置图片
    public func setImages(_ images: [UIImage], duration: TimeInterval, state: ZVRefreshState){
        
        guard images.count > 0 else { return }
        
        self._stateImages[state] = images
        self._stateDurations[state] = duration
        guard let image = images.first, image.size.height < self.height else { return }
        self.height = image.size.height
    }
}

extension ZVRefreshAutoAnimationFooter {
  
    override open func prepare() {
        super.prepare()
        if self.animationView.superview == nil {
            self.addSubview(self.animationView)
        }
    }

    override open func placeSubViews() {
        super.placeSubViews()
        
        if self.animationView.constraints.count > 0 { return }
        self.animationView.frame = self.bounds
        if self.stateLabel.isHidden {
            self.animationView.contentMode = .scaleAspectFit
        } else {
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.width = self.width * 0.5 - 90
        }
    }
}
