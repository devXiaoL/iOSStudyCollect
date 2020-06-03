//
//  XLCreateRandom.m
//  Study
//
//  Created by lanbao on 2018/3/27.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLCreateRandom.h"

@implementation XLCreateRandom


+ (NSArray *)noRepeatRandomArrayWithMinNum:(NSInteger)min maxNum:(NSInteger )max count:(NSInteger)count{
    
    NSMutableSet *set = [NSMutableSet setWithCapacity:count];
    while (set.count < count) {
        NSInteger value = arc4random() % (max-min+1) + min;
        [set addObject:[NSNumber numberWithInteger:value]];
    }
    return set.allObjects;
    /*
    //NSInteger count = max - min + 1;
    NSMutableArray <NSNumber *>*randomValues = [NSMutableArray array];
    //保存随机数
    NSInteger value;
    
    for (int i = 0; i < count; i++) {
        do {
            value = arc4random() % (max-min+1) + min;
        } while ([randomValues containsObject:[NSNumber numberWithInteger:value]]);
        
        [randomValues addObject:[NSNumber numberWithInteger:value]];
    }
    return randomValues;
    */
}

@end
