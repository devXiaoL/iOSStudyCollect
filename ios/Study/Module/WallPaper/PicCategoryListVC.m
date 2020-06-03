//
//  PicCategoryListVC.m
//  Study
//
//  Created by lanbao on 2018/2/2.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "PicCategoryListVC.h"

#import "PicCategoryCell.h"

#import "XLNetRequest.h"

#import "PicCategoryListModel.h"

@interface PicCategoryListVC ()<UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *categoryArr;

@end

@implementation PicCategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    
    [self requestPicCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.categoryArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PicCategoryListModel *model = self.categoryArr[indexPath.item];
    
    PicCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.numLabel.text = model.imgs;
    cell.titleLabel.text = model.name;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    
    return cell;
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 1, 0, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = kScreenWidth/2.0 - 2;
    return CGSizeMake(w, w);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (void)requestPicCategory{
    
    XLNetRequest *request = [[XLNetRequest alloc]init];
    NSString *url = @"http://service.store.dandanjiang.tv/v1/wallpaper/category?height=2208&sys_language=zh-Hans-CN&width=1242";
    
    [request getWithUrl:url withParams:nil success:^(id data) {
        self.categoryArr = [PicCategoryListModel mj_objectArrayWithKeyValuesArray:data[@"res"][@"data"]];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}

@end
