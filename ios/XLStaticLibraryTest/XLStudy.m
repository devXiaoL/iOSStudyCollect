//
//  XLStudy.m
//  XLStaticLibraryTest
//
//  Created by lang.li on 2021/10/23.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "XLStudy.h"

@interface XLStudy ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation XLStudy

- (instancetype)init {
    if (self = [super init]) {
        _array = [NSMutableArray array];
    }
    return self;
}

- (void)studyWithName:(NSString *)name {
    [self.array addObject:name];
}

@end
