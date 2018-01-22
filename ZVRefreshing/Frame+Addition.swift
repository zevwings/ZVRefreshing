//
//  Frame+Addition.swift
//  ZVRefreshing
//
//  Created by 张伟 on 22/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation


internal extension UIView {
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}

extension UIScrollView {
    
    var offsetY: CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            self.contentOffset.y = newValue
        }
    }
    
    var offsetX: CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            self.contentOffset.x = newValue
        }
    }
    
    var contentWidth: CGFloat {
        get {
            return self.contentSize.width
        }
        set {
            self.contentSize.width = newValue
        }
    }
    
    var contentHeight: CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            self.contentSize.height = newValue
        }
    }
    
    var insetTop: CGFloat {
        get {
            return self.contentInset.top
        }
        set {
            self.contentInset.top = newValue
        }
    }
    
    var insetBottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.bottom = newValue
        }
    }
    
    var insetLeft: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.left = newValue
        }
    }
    
    var insetRight: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.right = newValue
        }
    }
}
