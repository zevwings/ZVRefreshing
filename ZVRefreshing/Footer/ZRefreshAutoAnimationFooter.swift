//
//  ZRefreshAutoAnimationFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshAutoAnimationFooter: RefreshAutoStateFooter {
    
    fileprivate(set) lazy var animationView: UIImageView = {
        let animationView = UIImageView()
        animationView.backgroundColor = UIColor.clear
        return animationView
    }()
    
    fileprivate var stateImages: [RefreshState: [UIImage]] = [:]
    fileprivate var stateDurations: [RefreshState: TimeInterval] = [:]
    
    override var state: RefreshState {
        get {
            return super.state
        }
        set {
            guard self.checkState(newValue).result == false else { return }
            super.state = newValue
            
            switch newValue {
            case .refreshing:
                guard let images = self.stateImages[state], images.count > 0 else { return }
                
                self.animationView.stopAnimating()
                self.animationView.isHidden = false
                
                if images.count == 1 {
                    self.animationView.image = images.last
                } else {
                    self.animationView.animationImages = images
                    self.animationView.animationDuration = self.stateDurations[state] ?? 0.0
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

extension RefreshAutoAnimationFooter {
    
    /// 为相应状态设置图片
    public func setImages(_ images: [UIImage], state: RefreshState) {
        self.setImages(images, duration: Double(images.count) * 0.1, state: state)
    }
    
    /// 为相应状态设置图片
    public func setImages(_ images: [UIImage], duration: TimeInterval, state: RefreshState){
        
        guard images.count > 0 else { return }
        
        self.stateImages[self.state] = images
        self.stateDurations[self.state] = duration
        guard let image = images.first, image.size.height < self.height else { return }
        self.height = image.size.height
    }
}

extension RefreshAutoAnimationFooter {
  
    override func prepare() {
        super.prepare()
        if self.animationView.superview == nil {
            self.addSubview(self.animationView)
        }
    }

    override func placeSubViews() {
        super.placeSubViews()
        
        if self.animationView.constraints.count > 0 { return }
        self.animationView.frame = self.bounds
        if self.stateLabel.isHidden {
            self.animationView.contentMode = .center
        } else {
            self.animationView.contentMode = .right
            self.animationView.width = self.width * 0.5 - 90
        }
    }
}
