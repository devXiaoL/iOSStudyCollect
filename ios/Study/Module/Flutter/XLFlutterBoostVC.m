//
//  XLFlutterBoostVC.m
//  Study
//
//  Created by Lang on 2021/9/2.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "XLFlutterBoostVC.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface XLFlutterBoostVC ()<UIGestureRecognizerDelegate>

@end

@implementation XLFlutterBoostVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return YES;
//}

@end
