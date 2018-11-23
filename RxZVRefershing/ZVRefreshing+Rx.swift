//
//  ZVRefreshing+Rx.swift
//  ADJAddress
//
//  Created by 张伟 on 2018/11/23.
//  Copyright © 2018 zevwings. All rights reserved.
//

import RxSwift
import RxCocoa

#if !COCOAPODS
import ZVRefreshing
#endif

extension Reactive where Base: ZVRefreshComponent {
    
    /// Reactive wrapper for `ValueChanged` control event.
    /// Call it when `isRefreshing` == true
    public var refresh: Observable<Bool> {
        return controlEvent(.valueChanged)
            .map { self.base.isRefreshing }
            .filter { $0 == true }
    }
    
    /// Bindable sink for `beginRefreshing()`, `endRefreshing()` methods.
    public var isRefreshing: Binder<Bool> {
        return Binder(self.base) { refreshControl, refresh in
            if refresh {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }

}
