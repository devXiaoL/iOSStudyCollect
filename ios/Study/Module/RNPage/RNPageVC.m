//
//  RNPageVC.m
//  Study
//
//  Created by Lang on 2019/6/5.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import "RNPageVC.h"
#import "XLRNBridgeManager.h"
#import <React/RCTRootView.h>

@interface RNPageVC ()

@end

@implementation RNPageVC

- (void)loadView {
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[XLRNBridgeManager sharedManager] moduleName:@"RNPage" initialProperties:nil];
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
