//
//  LowPictureCell.h
//  Study
//
//  Created by mac on 2020/5/15.
//  Copyright © 2020 lanbao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LowPictureCell : UITableViewCell

@property (nonatomic, copy)NSArray *pictures;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
