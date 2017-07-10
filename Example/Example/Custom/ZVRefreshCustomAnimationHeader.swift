//
//  RefreshCustomAnimationHeader.swift
//  Example
//
//  Created by zevwings on 2017/7/9.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class RefreshCustomAnimationHeader: ZVRefreshAnimationHeader {

    override func prepare() {
        super.prepare()
        
        var idleImages: [UIImage] = []
        for index in 1 ... 60 {
            let name = "dropdown_anim__000\(index)"
            let img = UIImage(named: name)
            idleImages.append(img!)
        }
        self.setImages(idleImages, forState: .idle)
        
        // 设置正在刷新状态的动画图片
        var refreshingImages: [UIImage] = []
        for index in 1 ... 3 {
            let name = "dropdown_loading_0\(index)"
            let img = UIImage(named: name)
            refreshingImages.append(img!)
        }
        self.setImages(refreshingImages, forState: .pulling)
        self.setImages(refreshingImages, forState: .refreshing)
    }
}
