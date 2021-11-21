//
//  CrashTestVC.m
//  Study
//
//  Created by Lang on 2021/8/26.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "CrashTestVC.h"

@interface CrashTestVC ()

@property (nonatomic, strong) NSArray *array;

// 参考地址 http://gonghonglou.com/2019/07/06/crash-guard-unrecognized-selector/
@property (nonatomic, assign) NSArray *array1;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CrashTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CrashTest";
    self.view.backgroundColor = [UIColor whiteColor];
    self.array1 = @[@"1"];
    // 这种创建的不用手动加入 runloop 中
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self addObservers];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    
    
    [self removeObserver:self forKeyPath:@"title"];
}


- (void)addObservers {
    [self addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keyPath = %@, object = %@, change = %@", keyPath, object, change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    self.title = @"567";
    
}

- (void)timerHandler {
    NSLog(@"timerHandler");
}

- (void)crash {
    // 在调用setArray:时，新的值会被retain，旧的值会被release。如果两个线程同时执行了setArray:,那么旧的值就可能会release放两次。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.array = @[@"test"];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.array = @[@"test"];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.array = @[@"test"];
    });
    NSLog(@"%@",self.array);
}


- (void)crash1 {
    // assign修饰后，self 没有强引用，array的引用计数不会增加，对象创建之后因为没人引用他所以就被回收了
    // 访问self.array 会产生 EXC_BAD_ACCESS 崩溃，这便是向已回收的对象发送消息产生的崩溃
    NSLog(@"%@",self.array1);
}



@end
