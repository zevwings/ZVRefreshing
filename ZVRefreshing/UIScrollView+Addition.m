//
//  UIScrollView+Addition.m
//  ZVRefreshing
//
//  Created by zevwings on 2020/1/7.
//  Copyright © 2020 zevwings. All rights reserved.
//

#import "UIScrollView+Addition.h"
#import <objc/runtime.h>
//#import "ZVRefreshing-Swift.h"
//#import "ZVRefreshing.h"

@implementation UIScrollView (Addition)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(ex_dealloc)));

}

- (void)ex_dealloc {

    NSLog(@"pring xxx");
    [self ex_dealloc];
}

@end
