//
//  ZRefreshComponent.swift
//
//  Created by ZhangZZZZ on 16/3/29.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshComponent: UIControl {
    
    public enum State: String {
        
        case idle        = "idle"
        case pulling     = "pulling"
        case willRefresh = "willRefresh"
        case refreshing  = "refreshing"
        case noMoreData  = "noMoreData"
        
        static func mapState(with stateString: String?) -> State {
            
            guard let value = stateString else { return .idle }
            switch value {
            case "idle":
                return .idle
            case "pulling":
                return .pulling
            case "willRefresh":
                return .willRefresh
            case "refreshing":
                return .refreshing
            case "noMoreData":
                return .noMoreData
            default:
                return .idle
            }
        }
    }

    private struct AssocaiationKey {
        static var state = "com.zevwings.assocaiationkey.state"
    }

    private struct OnceToken {
        static var tableView = "com.zevwings.once.table.excute"
        static var collectionView = "com.zevwings.once.collection.excute"
    }
    
    public private(set) var isRefreshing: Bool = false
    //{ return self.state == .refreshing || self.state == .willRefresh }

    /// callback target object
    fileprivate var _target: Any?
    
    /// callback target selector
    fileprivate var _action: Selector?
    
    /// callback closure
    public var refreshHandler: ZVRefreshHandler?
    public var beginRefreshingCompletionHandler: ZVBeginRefreshingCompletionHandler?
    public var endRefreshingCompletionHandler: ZVEndRefreshingCompletionHandler?

    /// superview
    internal var scrollView: UIScrollView?
    
    internal var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    
    /// ScrollView.UIPanGestureRecognizer
    fileprivate var _panGestureRecognizer: UIPanGestureRecognizer?
    
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
        self.refreshHandler = refreshHandler
    }
    
    /// Init with callback target and selector
    ///
    /// - Parameters:
    ///   - target: callback target
    ///   - action: callback selector
    public convenience init(target: Any, action: Selector) {
        self.init(frame: .zero)
        self._target = target
        self._action = action
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepare()
    }
    
    open override func layoutSubviews() {
        self.placeSubViews()
        super.layoutSubviews()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let superview = newSuperview as? UIScrollView else { return }
        
        if superview.isKind(of: UITableView.self) {
            DispatchQueue.once(token: OnceToken.collectionView, block: {
                UITableView.once()
            })
        } else if superview.isKind(of: UICollectionView.self) {
            DispatchQueue.once(token: OnceToken.collectionView, block: { 
                UICollectionView.once()
            })
        }
        
        self._removeObservers()
        
        self.x = 0
        self.width = superview.width
        self.backgroundColor = superview.backgroundColor

        self.scrollView = superview
        self.scrollView?.alwaysBounceVertical = true
        self.scrollViewOriginalInset = superview.contentInset

        self._addObservers()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.refreshState == .willRefresh { self.refreshState = .refreshing }
    }
    
    // MARK: - Getter & Setter
    
    open var refreshState: State {
        get {
            let value = objc_getAssociatedObject(self, &AssocaiationKey.state) as? String
            return State.mapState(with: value)
        }
        set {
            
            if self.checkState(newValue).result { return }
            
            self.willChangeValue(forKey: "isRefreshing")
            self.isRefreshing = newValue == .refreshing
            self.didChangeValue(forKey: "isRefreshing")
            self.sendActions(for: .valueChanged)
            
            objc_setAssociatedObject(self, &AssocaiationKey.state, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// check RefreshState.newValue is equal to RefreshState.oldState
    /// if the two value is not equal, update state label value.
    public func checkState(_ state: State) -> (result: Bool, oldState: State) {
        let oldState = self.refreshState
        if oldState == state { return (true, oldState) }
        return (false, oldState)
    }
    
    public var isAutomaticallyChangeAlpha: Bool = true {
        didSet {
            guard self.isRefreshing == false else { return }
            
            if self.isAutomaticallyChangeAlpha {
                self.alpha = self.pullingPercent
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    open var pullingPercent: CGFloat = 0.0 {
        didSet {
            guard self.isRefreshing == false else { return }
            if self.isAutomaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
        }
    }
}

// MARK: - SubViews

extension ZVRefreshComponent {
    
    /// Add SubViews
    @objc open func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
    }
    
    /// Place SubViews
    @objc open func placeSubViews() {}
}

// MARK: -

// MARK: Update Refresh State
extension ZVRefreshComponent {
    
    // MARK: Begin Refresh
    public func beginRefreshing() {
        
        UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
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
    
    public func beginRefreshing(with completionHandler: @escaping () -> ()) {
        self.beginRefreshingCompletionHandler = completionHandler
        self.beginRefreshing()
    }
    
    // MARK: End Refresh
    @objc public func endRefreshing() {
        self.refreshState = .idle
    }
    
    public func endRefreshing(with completionHandler: @escaping () -> ()) {
        self.endRefreshingCompletionHandler = completionHandler
        self.endRefreshing()
    }

    /// Add callback target and selector
    public func addTarget(_ target: Any?, action: Selector) {
        self._target = target
        self._action = action
    }
    
    internal func executeRefreshCallback() {
        DispatchQueue.main.async {
        
            self.refreshHandler?()
            
            if let target = self._target, let action = self._action {
                if (target as AnyObject).responds(to: action) {
                    DispatchQueue.main.async(execute: {
                        Thread.detachNewThreadSelector(action, toTarget: target, with: self)
                    })
                }
            }
            
            self.beginRefreshingCompletionHandler?()
        }
    }
}

// MARK: - Observers

extension ZVRefreshComponent {
    
    fileprivate func _addObservers() {
        
        let options: NSKeyValueObservingOptions = [.new, .old]
        
        self.scrollView?.addObserver(self,
                                     forKeyPath: Config.KeyPath.contentOffset,
                                     options: options, context: nil)
        self.scrollView?.addObserver(self,
                                     forKeyPath: Config.KeyPath.contentSize,
                                     options: options, context: nil)
        self._panGestureRecognizer = self.scrollView?.panGestureRecognizer
        self._panGestureRecognizer?.addObserver(self,
                                                forKeyPath: Config.KeyPath.panState,
                                                options: options, context: nil)
    }
    
    fileprivate func _removeObservers() {
        
        self.scrollView?.removeObserver(self, forKeyPath: Config.KeyPath.contentOffset)
        self.scrollView?.removeObserver(self, forKeyPath: Config.KeyPath.contentSize)
        self.scrollView?.removeObserver(self, forKeyPath: Config.KeyPath.panState)
        self._panGestureRecognizer = nil
    }
    
    override open func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {

        guard self.isUserInteractionEnabled else { return }

        if keyPath == Config.KeyPath.contentSize {
            self.scrollViewContentSizeDidChanged(change)
        }

        guard self.isHidden == false else { return }

        if keyPath == Config.KeyPath.contentOffset {
            self.scrollViewContentOffsetDidChanged(change)
        } else if keyPath == Config.KeyPath.panState {
            self.scrollViewPanStateDidChanged(change)
        }
    }

    /// Call this selector when UIScrollView.contentOffset value changed
    @objc open func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
    
    /// Call this selector when UIScrollView.contentSize value changed
    @objc open func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
    
    /// Call this selector when UIScrollView.panGestureRecognizer.state value changed
    @objc open func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
}
