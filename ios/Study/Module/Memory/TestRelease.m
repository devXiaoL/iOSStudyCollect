//
//  TestRelease.m
//  Study
//
//  Created by Lang on 2021/9/17.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "TestRelease.h"

@implementation TestRelease

+ (TestRelease *)test {
    TestRelease *temp = [[TestRelease alloc] init];
    return temp;
}

- (void)dealloc {
    NSLog(@"TestRelease dealloc");
}

@end
