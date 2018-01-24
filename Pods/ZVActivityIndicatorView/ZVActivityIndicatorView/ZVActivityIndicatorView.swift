//
//  ZVActivityIndicatorView.swift
//  ZVActivityIndicatorView
//
//  Created by zevwings on 24/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

open class ZVActivityIndicatorView: UIView {
    
    open private(set) var isAnimating: Bool = false
    open var duration: TimeInterval = 1.25
    open var timingFunction: CAMediaTimingFunction?

    private var _strokeWidth: CGFloat = 1.0
    private var _color: UIColor? = .white
    private var _hidesWhenStopped: Bool = true
    private var _progress: CGFloat = 0.0

    private var _sharpeLayer: CAShapeLayer?
    private var _isObserved: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _prepare()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        _updateSharpeLayer()
    }
    
    deinit {
        _removeObserver()
    }
}

extension ZVActivityIndicatorView {
    
    open var progress: CGFloat {
        get {
            return _progress
        }
        set {
            _progress = newValue
            _sharpeLayer?.strokeEnd = newValue
        }
    }
    
    open var strokeWidth: CGFloat {
        get {
            return _strokeWidth
        }
        set {
            _strokeWidth = newValue
        }
    }
    
    open var hidesWhenStopped: Bool {
        get {
            return _hidesWhenStopped
        }
        set {
            _hidesWhenStopped = newValue
            isHidden = (!isAnimating && _hidesWhenStopped)
        }
    }
    
    open var color: UIColor? {
        get {
            return _color
        }
        set {
            _color = newValue
            _sharpeLayer?.strokeColor = _color?.cgColor
        }
    }
    
    open override var tintColor: UIColor! {
        get {
            return _color
        }
        set {
            _color = newValue
            _sharpeLayer?.strokeColor = _color?.cgColor
        }
    }
}

public extension ZVActivityIndicatorView {
    
    func startAnimating() {
        
        if isAnimating { return }
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = duration / 0.375
        animation.fromValue = 0
        animation.toValue = CGFloat(2 * Double.pi)
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        _sharpeLayer?.add(animation, forKey: "com.zevwings.animation.rotate")
        
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
        _sharpeLayer?.add(animations, forKey: "com.zevwings.animation.stroke")
        
        isAnimating = true
        
        if _hidesWhenStopped { isHidden = false }
    }
    
    func stopAnimating() {
        
        if !isAnimating { return }
        
        _sharpeLayer?.removeAnimation(forKey: "com.zevwings.animation.rotate")
        _sharpeLayer?.removeAnimation(forKey: "com.zevwings.animation.stroke")
        
        isAnimating = false;
        
        if _hidesWhenStopped { isHidden = true }
    }
    
}

private extension ZVActivityIndicatorView {
    
    func _prepare() {
        
        self.color = .clear

        self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if !_isObserved { _addObserver() }
        
        if (_sharpeLayer == nil) {
            _sharpeLayer = CAShapeLayer()
            layer.addSublayer(_sharpeLayer!)
        }
        
        _sharpeLayer?.fillColor = nil
        _sharpeLayer?.strokeColor = _color?.cgColor
        _sharpeLayer?.lineWidth = _strokeWidth
        _sharpeLayer?.strokeStart = 0
        _sharpeLayer?.strokeEnd = 0.0
    }
    
    func _updateSharpeLayer() {
        
        if frame == .zero { return }
        
        _sharpeLayer?.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width / 2, bounds.height / 2) - _strokeWidth / 2
        let startAngle: CGFloat = 0.0
        let endAngle = CGFloat(2 * Double.pi)
        
        let bezierPath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        _sharpeLayer?.path = bezierPath.cgPath
    }
    
    func _addObserver() {
        
        if _isObserved { return }
        
        _isObserved = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_resetAnimating),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    func _removeObserver() {
        
        _isObserved = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_resetAnimating),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    @objc func _resetAnimating() {
        
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
}
