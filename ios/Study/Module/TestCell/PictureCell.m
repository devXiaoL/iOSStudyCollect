//
//  PictureCell.m
//  StudyDemo
//
//  Created by Lang on 11/18/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "PictureCell.h"
#import "PhotoViews.h"

#define kColumnNum 3

@interface PictureCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)PhotoViews *photoViews;

@end


@implementation PictureCell


+(instancetype)cellWithTableView:(UITableView *)tableView{
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photosCell"];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        [self addSubview:self.collectionView];
//        [self layoutPageSubViews];
        
        self.backgroundColor = [UIColor whiteColor];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.photoViews];

    }
    
    return self;
}

/*


#pragma mark - UICollectionView Delegate && DataSource



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    NSInteger tag = 10;
    UIImageView *imageView = [cell viewWithTag:tag];
    if (!imageView) {
        imageView = [[UIImageView alloc]init];
        imageView.tag = tag;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.pictures[indexPath.item]]];
    }
    
    return cell;
}

#pragma mark - getter && setter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (ScreenW - 10*(kColumnNum + 1))/kColumnNum;
//        CGFloat width = ScreenW / kColumnNum;
        CGFloat height = width;
//        layout.itemSize = CGSizeMake(width, height);
        //最小列间距
        layout.minimumInteritemSpacing = 10;
        //最小行间距
        layout.minimumLineSpacing = 10;
        layout.estimatedItemSize = CGSizeMake(width, height);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionView"];

    }
    return _collectionView;
}
 
- (void)layoutPageSubViews{
 [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
 }];
}
 

*/

- (void)setPictures:(NSArray *)pictures{
    _pictures = pictures;
    
    self.photoViews.picUrls = pictures;
    CGSize size = [PhotoViews sizeWithImageCount:pictures.count];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - size.width)/2 ;
    CGFloat y = 10;
    self.photoViews.frame = CGRectMake(x, y, size.width, size.height);
}

- (PhotoViews *)photoViews{
    if (!_photoViews) {
        _photoViews = [[PhotoViews alloc]init];
    }
    return _photoViews;
}

@end
