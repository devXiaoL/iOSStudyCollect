//
//  XLBaseViewController.m
//  Study
//
//  Created by lanbao on 2018/2/1.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLBaseViewController.h"

@interface XLBaseViewController ()

@end

@implementation XLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
