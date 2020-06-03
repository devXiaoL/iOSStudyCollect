//
//  iOS11NewFeatureVC.m
//  StudyDemo
//
//  Created by lanbao on 2018/1/29.
//  Copyright © 2018年 Lang. All rights reserved.
//

#import "iOS11NewFeatureVC.h"

@interface iOS11NewFeatureVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation iOS11NewFeatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"LargeTitle";
    
    if (@available(iOS 11.0, *)) {
        self.tableView.separatorInsetReference = UITableViewSeparatorInsetFromAutomaticInsets;
    } else {
        // Fallback on earlier versions
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //导航栏大标题
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        
    }
    //iOS11 UINavgationController 自带 UISearchController
    [self setupSearchController];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    } else {
        
    }
}

- (void)setupSearchController{
    
    UISearchController *searchVC = [[UISearchController alloc]initWithSearchResultsController:nil];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = searchVC;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row %zd",indexPath.row];
    
    return cell;
}

@end
