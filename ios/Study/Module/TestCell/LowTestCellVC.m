//
//  LowTestCellVC.m
//  Study
//
//  Created by mac on 2020/5/15.
//  Copyright © 2020 lanbao. All rights reserved.
//

#import "LowTestCellVC.h"
#import "LowPictureCell.h"
#import "LowPhotoViews.h"


@interface LowTestCellVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy)NSArray *pictures;

@end

@implementation LowTestCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self layoutPageSubViews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSArray *photos = self.pictures[indexPath.row];
    return [LowPhotoViews sizeWithImageCount:photos.count].height + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pictures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LowPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pictureCell"];
    
    if (!cell) {
        cell = [[LowPictureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pictureCell"];
    }
    cell.pictures = self.pictures[indexPath.row];
    return cell;
}

- (NSArray *)pictureUrls{
    NSArray *arr1 = @[@"http://img0.adesk.com/download/582e6fe094e5cc3ff33b2f83",
                      @"http://img0.adesk.com/download/582e6fd894e5cc3ff33b2f46",
                      @"http://img0.adesk.com/download/582e6faf94e5cc3ff33b2f06",
                      @"http://img0.adesk.com/download/582e6f9394e5cc3ff33b2ec7"];
    NSArray *arr2 = @[@"http://img0.adesk.com/download/582e615d94e5cc21ce340ab5",
                      @"http://img0.adesk.com/download/582daab994e5cc1802e20399",
                      @"http://img0.adesk.com/download/582daab194e5cc1802e2035f",
                      @"http://img0.adesk.com/download/582d8ea094e5cc5cb8549024",
                      @"http://img0.adesk.com/download/582d809494e5cc3de2695019",
                      @"http://img0.adesk.com/download/582e6fd894e5cc3ff33b2f46",
                      @"http://img0.adesk.com/download/582e6faf94e5cc3ff33b2f06",
                      @"http://img0.adesk.com/download/582e6f9394e5cc3ff33b2ec7"];
    NSArray *arr3 = @[@"http://img0.adesk.com/download/582d808594e5cc3de2694fa0",
                      @"http://img0.adesk.com/download/582d806694e5cc3de2694f25",
                      @"http://img0.adesk.com/download/582d7ceb94e5cc3632118f47",
                      @"http://img0.adesk.com/download/582d727994e5cc2052db4060",
                      @"http://img0.adesk.com/download/582d565594e5cc6381070671",
                      @"http://img0.adesk.com/download/582d564494e5cc63810705ef"];

    return @[arr1,arr2,arr3,arr2,arr3,arr1,arr3,arr1,arr2,arr3,arr2,arr1,arr1,arr2,arr3,arr2,arr3,arr1,arr3,arr1,arr2,arr3,arr2,arr1,arr1,arr2,arr3,arr2,arr3,arr1,arr3,arr1,arr2,arr3,arr2,arr1,arr1,arr2,arr3,arr2,arr3,arr1,arr3,arr1,arr2,arr3,arr2,arr1];
}


- (NSArray *)pictures{
    return [self pictureUrls];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor greenColor];
    }
    return _tableView;
}


- (void)layoutPageSubViews{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


@end
