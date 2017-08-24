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
    
    /// 控件是否处于刷新状态
    public private(set) var isRefreshing: Bool = false
    //{ return self.state == .refreshing || self.state == .willRefresh }

    /// 回调对象和回调函数
    fileprivate var _target: Any?
    fileprivate var _action: Selector?
    
    /// 回调闭包
    public var refreshHandler: ZVRefreshHandler?
    public var beginRefreshingCompletionHandler: ZVBeginRefreshingCompletionHandler?
    public var endRefreshingCompletionHandler: ZVEndRefreshingCompletionHandler?

    /// 父视图
    internal var scrollView: UIScrollView?
    
    /// 初始ScrollView.UIEdgeInsets
    internal var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    
    /// ScrollView.UIPanGestureRecognizer
    fileprivate var _panGestureRecognizer: UIPanGestureRecognizer?
    
    // MARK: - 初始化方法
    
    /// 初始化方法
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /// 初始化方法
    ///
    /// - Parameter refreshHandler: 回调闭包
    public convenience init(refreshHandler: @escaping ZVRefreshHandler) {
        self.init(frame: .zero)
        self.refreshHandler = refreshHandler
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - target: 回调对象
    ///   - action: 回调函数
    public convenience init(target: Any, action: Selector) {
        self.init(frame: .zero)
        self._target = target
        self._action = action
    }
    
    /// 初始化方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    /// 初始化方法
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepare()
    }
    
    // MARK: - Getter & Setter
    
    /// 刷新状态
    open var refreshState: State {
        get {
            let value = objc_getAssociatedObject(self, &AssocaiationKey.state) as? String
            return State.mapState(with: value)
        }
        set {
            if self.checkState(newValue).result { return }
            self.isRefreshing = newValue == .refreshing
            self.sendActions(for: .valueChanged)
            objc_setAssociatedObject(self, &AssocaiationKey.state, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 检查RefreshState.newValue 是否和 RefreshState.oldState 相同
    public func checkState(_ state: State) -> (result: Bool, oldState: State) {
        let oldState = self.refreshState
        if oldState == state { return (true, oldState) }
        return (false, oldState)
    }
    
    /// 根据拖拽比例更改透明度
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
    
    /// 拖拽百分比
    open var pullingPercent: CGFloat = 0.0 {
        didSet {
            guard self.isRefreshing == false else { return }
            if self.isAutomaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }
    
    /// 设置RefreshComponent子控件颜色
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
        }
    }

    //MARK: - 重写类方法
    
    open override func layoutSubviews() {
        self.placeSubViews()
        super.layoutSubviews()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let superview = newSuperview as? UIScrollView else { return }
        
        // 当添加到视图时
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
}

// MARK: - 组件初始化
extension ZVRefreshComponent {
    
    /// 初始化控件
    open func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
    }
    
    /// 放置控件，设置控件位置
    open func placeSubViews() {}
}

// MARK: - 状态控制

extension ZVRefreshComponent {
    
    /// 开始进入刷新状体
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
    
    /// 结束刷新状态
    public func endRefreshing() {
        self.refreshState = .idle
    }
    
    public func endRefreshing(with completionHandler: @escaping () -> ()) {
        self.endRefreshingCompletionHandler = completionHandler
        self.endRefreshing()
    }

    /// 设置回调事件和回调函数
    public func addTarget(_ target: Any?, action: Selector) {
        self._target = target
        self._action = action
    }
    
    /// 触发刷新回调
    internal func executeRefreshCallback() {
        DispatchQueue.main.async {
            // 执行刷新回调闭包
            self.refreshHandler?()
            // 执行刷新回调函数
            if let target = self._target, let action = self._action {
                if (target as AnyObject).responds(to: action) {
                    DispatchQueue.main.async(execute: {
                        Thread.detachNewThreadSelector(action, toTarget: target, with: self)
                    })
                }
            }
            // 执行完成刷新回调闭包
            self.beginRefreshingCompletionHandler?()
        }
    }
}

// MARK: - 属性监听

extension ZVRefreshComponent {
    
    /// 添加属性监听
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
    
    /// 移除属性监听
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

    /// 监听UIScrollView.contentOffset 变化时调用
    /// 子类实现
    open func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
    
    /// 监听UIScrollView.contentSize 变化时调用
    /// 子类实现
    open func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
    
    /// 监听UIScrollView.panGestureRecognizer.state 变化时调用
    /// 子类实现
    open func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
}
