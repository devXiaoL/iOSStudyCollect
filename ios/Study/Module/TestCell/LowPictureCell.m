//
//  LowPictureCell.m
//  Study
//
//  Created by mac on 2020/5/15.
//  Copyright © 2020 lanbao. All rights reserved.
//

#import "LowPictureCell.h"
#import "LowPhotoViews.h"
#import "LowPhotoViews.h"

#define kColumnNum 3

@interface LowPictureCell()

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)LowPhotoViews *photoViews;

@end


@implementation LowPictureCell


+(instancetype)cellWithTableView:(UITableView *)tableView{
    LowPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photosCell"];
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

- (void)setPictures:(NSArray *)pictures{
    _pictures = pictures;
    
    self.photoViews.picUrls = pictures;
    CGSize size = [LowPhotoViews sizeWithImageCount:pictures.count];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - size.width)/2 ;
    CGFloat y = 10;
    self.photoViews.frame = CGRectMake(x, y, size.width, size.height);
}

- (LowPhotoViews *)photoViews{
    if (!_photoViews) {
        _photoViews = [[LowPhotoViews alloc]init];
    }
    return _photoViews;
}

@end
