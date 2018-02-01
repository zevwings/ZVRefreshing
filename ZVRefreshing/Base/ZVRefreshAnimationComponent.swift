//
//  Protocols.swift
//  Pods-Example
//
//  Created by 张伟 on 01/02/2018.
//

import UIKit


public protocol ZVRefreshAnimationComponent: class {
    
    var stateImages: [ZVRefreshComponent.State: [UIImage]] { get set }
    var stateDurations: [ZVRefreshComponent.State: TimeInterval] { get set }
    
    var animationView: UIImageView { get }
    
    func setImages(_ images: [UIImage], for state: ZVRefreshComponent.State)
    func setImages(_ images: [UIImage], duration: TimeInterval, for state: ZVRefreshComponent.State)
}

public extension ZVRefreshAnimationComponent where Self: ZVRefreshComponent {
    
    func setImages(_ images: [UIImage], for state: ZVRefreshComponent.State) {
        setImages(images, duration: Double(images.count) * 0.1, for: state)
    }
    
    func setImages(_ images: [UIImage], duration: TimeInterval, for state: ZVRefreshComponent.State) {
        
        guard images.count != 0 else { return }
        
        stateImages[state] = images
        stateDurations[state] = duration
        if let image = images.first {
            if image.size.height > frame.size.height {
                frame.size.height = image.size.height
            }
        }
    }
}
