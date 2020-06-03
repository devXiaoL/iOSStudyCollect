//
//  DynamicHeightCell.m
//  Study
//
//  Created by lanbao on 2018/6/27.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "DynamicHeightCell.h"


@interface DynamicHeightCell ()
//固定的view
@property (weak, nonatomic) IBOutlet UIView *regularView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation DynamicHeightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)addBottomView:(UIView *)view {
    if (self.bottomView) {
        [self.bottomView removeFromSuperview];
    }
    self.bottomView = view;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.regularView.mas_bottom);
        make.left.bottom.right.equalTo(self.contentView);
    }];
}

- (void)removeBottomView {
    [self.bottomView removeFromSuperview];
}

@end
