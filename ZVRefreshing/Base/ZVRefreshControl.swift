//
//  ZRefreshComponent.swift
//
//  Created by zevwings on 16/3/29.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshControl: UIControl {
    
    public enum RefreshState {
        case idle
        case pulling
        case willRefresh
        case refreshing
        case noMoreData
    }

    // MARK: - Open

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
        }
    }

    open var pullingPercent: CGFloat = 0.0 {
        didSet {
            guard isRefreshing == false else { return }
            if isAutomaticallyChangeAlpha { alpha = pullingPercent }
        }
    }

    // MARK: - Public
    
    public private(set) var isRefreshing: Bool = false

    public private(set) weak var scrollView: UIScrollView?
    public private(set) weak var pan: UIPanGestureRecognizer?

    public var defaultContentInset: UIEdgeInsets = UIEdgeInsets.zero

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

    // MARK: Private
    
    private weak var target: AnyObject?
    private var action: Selector?

    private var isObserved: Bool = false
    private var offsetObservation: NSKeyValueObservation?
    private var insetsObservation: NSKeyValueObservation?
    private var contentSizeObservation: NSKeyValueObservation?
    private var panStateObservation: NSKeyValueObservation?

    private var refreshHandler: ZVRefreshHandler?

    // MARK: - Init
    
    deinit {
        print("...")
        removeScrollViewObservers()
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
        _ state: ZVRefreshControl.RefreshState,
        oldState: ZVRefreshControl.RefreshState
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

extension ZVRefreshControl {
    
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

        removeScrollViewObservers()

        guard let scrollView = newSuperview as? UIScrollView else { return }
        
        frame.origin.x = 0
        frame.size.width = scrollView.frame.width
        backgroundColor = scrollView.backgroundColor
        defaultContentInset = scrollView.contentInset

        self.scrollView = scrollView
        self.scrollView?.alwaysBounceVertical = true

        addScrollViewObservers()
    }
}

// MARK: - Observers

extension ZVRefreshControl {

    func addScrollViewObservers() {
        
        let options: NSKeyValueObservingOptions = [.new, .old]

        guard let scrollView = scrollView, !isObserved else { return }

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

        isObserved = true
    }
    
    func removeScrollViewObservers() {

        guard scrollView != nil, isObserved else { return }

        offsetObservation = nil
        contentSizeObservation = nil
        insetsObservation = nil
        panStateObservation = nil
        pan = nil

        isObserved = false
    }
}

// MARK: - Public

public extension ZVRefreshControl {

    func beginRefreshing() {
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

    func endRefreshing() {
        // make sure code excute in main queue.
        DispatchQueue.main.async {
            self.refreshState = .idle
        }
    }

    func addHander(_ refreshHandler: @escaping ZVRefreshHandler) {
        self.refreshHandler = refreshHandler
    }

    func addTarget(_ target: Any, action: Selector) {
        self.target = target as AnyObject
        self.action = action
    }
}

// MARK: - Internal

extension ZVRefreshControl {
    
    func executeRefreshCallback() {
        DispatchQueue.main.async {
            self.refreshHandler?()
            if let target = self.target, let action = self.action, target.responds(to: action) {
                _ = target.perform(action, with: self)
            }
        }
    }
}
