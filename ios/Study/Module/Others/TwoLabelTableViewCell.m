//
//  TwoLabelTableViewCell.m
//  Study
//
//  Created by lanbao on 2018/7/3.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "TwoLabelTableViewCell.h"

@implementation TwoLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.leftLabel = [[UILabel alloc]init];
        self.rightLabel = [[UILabel alloc]init];
        self.leftLabel.layer.cornerRadius = 5;
        self.leftLabel.layer.borderColor = UIColor.orangeColor.CGColor;
        self.leftLabel.layer.borderWidth = 1;
        self.rightLabel.layer.cornerRadius = 5;
        self.rightLabel.layer.borderColor = UIColor.orangeColor.CGColor;
        self.rightLabel.layer.borderWidth = 1;
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.rightLabel];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(15);
            make.centerY.equalTo(self.leftLabel);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        }];
        
        [self.leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.leftLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.rightLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.rightLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
