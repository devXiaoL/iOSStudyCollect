//
//  FeatureListVC.m
//  Study
//
//  Created by lanbao on 2018/2/1.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "FeatureListVC.h"

#import <UIScrollView+EmptyDataSet.h>

#import "XLFeatureListModel.h"

@interface FeatureListVC ()<UITableViewDataSource,
                            UITableViewDelegate,
                            DZNEmptyDataSetSource,
                            DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIButton *testEmptyButton;

@property (nonatomic, copy) NSArray *listModels;
@property (nonatomic, assign)BOOL empty;

@end

@implementation FeatureListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.navigationItem.title = NSLocalizedString(@"featureNavTitle", nil);
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.testEmptyButton];
}

#pragma mark - tableView

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"DZN";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    XLFeatureListModel *model = self.listModels[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.detail;
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLFeatureListModel *model = self.listModels[indexPath.row];
    
    Class TargetClass = NSClassFromString(model.targetVC);
    
    UIViewController *targetVC = (UIViewController *)[[TargetClass alloc]init];
    targetVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:targetVC animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"action = 置顶, indexPatch = %@",indexPath);
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"action = 删除, indexPatch = %@",indexPath);
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    //从右往左依次排列
    return @[deleteAction,likeAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除操作
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:@"空白页面框架测试"];
    return attStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"luck"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIColor whiteColor];
}


#pragma mark - DZNEmptyDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self didClickEmptyTestBtn:self.testEmptyButton];
}

#pragma mark - action

- (void)didClickEmptyTestBtn:(UIButton *)btn{
    self.testEmptyButton.selected = !self.testEmptyButton.selected;
    self.empty = !self.empty;
    [self.tableView reloadData];
}

#pragma mark - getter

//添加一个测试空tableView的按钮

- (UIButton *)testEmptyButton{
    if (!_testEmptyButton) {
        _testEmptyButton = [[UIButton alloc]init];
        _testEmptyButton.frame = CGRectMake(self.view.mj_w - 130, 10, 100, 20);
        _testEmptyButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _testEmptyButton.alpha = 0.5;
        _testEmptyButton.backgroundColor = [UIColor orangeColor];
        [_testEmptyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_testEmptyButton setTitle:@"点击测试列表为空" forState:UIControlStateNormal];
        [_testEmptyButton setTitle:@"点击恢复列表数据" forState:UIControlStateSelected];
        [_testEmptyButton addTarget:self action:@selector(didClickEmptyTestBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testEmptyButton;
}

- (NSArray *)listModels{
    if (!_listModels) {
        _listModels = [XLFeatureListModel listModels];
    }
    return _listModels;
}

@end
