//
//  ZRefreshComponent.swift
//
//  Created by ZhangZZZZ on 16/3/29.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class RefreshComponent: UIView {
    
    private struct AssocaiationKey {
        static var state = "com.zevwings.assocaiationkey.state"
    }
    
    /// 控件是否处于刷新状态
    public var isRefreshing: Bool { return self.state == .refreshing || self.state == .willRefresh }
    
    /// 回调对象和回调函数
    fileprivate var _target: Any?
    fileprivate var _action: Selector?
    
    /// 回调闭包
    public var refreshHandler: RefreshHandler?
    public var beginRefreshingCompletionHandler: BeginRefreshingCompletionHandler?
    public var endRefreshingCompletionHandler: EndRefreshingCompletionHandler?

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
    public convenience init(refreshHandler: @escaping RefreshHandler) {
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
    internal var state: RefreshState {
        get {
            let value = objc_getAssociatedObject(self, &AssocaiationKey.state) as? String
            return RefreshState.mapState(with: value)
        }
        set {
            if self.checkState(newValue).result { return }
            objc_setAssociatedObject(self, &AssocaiationKey.state, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 检查RefreshState.newValue 是否和 RefreshState.oldState 相同
    internal func checkState(_ state: RefreshState) -> (result: Bool, oldState: RefreshState) {
        let oldState = self.state
        if oldState == state { return (true, oldState) }
        return (false, oldState)
    }
    
    /// 根据拖拽比例更改透明度
    internal var isAutomaticallyChangeAlpha: Bool = true {
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
    internal var pullingPercent: CGFloat = 0.0 {
        didSet {
            guard self.isRefreshing == false else { return }
            if self.isAutomaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }

    //MARK: - 重写类方法
    
    public override func layoutSubviews() {
        self.placeSubViews()
        super.layoutSubviews()
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let superview = newSuperview as? UIScrollView else { return }
        
        self._removeObservers()
        
        self.x = 0
        self.width = superview.width
        self.backgroundColor = superview.backgroundColor

        self.scrollView = superview
        self.scrollView?.alwaysBounceVertical = true
        self.scrollViewOriginalInset = superview.contentInset

        self._addObservers()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh { self.state = .refreshing }
    }
}

// MARK: - 组件初始化
extension RefreshComponent {
    
    /// 初始化控件
    internal func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = UIColor.clear
    }
    
    /// 放置控件，设置控件位置
    internal func placeSubViews() {}
}

// MARK: - 状态控制

extension RefreshComponent {
    
    /// 开始进入刷新状体
    public func beginRefreshing() {
        
        UIView.animate(withDuration: Config.AnimationDuration.fast, animations: {
            self.alpha = 1.0
        })
        
        self.pullingPercent = 1.0
        
        if self.window != nil {
            self.state = .refreshing
        } else {
            if self.state != .refreshing {
                self.state = .willRefresh
                self.setNeedsDisplay()
            }
        }
    }
    
    /// 结束刷新状态
    public func endRefreshing() {
        self.state = .idle
    }
    
    /// 触发刷新回调
    internal func executeRefreshCallback() {
        DispatchQueue.main.async {
            self.refreshHandler?()
            //            if self.target != nil && self.action != nil {
            //                if !self.target!.responds(to: self.action!) { return }
            //                self.target!.perform(self.action!, with: self)
            //            }
            self.beginRefreshingCompletionHandler?()
        }
    }
}

// MARK: - 属性监听

extension RefreshComponent {
    
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
    
    public override func observeValue(forKeyPath keyPath: String?,
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

    internal func scrollViewContentOffsetDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
    internal func scrollViewContentSizeDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
    internal func scrollViewPanStateDidChanged(_ change: [NSKeyValueChangeKey: Any]?) {}
}
