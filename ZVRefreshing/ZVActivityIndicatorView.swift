//
//  ZActivityIndicatorView.swift
//  ZActivityIndicatorView
//
//  Created by ZhangZZZZ on 16/4/25.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZVActivityIndicatorView: UIView {
    
    public private(set) var isAnimating: Bool = false
    public var duration: TimeInterval = 1.0
    public var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    public lazy var activityIndicatorLayer: CAShapeLayer = {
        let activityIndicatorLayer = CAShapeLayer()
        activityIndicatorLayer.fillColor = nil
        activityIndicatorLayer.strokeColor = UIColor.white.cgColor
        return activityIndicatorLayer
    }()
    
    public var lineWidth: CGFloat = 1.0 {
        didSet {
            activityIndicatorLayer.lineWidth = lineWidth
            prepare()
        }
    }
    
    public var hiddenWhenStopped: Bool = false {
        didSet {
            isHidden = !isAnimating && hiddenWhenStopped
        }
    }
    
    public var color: UIColor? {
        get {
            if let strokeColor = activityIndicatorLayer.strokeColor {
                return UIColor(cgColor: strokeColor)
            }
            return nil
        }
        set {
            activityIndicatorLayer.strokeColor = newValue?.cgColor
        }
    }
    
    public var percent: CGFloat {
        get {
            return 0
        }
        set {
            activityIndicatorLayer.strokeEnd = newValue
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(activityIndicatorLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(resetAnimating), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(NSNotification.Name.UIApplicationDidBecomeActive)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        prepare()
    }
    
    func prepare() {
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width / 2, bounds.height / 2) -
            activityIndicatorLayer.lineWidth / 2
        let startAngle: CGFloat = 0.0
        let endAngle = CGFloat(2 * Double.pi)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        activityIndicatorLayer.path = path.cgPath
        activityIndicatorLayer.strokeStart = 0.0
        activityIndicatorLayer.strokeEnd = 0.0
    }
    
    
    
    public func startAnimating() {
        
        if isAnimating { return }
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = duration / 0.375
        animation.fromValue = 0
        animation.toValue = CGFloat(2 * Double.pi)
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        activityIndicatorLayer.add(animation, forKey: "com.zevwings.animation.rotate")
        
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart"
        headAnimation.duration = duration / 1.5
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = timingFunction;

        let tailAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = duration / 1.5
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.timingFunction = timingFunction;

        
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart";
        endHeadAnimation.beginTime = duration / 1.5
        endHeadAnimation.duration = duration / 3.0
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = timingFunction;

        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = duration / 1.5
        endTailAnimation.duration = duration / 3.0
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = timingFunction;

        let animations = CAAnimationGroup()
        animations.duration = duration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity
        animations.isRemovedOnCompletion = false
        activityIndicatorLayer.add(animations, forKey: "com.zevwings.animation.stroke")
        
        isAnimating = true
 
        if hiddenWhenStopped {
            isHidden = false
        }
    }
    
    public func stopAnimating() {
        if !isAnimating { return }
        
        activityIndicatorLayer.removeAnimation(forKey: "com.zevwings.animation.rotate")
        activityIndicatorLayer.removeAnimation(forKey: "com.zevwings.animation.stroke")
        isAnimating = false;
        
        if hiddenWhenStopped {
            isHidden = true
        }
    }
    
    @objc func resetAnimating() {
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
}
