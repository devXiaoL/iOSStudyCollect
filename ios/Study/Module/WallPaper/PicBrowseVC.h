//
//  PicBrowseVC.h
//  StudyDemo
//
//  Created by Lang on 10/13/16.
//  Copyright © 2016 Lang. All rights reserved.
//


@protocol PicBrowseVCDelegate <NSObject>

- (void)scrollToItemAtIndex:(NSInteger)index;

@end


@interface PicBrowseVC : UIViewController

@property (nonatomic, copy) NSString *test;
@property (nonatomic, weak)id<PicBrowseVCDelegate> delegate;

+ (instancetype)showBrowseWithImageInfo:(NSArray *)info withCurrentIndex:(NSInteger)index;

- (instancetype)initWithImageInfo:(NSArray *)info withCurrentIndex:(NSInteger)index;

@end
