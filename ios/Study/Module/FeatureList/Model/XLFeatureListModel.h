//
//  XLFeatureListModel.h
//  Study
//
//  Created by lanbao on 2018/2/1.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLBaseModel.h"

@interface XLFeatureListModel : XLBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *targetVC;

+ (NSArray *)listModels;

@end
