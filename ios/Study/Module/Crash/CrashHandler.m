//
//  CrashHandler.m
//  Study
//
//  Created by lang.li on 2021/10/23.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "CrashHandler.h"

@implementation CrashHandler

+ (void)open {
    NSSetUncaughtExceptionHandler(&my_uncaught_exception_handler);
}

static void my_uncaught_exception_handler (NSException *exception) {
    // 这里可以取到 NSException 信息
    NSLog(@"my_uncaught_exception_handler %@", exception);
}


@end
