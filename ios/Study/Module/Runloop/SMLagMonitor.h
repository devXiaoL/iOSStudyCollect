//
//  SMLagMonitor.h
//  Study
//
//  Created by Lang on 2021/9/17.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMLagMonitor : NSObject

+ (instancetype)shareInstance;

@property (nonatomic) BOOL isMonitoring;

- (void)beginMonitor; //开始监视卡顿
- (void)endMonitor;   //停止监视卡顿

@end

NS_ASSUME_NONNULL_END
