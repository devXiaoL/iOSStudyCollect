//
//  XLFeatureListModel.m
//  Study
//
//  Created by lanbao on 2018/2/1.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLFeatureListModel.h"

@implementation XLFeatureListModel

+ (NSArray *)listModels{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"FeatureListInfo" ofType:@"plist"];
    NSArray *list = [NSArray arrayWithContentsOfFile:path];
    return [XLFeatureListModel mj_objectArrayWithKeyValuesArray:list];
}

@end
