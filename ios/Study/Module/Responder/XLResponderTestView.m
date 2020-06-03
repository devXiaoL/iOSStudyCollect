//
//  XLResponderTestView.m
//  Study
//
//  Created by lanbao on 2018/2/22.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLResponderTestView.h"

@implementation XLResponderTestView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    BOOL inside = [self pointInside:point withEvent:event];
    NSLog(@"inside = %zd",inside);
    return inside ? self : nil;
}

@end
