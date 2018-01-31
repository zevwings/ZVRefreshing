//
//  ZRefreshComponent.swift
//
//  Created by ZhangZZZZ on 16/3/29.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshComponent: UIControl {
    
    public enum State {
        case idle
        case pulling
        case willRefresh
        case refreshing
        case noMoreData
    }
    
    public private(set) var isRefreshing: Bool = false

    /// callback target object
    private var _target: Any?
    
    /// callback target selector
    private var _action: Selector?
    
    /// callback closure
    
    private var _refreshHandler: ZVRefreshHandler?
    
    public var beginRefreshingCompletionHandler: ZVBeginRefreshingCompletionHandler?
    public var endRefreshingCompletionHandler: ZVEndRefreshingCompletionHandler?

    /// superview
    internal var scrollView: UIScrollView?
    
    internal var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    
    /// ScrollView.UIPanGestureRecognizer
    private var _panGestureRecognizer: UIPanGestureRecognizer?
    
    /// 刷新状态
    private var _refreshState: State = .idle
    
    // MARK: - Init
    
    /// Init
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /// Init with callback closure
    ///
    /// - Parameter refreshHandler: callback closure
    public convenience init(refreshHandler: @escaping ZVRefreshHandler) {
        self.init(frame: .zero)
        _refreshHandler = refreshHandler
    }
    
    /// Init with callback target and selector
    ///
    /// - Parameters:
    ///   - target: callback target
    ///   - action: callback selector
    public convenience init(target: Any, action: Selector) {
        self.init(frame: .zero)
        _target = target
        _action = action
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    // MARK: Subviews
    
    /// Add SubViews
    open func prepare() {
        autoresizingMask = .flexibleWidth
        backgroundColor = .clear
    }
    
    /// Place SubViews
    open func placeSubViews() {}
    
    // MARK: Superview Observers
    /// Call this selector when UIScrollView.contentOffset value changed
    open func scrollView(_ scrollView: UIScrollView, contentOffsetDidChanged value: [NSKeyValueChangeKey: Any]?) {}
    
    /// Call this selector when UIScrollView.contentSize value changed
    open func scrollView(_ scrollView: UIScrollView, contentSizeDidChanged value: [NSKeyValueChangeKey: Any]?) {}
    
    /// Call this selector when UIScrollView.panGestureRecognizer.state value changed
    open func panGestureRecognizer(_ panGestureRecognizer: UIPanGestureRecognizer, stateValueChanged value: [NSKeyValueChangeKey: Any]?, for scrollView: UIScrollView) {}
    
    
    // MARK: Getter & Setter
    open var refreshState: State {
        get {
            return _refreshState
        }
        set {
            setRefreshState(newValue)
        }
    }
    
    public var isAutomaticallyChangeAlpha: Bool = true {
        didSet {
            guard isRefreshing == false else { return }
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
    
    public var refreshHandler: ZVRefreshHandler? {
        get {
            return _refreshHandler
        }
        set {
            _refreshHandler = newValue
        }
    }
}

// MARK: - Override

extension ZVRefreshComponent {
    
    override open func layoutSubviews() {
        placeSubViews()
        super.layoutSubviews()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if refreshState == .willRefresh {
            refreshState = .refreshing
        }
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let superview = newSuperview as? UIScrollView else { return }
        
        if superview.isKind(of: UITableView.self) {
            UITableView.once
        } else if superview.isKind(of: UICollectionView.self) {
            UICollectionView.once
        }
        
        _removeObservers()
        
        frame.origin.x = 0
        frame.size.width = superview.frame.size.width
        backgroundColor = superview.backgroundColor
        
        scrollView = superview
        scrollView?.alwaysBounceVertical = true
        scrollViewOriginalInset = superview.contentInset
        
        _addObservers()
    }
}

// MARK: - Update Refresh State

extension ZVRefreshComponent {
    
    // MARK: Begin Refresh
    public func beginRefreshing() {
        
        UIView.animate(withDuration: AnimationDuration.fast, animations: {
            self.alpha = 1.0
        })
        
        pullingPercent = 1.0
        
        if window != nil {
            refreshState = .refreshing
        } else {
            if refreshState != .refreshing {
                refreshState = .willRefresh
                setNeedsDisplay()
            }
        }
    }
    
    public func beginRefreshing(with completionHandler: @escaping () -> ()) {
        beginRefreshingCompletionHandler = completionHandler
        beginRefreshing()
    }
    
    // MARK: End Refresh
    public func endRefreshing() {
        refreshState = .idle
    }
    
    public func endRefreshing(with completionHandler: @escaping () -> ()) {
        endRefreshingCompletionHandler = completionHandler
        endRefreshing()
    }
}

// MARK: - Observers

extension ZVRefreshComponent {
    
    private struct ObserversKeyPath {
        static let contentOffset = "contentOffset"
        static let contentInset  = "contentInset"
        static let contentSize   = "contentSize"
        static let panState      = "state"
    }

    private func _addObservers() {
        
        let options: NSKeyValueObservingOptions = [.new, .old]
        
        _panGestureRecognizer = scrollView?.panGestureRecognizer
        _panGestureRecognizer?.addObserver(self, forKeyPath: ObserversKeyPath.panState, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: ObserversKeyPath.contentOffset, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: ObserversKeyPath.contentSize, options: options, context: nil)
    }
    
    private func _removeObservers() {
        
        scrollView?.removeObserver(self, forKeyPath: ObserversKeyPath.contentOffset)
        scrollView?.removeObserver(self, forKeyPath: ObserversKeyPath.contentSize)
        scrollView?.removeObserver(self, forKeyPath: ObserversKeyPath.panState)
        _panGestureRecognizer = nil
    }
    
    override open func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {

        guard isUserInteractionEnabled else { return }

        guard let superScrollView = scrollView else { return }
        
        if keyPath == ObserversKeyPath.contentSize {
            scrollView(superScrollView, contentSizeDidChanged: change)
        }

        guard isHidden == false else { return }

        if keyPath == ObserversKeyPath.contentOffset {
            scrollView(superScrollView, contentOffsetDidChanged: change)
        } else if keyPath == ObserversKeyPath.panState {
            panGestureRecognizer(superScrollView.panGestureRecognizer, stateValueChanged: change, for: superScrollView)
        }
    }
}

// MARK: - Public

public extension ZVRefreshComponent {
    
    /// check RefreshState.newValue is equal to RefreshState.oldState
    /// if the two value is not equal, update state label value.
    public func checkState(_ state: State) -> (result: Bool, oldState: State) {
        let oldState = refreshState
        if oldState == state { return (true, oldState) }
        return (false, oldState)
    }
    
    /// Add callback target and selector
    public func addTarget(_ target: Any?, action: Selector) {
        _target = target
        _action = action
    }
}

// MARK: - Internal

extension ZVRefreshComponent {
    
    internal func executeRefreshCallback() {
        
        DispatchQueue.main.async {
            self._refreshHandler?()
            if let target = self._target, let action = self._action {
                if (target as AnyObject).responds(to: action) {
                    Thread.detachNewThreadSelector(action, toTarget: target, with: self)
                }
            }
            self.beginRefreshingCompletionHandler?()
        }
    }
}

// MARK: - Private

private extension ZVRefreshComponent {
    
    func setRefreshState(_ newValue: State) {
        
        guard checkState(newValue).result == false else { return }
        
        willChangeValue(forKey: "isRefreshing")
        isRefreshing = newValue == .refreshing
        didChangeValue(forKey: "isRefreshing")
        sendActions(for: .valueChanged)
        
        _refreshState = newValue
    }
}
