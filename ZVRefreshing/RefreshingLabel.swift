//
//  RefreshLabel.swift
//  ZRefreshing
//
//  Created by zevwings on 2017/7/5.
//  Copyright © 2017年 ZhangZZZZ. All rights reserved.
//

import UIKit

internal class RefreshingLabel: UILabel {

    internal init() {
        super.init(frame: CGRect.zero)
        self.font = Component.font
        self.textColor = Component.tintColor
        self.autoresizingMask = .flexibleWidth
        self.textAlignment = .center
        self.backgroundColor = UIColor.clear
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
