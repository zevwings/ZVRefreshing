//
//  UILabel+Addition.swift
//  ZVRefreshing
//
//  Created by 张伟 on 22/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

internal extension UILabel {
    
    func getTextWidth() -> CGFloat {
        
        let size = CGSize(width: Int.max, height: Int.max)
        guard let text = self.text else { return 0 }
        let textWidth = (text as NSString).boundingRect(with: size,
                                                        options: .usesLineFragmentOrigin,
                                                        attributes: [NSAttributedStringKey.font: self.font],
                                                        context: nil).size.width
        return textWidth
    }
}

internal extension UILabel {
    
    class var `default`: UILabel {
        let label = UILabel(frame: .zero)
        label.font = Component.font
        label.textColor = Component.tintColor
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
}
