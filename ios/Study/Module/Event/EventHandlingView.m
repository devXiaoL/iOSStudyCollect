//
//  EventHandlingView.m
//  Study
//
//  Created by Lang on 2019/5/12.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import "EventHandlingView.h"

@implementation EventHandlingView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    /*
     当向UIWindow发送hitTest:withEvent:消息时，hitTest:withEvent:里面所做的事，就是判断当前的点击位置是否在window里面，如果在则遍历window的subview然后依次对subview发送hitTest:withEvent:消息(注意这里给subview发送消息是根据当前subview的index顺序，index越大就越先被访问)。如果当前的point没有在view上面，那么这个view的subview也就不会被遍历了。

     */
    // 1. 判断能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) {
        return nil;
    }
    // 2. 判断点击区域
    if ([self pointInside:point withEvent:event] == NO) {
        return nil;
    }
    // 3. 遍历子控件(从subviews 最后的元素开始遍历)
    for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
        CGPoint subViewPoint = [self convertPoint:point toView:subView];
        UIView *fitView = [subView hitTest:subViewPoint withEvent:event];
        if (fitView) {
            return fitView;
        }
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"tag = %zd",self.tag);
    BOOL inside = [super pointInside:point withEvent:event];
    CGFloat r = 75;
    return inside && ((powf(point.x - 75, 2.0) + powf(point.y - 75, 2.0)) <= powf(r, 2.0));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"EventHandlingView tag = %zd",self.tag);
}

@end
