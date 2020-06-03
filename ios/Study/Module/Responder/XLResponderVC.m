//
//  XLResponderVC.m
//  Study
//
//  Created by lanbao on 2018/2/22.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLResponderVC.h"
#import "XLResponderTestView.h"

@interface XLResponderVC ()

@end

@implementation XLResponderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XLResponderTestView *testView = [[XLResponderTestView alloc]init];
    testView.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:testView];
    
    testView.frame = CGRectMake(150, 20, 100, 100);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
