//
//  DynamicHeightCell.h
//  Study
//
//  Created by lanbao on 2018/6/27.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicHeightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)addBottomView:(UIView *)view;
- (void)removeBottomView;

@end
