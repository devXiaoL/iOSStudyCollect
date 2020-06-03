//
//  XLCreateRandom.h
//  Study
//
//  Created by lanbao on 2018/3/27.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCreateRandom : NSObject

/**
 生成一组不重复的随机数 （随机数的个数为 最大数-最小数）

 @param min 最小的数
 @param max 最大的数
 @param count 随机数的个数（不能大于最大的数）
 @return 没有重复随机数字的数组
 */
+ (NSArray *)noRepeatRandomArrayWithMinNum:(NSInteger)min maxNum:(NSInteger )max count:(NSInteger)count;

@end
