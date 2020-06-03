//
//  WaveView.h
//  KYJ_RentCircle
//
//  Created by lilang on 16/7/7.
//  Copyright © 2016年 KuaiYouJia. All rights reserved.
//

@interface WaveView : UIView

@property (nonatomic,assign)CGFloat present;
@property (nonatomic,strong)UILabel * presentlabel;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)openTimer;
- (void)closeTimer;

@end
