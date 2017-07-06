//
//  ZRefreshBackAnimationFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshBackAnimationFooter: RefreshBackStateFooter {

    fileprivate(set) lazy var  animationView: UIImageView = {
        let animationView = UIImageView()
        animationView.backgroundColor = UIColor.clear
        return animationView
    }()
    
    fileprivate var stateImages: [RefreshState: [UIImage]] = [:]
    fileprivate var stateDurations: [RefreshState: TimeInterval] = [:]
    
    override var pullingPercent: CGFloat {
        didSet {
            let imgs = self.stateImages[.idle] ?? []
            if self.state != .idle || imgs.count == 0 { return }
            self.animationView.stopAnimating()
            var index = Int(CGFloat(imgs.count) * pullingPercent)
            if index >= imgs.count {
                index = imgs.count - 1
            }
            self.animationView.image = imgs[index]
        }
    }
    
    override var state: RefreshState {
        get {
            return super.state
        }
        set {
            
            if self.checkState(newValue).0 { return }
            super.state = newValue
            
            if newValue == .pulling || newValue == .refreshing {
                
                guard let images = self.stateImages[state], images.count > 0 else { return }
                self.animationView.stopAnimating()
                
                if images.count == 1 {
                    self.animationView.image = images.last
                } else {
                    self.animationView.animationImages = images
                    self.animationView.animationDuration = self.stateDurations[state] ?? 0
                    self.animationView.startAnimating()
                }
            } else if newValue == .idle {
                self.animationView.stopAnimating()
            }
        }
    }
}

extension RefreshBackAnimationFooter {
    
    public func setImages(_ images: [UIImage], state: RefreshState){
        self.setImages(images, duration: Double(images.count) * 0.1, state: state)
    }
    
    public func setImages(_ images: [UIImage], duration: TimeInterval, state: RefreshState){
        if images.count == 0 { return }
        
        self.stateImages.updateValue(images, forKey: state)
        self.stateDurations.updateValue(duration, forKey: state)
        if let image = images.first {
            if image.size.height > self.height {
                self.height = image.size.height
            }
        }
    }
}

extension RefreshBackAnimationFooter {
    
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
