//
//  FlutterDemo.m
//  Study
//
//  Created by Lang on 2021/8/28.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "FlutterDemo.h"
#import "AppDelegate.h"
#import "XLFlutterBoostVC.h"

@import Flutter;

@interface FlutterDemo ()

@end

@implementation FlutterDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(showFlutter)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show Flutter!" forState:UIControlStateNormal];
    button.backgroundColor = UIColor.blueColor;
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)showFlutter {
//    FlutterEngine *flutterEngine = ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
//    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
//    [self.navigationController presentViewController:flutterViewController animated:YES completion:nil];
    
    XLFlutterBoostVC *vc = [[XLFlutterBoostVC alloc] init];
    FlutterBoostRouteOptions* options = [[FlutterBoostRouteOptions alloc]init];
        options.pageName = @"homePage";
        options.arguments = @{@"animated":@(YES)};
        options.completion = ^(BOOL completion) {

        };

    [vc setName:options.pageName uniqueId:options.uniqueId params:options.arguments opaque:options.opaque];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
