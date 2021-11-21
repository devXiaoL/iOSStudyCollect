//
//  UIViewController+Hook.m
//  Study
//
//  Created by lang.li on 2021/10/17.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "UIViewController+Hook.h"

@implementation UIViewController (Hook)

+ (void)load {
    Class class = [self class];
    SEL originalSel = @selector(viewDidLoad);
    SEL swizzSel = @selector(hook_viewDidLoad);
    
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method swizzMethod = class_getInstanceMethod(class, swizzSel);
    
    BOOL success = class_addMethod(class, originalSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
    
    if (success) {
        class_replaceMethod(class, swizzSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzMethod);
    }
}

- (void)hook_viewDidLoad {
    NSLog(@"%s", __func__);
}

@end
