//
//  EventHandlingVC.m
//  Study
//
//  Created by Lang on 2019/5/12.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import "EventHandlingVC.h"
#import "EventHandlingView.h"

@interface EventHandlingVC ()

@property (nonatomic, strong)EventHandlingView *eventView;
@property (nonatomic, strong)EventHandlingView *eventView1;
@property (nonatomic, strong)EventHandlingView *eventView2;

@end

@implementation EventHandlingVC

//- (void)loadView {
//    self.eventView = [[EventHandlingView alloc] init];
//    self.eventView.backgroundColor = [UIColor whiteColor];
//    self.eventView.tag = 1000;
//    self.view = self.eventView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EventHandlingView *view1 = [[EventHandlingView alloc] init];
    view1.layer.cornerRadius = 75;
    view1.clipsToBounds = YES;
    view1.tag = 1001;
    view1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(150);
    }];
    
    EventHandlingView *view2 = [[EventHandlingView alloc] init];
    view2.layer.cornerRadius = 75;
    view2.clipsToBounds = YES;
    view2.tag = 1002;
    view2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom).offset(50);
        make.centerX.equalTo(view1);
        make.width.height.mas_equalTo(150);
    }];
    
    EventHandlingView *view3 = [[EventHandlingView alloc] init];
    view3.layer.cornerRadius = 75;
    view3.clipsToBounds = YES;
    view3.tag = 1003;
    view3.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom).offset(50);
        make.centerX.equalTo(view1);
        make.width.height.mas_equalTo(150);
    }];
}

@end
