//
//  NotificationDemo.m
//  Study
//
//  Created by Lang on 2021/9/18.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "NotificationDemo.h"

@interface NotificationDemo ()<NSMachPortDelegate>

@property (nonatomic, strong) NSThread *notificationThread;
@property (nonatomic, strong) NSMachPort *notificationPort;

@property (nonatomic, strong) NSMutableArray<NSNotification *> *notifications;
@property (nonatomic, strong) NSLock *notificationLock;

@end

@implementation NotificationDemo

- (instancetype)init{
    if (self = [super init]) {
        [self test];
    }
    return self;
}

- (void)test {
    self.notifications = [NSMutableArray array];
    
    self.notificationThread = [NSThread currentThread];
    
    self.notificationPort = [[NSMachPort alloc] init];
    self.notificationPort.delegate = self;
    
    [[NSRunLoop currentRunLoop] addPort:self.notificationPort forMode:NSRunLoopCommonModes];
    
    [self postNotification];
}

#pragma mark NSMachPortDelegate

- (void)handleMachMessage:(void *)msg {
    [self.notificationLock lock];
    while ([self.notifications count]) {
        NSNotification *notification = self.notifications.firstObject;
        [self.notifications removeObjectAtIndex:0];
        [self.notificationLock unlock];
        [self testNotification:notification];
        [self.notificationLock lock];
    }
    [self.notificationLock unlock];
}

#pragma mark - testNotification

- (void)postNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNotification:) name:@"testNotification" object:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testNotification" object:nil userInfo:nil];
    });
}

- (void)testNotification: (NSNotification *)notification {
    NSThread *currentThread = [NSThread currentThread];
    if (currentThread != self.notificationThread) {
        [self.notificationLock lock];
        [self.notifications addObject:notification];
        [self.notificationLock unlock];
        [self.notificationPort sendBeforeDate:[NSDate date] components:nil from:nil reserved:0];
    } else {
        // machPort 所在的线程，即我们指定的接收线程
    }
}

@end
