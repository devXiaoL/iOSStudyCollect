//
//  XLFlutterBoostDelegate.m
//  Study
//
//  Created by Lang on 2021/8/30.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "XLFlutterBoostDelegate.h"
#import "XLFlutterBoostVC.h"

@implementation XLFlutterBoostDelegate

- (void)pushFlutterRoute:(FlutterBoostRouteOptions *)options {
    XLFlutterBoostVC *vc = [XLFlutterBoostVC new];
    [vc setName:options.pageName uniqueId:options.uniqueId params:options.arguments opaque:options.opaque];
    
    //是否伴随动画
    BOOL animated = [options.arguments[@"animated"] boolValue];
    //是否是present的方式打开,如果要push的页面是透明的，那么也要以present形式打开
    BOOL present = [options.arguments[@"present"] boolValue] || !options.opaque;
    
    if(present){
        [[self cc_currentNav] presentViewController:vc animated:animated completion:^{
            options.completion(YES);
        }];
    }else{
        [[self cc_currentNav] pushViewController:vc animated:animated];
        options.completion(YES);
    }
}

- (void)popRoute:(FlutterBoostRouteOptions *)options {
    
}


- (void)pushNativeRoute:(NSString *)pageName arguments:(NSDictionary *)arguments {
    
}


- (UINavigationController *)cc_currentNav {
    
    UITabBarController *rootVc = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([rootVc isKindOfClass: [UINavigationController class]]) {
        return (UINavigationController *) rootVc;
    } else if ([rootVc isKindOfClass:[UITabBarController class]]) {
        NSInteger selectedControllerIndex = rootVc.selectedIndex;
        UINavigationController *navc = rootVc.viewControllers[selectedControllerIndex];
        return navc;
    } else {
        return nil;
    }
}

@end
