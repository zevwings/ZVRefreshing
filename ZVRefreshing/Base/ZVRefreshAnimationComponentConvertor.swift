//
//  Protocols.swift
//  ZVRefreshing
//
//  Created by zevwings on 01/02/2018.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

public protocol ZVRefreshAnimationComponentConvertor: AnyObject {
    
    var stateImages: [ZVRefreshComponent.RefreshState: [UIImage]]? { get set }
    var stateDurations: [ZVRefreshComponent.RefreshState: TimeInterval]? { get set }
    
    var animationView: UIImageView? { get }
    
    func setImages(_ images: [UIImage], for state: ZVRefreshComponent.RefreshState)
    func setImages(_ images: [UIImage], duration: TimeInterval, for state: ZVRefreshComponent.RefreshState)
    
    func pullAnimation(with pullPercent: CGFloat)
    
    func startAnimating()
    
    func stopAnimating()
}

public extension ZVRefreshAnimationComponentConvertor where Self: ZVRefreshComponent {
    
    func setImages(_ images: [UIImage], for state: RefreshState) {
        setImages(images, duration: Double(images.count) * 0.1, for: state)
    }
    
    func setImages(_ images: [UIImage], duration: TimeInterval, for state: RefreshState) {
        
        guard !images.isEmpty else { return }
        
        if stateImages == nil { stateImages = [:] }
        if stateDurations == nil { stateDurations = [:] }
        
        stateImages?[state] = images
        stateDurations?[state] = duration
        if let image = images.first, image.size.height > frame.height {
            frame.size.height = image.size.height
        }
    }
    
    func pullAnimation(with pullPercent: CGFloat) {
        
        guard let images = stateImages?[.idle], !images.isEmpty, refreshState == .idle else { return }
        
        animationView?.stopAnimating()
        
        var idx = Int(CGFloat(images.count) * pullingPercent)
        if idx >= images.count { idx = images.count - 1 }
        animationView?.image = images[idx]
        
        if pullingPercent > 1.0 {
            startAnimating()
        }
    }
    
    func startAnimating() {
        
        guard let images = stateImages?[.refreshing], !images.isEmpty else { return }
        
        animationView?.stopAnimating()
        
        if images.count == 1 {
            animationView?.image = images.last
        } else {
            animationView?.animationImages = images
            animationView?.animationDuration = stateDurations?[.refreshing] ?? 0.0
            animationView?.startAnimating()
        }
    }
    
    func stopAnimating() {
        animationView?.stopAnimating()
    }
}
