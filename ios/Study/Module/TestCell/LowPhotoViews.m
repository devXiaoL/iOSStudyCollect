//
//  LowPhotoViews.m
//  Study
//
//  Created by mac on 2020/5/15.
//  Copyright © 2020 lanbao. All rights reserved.
//

#import "LowPhotoViews.h"

static NSInteger const kMARGIN = 9;
NSInteger const kMAX_COL_l = 3;
//一张图片的宽高
#define kSubView_W_l (([UIScreen mainScreen].bounds.size.width - (kMAX_COL_l+1)*kMARGIN) / kMAX_COL_l)

@implementation LowPhotoViews

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < kMAX_COL_l * kMAX_COL_l; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.tag = i;
            [self addSubview:imageView];
        }
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //最大的列数
    NSInteger maxCol = self.picUrls.count == 4 ? 2 : 3;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *subView = self.subviews[i];
        //计算在哪一列
        NSInteger col = i % maxCol;
        //计算在那一行
        NSInteger row = i / maxCol;
        
        subView.mj_x = col * (kSubView_W_l + kMARGIN);
        subView.mj_y = row * (kSubView_W_l + kMARGIN);
        subView.mj_size = CGSizeMake(kSubView_W_l, kSubView_W_l);
    }
}


+ (CGSize)sizeWithImageCount:(NSInteger)picCount{
    //如果是4张，2行2列
    //column 列
    //row 行
    //如果图片数量大于最大列数，则使用最大列数
    NSInteger col = (picCount >= kMAX_COL_l) ? kMAX_COL_l : picCount;
    if (picCount == 4) {
        col = 2;
    }
    
    NSInteger row = (picCount + col - 1) / col;
    
    CGFloat width = col * kSubView_W_l + (col - 1) * kMARGIN;
    CGFloat height = row * kSubView_W_l + (row - 1) * kMARGIN;
    
    return CGSizeMake(width, height);
}

- (void)setPicUrls:(NSArray *)picUrls{
    _picUrls = picUrls;
    [self renderImage];
}

- (void)renderImage {
    //先将所有的image隐藏
    for (int i = 0; i<self.subviews.count; i++) {
        self.subviews[i].hidden = YES;
    }
    for (int i = 0; i<self.picUrls.count; i++) {
        UIImageView *childView = self.subviews[i];
        childView.hidden = NO;
        childView.layer.cornerRadius = kSubView_W_l / 2.0;
        childView.layer.masksToBounds = YES;
        [childView sd_setImageWithURL:[NSURL URLWithString:self.picUrls[i]]];
    }
}


@end
