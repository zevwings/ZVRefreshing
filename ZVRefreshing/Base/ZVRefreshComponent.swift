//
//  ZRefreshComponent.swift
//
//  Created by zevwings on 16/3/29.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshComponent: UIControl {
    
    public enum RefreshState {
        case idle
        case pulling
        case willRefresh
        case refreshing
        case noMoreData
    }
    
    // MARK: - Property
    
    public private(set) var isRefreshing: Bool = false

    private weak var target: AnyObject?
    private var action: Selector?
    
    public private(set) weak var scrollView: UIScrollView?
    public private(set) weak var pan: UIPanGestureRecognizer?

    private var offsetObservation: NSKeyValueObservation?
    private var insetsObservation: NSKeyValueObservation?
    private var contentSizeObservation: NSKeyValueObservation?
    private var panStateObservation: NSKeyValueObservation?

    var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero

    // MARK: getter & setter
    
    private var refreshHandler: ZVRefreshHandler?
    
    private var _refreshState: RefreshState = .idle
    open var refreshState: RefreshState {
        get {
            return _refreshState
        }
        set {
            let oldState = refreshState
            guard oldState != newValue else { return }
            
            willChangeValue(forKey: "isRefreshing")
            isRefreshing = newValue == .refreshing
            didChangeValue(forKey: "isRefreshing")
            
            willChangeValue(forKey: "refreshState")
            _refreshState = newValue
            didChangeValue(forKey: "refreshState")
            
            sendActions(for: .valueChanged)

            refreshStateUpdate(newValue, oldState: oldState)

//            doOnAnyState(with: oldState)
//
//            switch newValue {
//            case .idle:
//                doOnIdle(with: oldState)
//            case .noMoreData:
//                doOnNoMoreData(with: oldState)
//            case .pulling:
//                doOnPulling(with: oldState)
//            case .willRefresh:
//                doOnWillRefresh(with: oldState)
//            case .refreshing:
//                doOnRefreshing(with: oldState)
//            }
        }
    }
    
    // MARK: didSet
    
    public var isAutomaticallyChangeAlpha: Bool = true {
        didSet {
            guard !isRefreshing else { return }
            if isAutomaticallyChangeAlpha {
                alpha = pullingPercent
            } else {
                alpha = 1.0
            }
        }
    }
    
    open var pullingPercent: CGFloat = 0.0 {
        didSet {
            guard isRefreshing == false else { return }
            if isAutomaticallyChangeAlpha { alpha = pullingPercent }
        }
    }
    
    // MARK: - Init
    
    deinit {
        _removeObservers()
    }
    
    /// Init
    convenience public init() {
        self.init(frame: .zero)
    }
    
    /// Init with callback closure
    ///
    /// - Parameter refreshHandler: callback closure
    convenience public init(refreshHandler: @escaping ZVRefreshHandler) {
        self.init()
        self.refreshHandler = refreshHandler
    }
    
    /// Init with callback target and selector
    ///
    /// - Parameters:
    ///   - target: callback target
    ///   - action: callback selector
    convenience public init(target: Any, action: Selector) {
        self.init()
        
        guard let target = target as? NSObject else { return }
        self.target = target
        self.action = action
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    // MARK: - Subviews
    
    open func prepare() {
        autoresizingMask = .flexibleWidth
        backgroundColor = .clear
    }
    
    open func placeSubViews() {}
    
    // MARK: - State Update

    open func refreshStateUpdate(
        _ state: ZVRefreshComponent.RefreshState,
        oldState: ZVRefreshComponent.RefreshState
    ) {}
    
    // MARK: - Observers

    open func scrollView(
        _ scrollView: UIScrollView,
        contentOffset oldValue: CGPoint?,
        newValue: CGPoint?
    ) {}

    open func scrollView(
        _ scrollView: UIScrollView,
        contentSize oldValue: CGSize?,
        newValue: CGSize?
    ) {}

    open func scrollView(
        _ scrollView: UIScrollView,
        contentInsets oldValue: UIEdgeInsets?,
        newValue: UIEdgeInsets?
    ) {}

    open func pan(
        _ pan: UIPanGestureRecognizer,
        state oldValue: UIPanGestureRecognizer.State?,
        newValue: UIPanGestureRecognizer.State?
    ) {}

}

// MARK: - System Override

extension ZVRefreshComponent {
    
    override open func layoutSubviews() {
        placeSubViews()
        super.layoutSubviews()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if refreshState == .willRefresh { refreshState = .refreshing }
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let superview = newSuperview as? UIScrollView else { return }
        
        _removeObservers()
        
        frame.origin.x = 0
        frame.size.width = superview.frame.width
        backgroundColor = superview.backgroundColor
        
        scrollView = superview
        scrollView?.alwaysBounceVertical = true
        scrollViewOriginalInset = superview.contentInset
        
        _addObservers()
    }
}

// MARK: - State Control

extension ZVRefreshComponent {
    
    public func beginRefreshing() {
        
        // make sure code excute in main queue.
        DispatchQueue.main.async {
            UIView.animate(withDuration: AnimationDuration.fast, animations: {
                self.alpha = 1.0
            })
            
            self.pullingPercent = 1.0
            
            if self.window != nil {
                self.refreshState = .refreshing
            } else {
                if self.refreshState != .refreshing {
                    self.refreshState = .willRefresh
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    public func endRefreshing() {
        
        // make sure code excute in main queue.
        DispatchQueue.main.async {
            self.refreshState = .idle
        }
    }
}

// MARK: - Observers

extension ZVRefreshComponent {

    private func _addObservers() {
        
        let options: NSKeyValueObservingOptions = [.new, .old]

        guard let scrollView = scrollView else { return }

        offsetObservation = scrollView.observe(
            \.contentOffset,
            options: options,
            changeHandler: { (scrollView, change) in
                self.scrollView(scrollView, contentOffset: change.oldValue, newValue: change.newValue)
        })

        contentSizeObservation = scrollView.observe(
            \.contentSize,
            options: options,
            changeHandler: { (scrollView, change) in
                self.scrollView(scrollView, contentSize: change.oldValue, newValue: change.newValue)
        })

        insetsObservation = scrollView.observe(
            \.contentInset,
            options: options,
            changeHandler: { (scrollView, change) in
                self.scrollView(scrollView, contentInsets: change.oldValue, newValue: change.newValue)
        })

        self.pan = scrollView.panGestureRecognizer
        panStateObservation = pan?.observe(
            \.state,
            options: options,
            changeHandler: { (pan, change) in
                self.pan(pan, state: change.oldValue, newValue: change.newValue)
        })
    }
    
    private func _removeObservers() {
        offsetObservation?.invalidate()
        contentSizeObservation?.invalidate()
        insetsObservation?.invalidate()
        panStateObservation?.invalidate()
        pan = nil
        
//        scrollView?.removeObserver(self, forKeyPath: KVO.ScrollViewPath.contentSize, context: &KVO.context)
//        scrollView?.removeObserver(self, forKeyPath: KVO.ScrollViewPath.contentInset, context: &KVO.context)
//        scrollView?.removeObserver(self, forKeyPath: KVO.ScrollViewPath.contentOffset, context: &KVO.context)
//
//        pan?.removeObserver(self, forKeyPath: KVO.PanGesturePath.state, context: &KVO.context)
//        pan = nil
    }
//
//    override open func observeValue(forKeyPath keyPath: String?,
//                                    of object: Any?,
//                                    change: [NSKeyValueChangeKey : Any]?,
//                                    context: UnsafeMutableRawPointer?) {

//        guard isUserInteractionEnabled else { return }
//
//        guard let superScrollView = scrollView else { return }

//        let old = (value?[.oldKey] as? NSValue)?.cgPointValue
//        let new = (value?[.newKey] as? NSValue)?.cgPointValue

//        if keyPath == ObserversKeyPath.contentSize {
//            scrollView(superScrollView, contentSizeDidChanged: change)
//        }
//
//        guard isHidden == false else { return }
//
//        if keyPath == ObserversKeyPath.contentOffset {
//            scrollView(superScrollView, contentOffsetDidChanged: change)
//        } else if keyPath == ObserversKeyPath.panState {
//            panGestureRecognizer(superScrollView.panGestureRecognizer, stateValueChanged: change, for: superScrollView)
//        }
//    }
}

// MARK: - Public

public extension ZVRefreshComponent {

    func addHander(_ refreshHandler: @escaping ZVRefreshHandler) {
        self.refreshHandler = refreshHandler
    }

    func addTarget(_ target: Any, action: Selector) {
        self.target = target as AnyObject
        self.action = action
    }
}

// MARK: - Internal

extension ZVRefreshComponent {
    
    func executeRefreshCallback() {
        
        DispatchQueue.main.async {
            self.refreshHandler?()
            if let target = self.target, let action = self.action, target.responds(to: action) {
                _ = target.perform(action, with: self)
            }
        }
    }
}

extension ZVRefreshComponent {

    /// 解决iOS 10 Observer 临时解决方案
    public func removeObservers() {
        if #available(iOS 11.0, *) {

        } else {
            _removeObservers()
        }
    }
}
