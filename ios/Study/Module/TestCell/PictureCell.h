//
//  PictureCell.h
//  StudyDemo
//
//  Created by Lang on 11/18/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCell : UITableViewCell

@property (nonatomic, copy)NSArray *pictures;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
