//
//  PhotoViews.m
//  StudyDemo
//
//  Created by Lang on 11/19/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "PhotoViews.h"
#import "SDImageCache.h"
#import "UIImage+Until.h"

static NSInteger const kMARGIN = 9;
NSInteger const kMAX_COL = 3;
//一张图片的宽高
#define kSubView_W (([UIScreen mainScreen].bounds.size.width - (kMAX_COL+1)*kMARGIN) / kMAX_COL)

@interface PhotoViews ()


@end

@implementation PhotoViews

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < kMAX_COL * kMAX_COL; i++) {
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
        
        subView.mj_x = col * (kSubView_W + kMARGIN);
        subView.mj_y = row * (kSubView_W + kMARGIN);
        subView.mj_size = CGSizeMake(kSubView_W, kSubView_W);
    }
}


+ (CGSize)sizeWithImageCount:(NSInteger)picCount{
    //如果是4张，2行2列
    //column 列
    //row 行
    //如果图片数量大于最大列数，则使用最大列数
    NSInteger col = (picCount >= kMAX_COL) ? kMAX_COL : picCount;
    if (picCount == 4) {
        col = 2;
    }
    
    NSInteger row = (picCount + col - 1) / col;
    
    CGFloat width = col * kSubView_W + (col - 1) * kMARGIN;
    CGFloat height = row * kSubView_W + (row - 1) * kMARGIN;
    
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
    //        UIImage *placeholderImage = [tempImage cornerImageWithSize:childView.frame.size fillColor:[UIColor whiteColor]];
            UIImage *placeholderImage = nil;
            __weak typeof(childView)weakChildView = childView;
            
            
            NSString *cornerImageCachePath = [self.picUrls[i] stringByAppendingString:@"cornerImageCache"];
            // 从磁盘中取出绘制好的圆角image
            UIImage *cacheCornerImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cornerImageCachePath];
            
            if (cacheCornerImage) {
                childView.image = cacheCornerImage;
            }else{
                [childView sd_setImageWithURL:[NSURL URLWithString:self.picUrls[i]] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   
                    UIImage *cornerImage = [image roundImageWithSize:weakChildView.frame.size fillColor:[UIColor whiteColor]];
    //                UIImage *cornerImage = nil;
                    weakChildView.image = cornerImage;
                    //保存绘制好的圆角image
                    [[SDImageCache sharedImageCache] storeImage:cornerImage forKey:cornerImageCachePath completion:nil];
                    //清除没有绘制过圆角的image
                    [[SDImageCache sharedImageCache] removeImageForKey:self.picUrls[i] withCompletion:nil];
                }];
            }
        }
}

@end
