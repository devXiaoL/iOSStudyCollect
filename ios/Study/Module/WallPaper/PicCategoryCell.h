//
//  PicCategoryCell.h
//  Study
//
//  Created by lanbao on 2018/2/2.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCategoryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (nonatomic, copy) NSString *imageUrl;

@end
