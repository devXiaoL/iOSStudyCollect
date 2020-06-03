//
//  HomeViewController.m
//  Study
//
//  Created by lanbao on 2018/4/19.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setupNavgationBarButton {
//    UIImageView *menuImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu"]];
    // 设置导航左右角的按钮
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuBarButtonItemAction:)];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterBarButtonItemAction:)];
    
    self.navigationItem.leftBarButtonItem = menuItem;
    self.navigationItem.leftBarButtonItem = filterItem;
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
