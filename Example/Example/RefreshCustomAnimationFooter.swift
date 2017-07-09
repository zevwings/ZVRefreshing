//
//  RefreshCustomAnimationFooter.swift
//  Example
//
//  Created by zevwings on 2017/7/9.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class RefreshBackCustomAnimationFooter: RefreshBackStateFooter {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class RefreshAutoCustomAnimationFooter: RefreshAutoAnimationFooter {
    
    override func prepare() {
        super.prepare()
        // 设置正在刷新状态的动画图片
        var imgs: [UIImage] = []
        
        for index in 1 ... 3 {
            let name = "dropdown_loading_0\(index)"
            print(name)
            let img = UIImage(named: name)
            imgs.append(img!)
        }
        
        self.setImages(imgs, state: .refreshing)
//        NSMutableArray *refreshingImages = [NSMutableArray array];
//        for (NSUInteger i = 1; i<=3; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
//            [refreshingImages addObject:image];
//        }
//        [self setImages:refreshingImages forState:MJRefreshStateRefreshing];

    }
}
