//
//  XLRNBridgeManager.m
//  Study
//
//  Created by Lang on 2019/6/5.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import "XLRNBridgeManager.h"
//#import <React/RCTBundleURLProvider.h>

@implementation XLRNBridgeManager

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

+ (instancetype)sharedManager {
    static XLRNBridgeManager  *_bridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        _bridge = [[self alloc] initWithDelegate:[BridgeHandler new] launchOptions:nil];
    });
    return _bridge;
}
@end


@implementation BridgeHandler

//- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
//    return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
//}

@end
