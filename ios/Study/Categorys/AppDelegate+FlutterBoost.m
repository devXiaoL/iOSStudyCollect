//
//  AppDelegate+FlutterBoost.m
//  Study
//
//  Created by Lang on 2021/9/2.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "AppDelegate+FlutterBoost.h"
#import "XLFlutterBoostDelegate.h"

#import <FlutterBoost.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@implementation AppDelegate (FlutterBoost)

- (void)initFlutterBoostWithApplication:(UIApplication *)application {
    XLFlutterBoostDelegate *delegate = [XLFlutterBoostDelegate new];
    [[FlutterBoost instance] setup:application delegate:delegate callback:^(FlutterEngine *engine) {
//        [GeneratedPluginRegistrant registerWithRegistry:engine];
    }];
}

@end
