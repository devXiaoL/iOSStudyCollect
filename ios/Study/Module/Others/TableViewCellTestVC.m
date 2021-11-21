//
//  TableViewCellTestVC.m
//  Study
//
//  Created by lanbao on 2018/6/27.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "TableViewCellTestVC.h"

#import "DynamicHeightCell.h"
#import "TwoLabelTableViewCell.h"

@interface TableViewCellTestVC () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, copy) NSArray *labelTitleArr;

@end

@implementation TableViewCellTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(DynamicHeightCell.class) bundle:nil] forCellReuseIdentifier:@"dCell"];
    [self.tableView registerClass:TwoLabelTableViewCell.class forCellReuseIdentifier:@"two"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.labelTitleArr.count;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TwoLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
        
        NSDictionary *titleDict = self.labelTitleArr[indexPath.row];
        cell.leftLabel.text = titleDict[@"left"];
        cell.rightLabel.text = titleDict[@"right"];
        
        cell.leftLabel.font = [UIFont systemFontOfSize:14];
        cell.rightLabel.font = [UIFont systemFontOfSize:14];
        
        return cell;
        
    } else {
        DynamicHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
        cell.titleLabel.text = [NSString stringWithFormat:@"%zd-%zd 点击后更改行高，增加附加视图",indexPath.section,indexPath.row];
        
        if (self.selectedIndexPath == indexPath) {
            UIView *view = [UIView new];
            view.backgroundColor = kMainColor;
            [cell addBottomView:view];
        }
        if (self.lastIndexPath == indexPath) {
            [cell removeBottomView];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return;
    }
    
    if (indexPath == self.selectedIndexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    self.lastIndexPath = self.selectedIndexPath;
    self.selectedIndexPath = indexPath;
    if (self.lastIndexPath) {
        [tableView reloadRowsAtIndexPaths:@[self.lastIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
        return 90;
    }
    return 45;
}


- (NSArray *)labelTitleArr {
    if (!_labelTitleArr) {
        _labelTitleArr = @[@{@"left":@"那轮月 照不亮刀锋和你闭月容颜",@"right":@"那一年 离不开沙场和你常随身边"},
                           @{@"left":@"那轮月",@"right":@"那一年"},
                           @{@"left":@"那轮月 照不亮刀锋和你闭月容颜",@"right":@"那一年"}];
        
    }
    return _labelTitleArr;
}


@end
