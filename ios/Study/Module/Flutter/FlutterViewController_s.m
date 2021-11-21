//
//  FlutterViewController_s.m
//  Study
//
//  Created by Lang on 2021/8/29.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "FlutterViewController_s.h"

@interface FlutterViewController_s ()

@end

@implementation FlutterViewController_s

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
