//
//  XLTabBarController.m
//  Study
//
//  Created by lanbao on 2018/2/1.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLTabBarController.h"
#import "XLNavigationController.h"

#import "ViewController.h"
#import "FeatureListVC.h"

@interface XLTabBarController ()

@end

@implementation XLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildVC:[ViewController new]
               title:@""
         normalImage:@"tabBar_home_normal"
       selectedImage:@"tabBar_home_press"];
    
    [self addChildVC:[FeatureListVC new]
               title:@"功能"
         normalImage:@"tabBar_category_normal"
       selectedImage:@"tabBar_category_press"];
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title normalImage:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kMainColor} forState:UIControlStateSelected];
    
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -8, 0);
//    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    XLNavigationController *nav = [[XLNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
