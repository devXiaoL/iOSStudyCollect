//
//  ImageInfo.m
//  StudyDemo
//
//  Created by Lang on 2017/6/9.
//  Copyright © 2017年 Lang. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo

+(ImageInfo *)imageInfoWithDict:(NSDictionary *)dict{
    return [[ImageInfo alloc]initWithDict:dict];
}

- (ImageInfo *)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setValuesForKeysWithDictionary:dict];
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"value = %@, key = %@",value,key);
}

@end
