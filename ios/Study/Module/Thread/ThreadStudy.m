//
//  ThreadStudy.m
//  Study
//
//  Created by Lang on 2021/8/30.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "ThreadStudy.h"
#import "XLThread.h"
#import "NotificationDemo.h"
#import "CrashTestVC.h"
//#import <XLStaticLibrary02/XLTest02.h>
#import <XLStaticLibraryTest/XLStudy.h>
#import <XLDynamicLibrary/XLDLStudy.h>

@interface ThreadStudy ()

@property (nonatomic, strong) XLThread *thread;
@property (nonatomic, assign) BOOL stopped;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NotificationDemo *notification;

@property (nonatomic, strong) NSArray *nameArray;

@end



@implementation ThreadStudy {
    NSArray *_nameArray;
}

@dynamic nameArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:NSForegroundColorAttributeName object:nil];
    NSString *const str  = @"123";
    
//    str = @"456";
    
//    XLStudy *study = [[XLStudy alloc] init];
//    [study studyWithName:nil];
    
//        XLDLStudy *study = [[XLDLStudy alloc] init];
//        [study studyWithName:nil];
    
    self.notification = [NotificationDemo new];
    self.count = 50;
    char ca = 'a';
    char cb = 'b';
    char r = 'a'^'b'^'a';
    
    [self createThread];
    [self semaphoreTest];
    // 死锁演示
     [self badLock];
    
//    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        NSLog(@"a");
//        dispatch_sync(queue, ^{
//            NSLog(@"b");
//        });
//    });
//
//    dispatch_sync(queue, ^{
//        NSLog(@"c");
//        dispatch_async(queue, ^{
//            NSLog(@"d");
//        });
//    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s",__func__);
}


- (void)barrier {
//    dispatch_barrier_async(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
//    dispatch_barrier_sync(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
}

// 死锁
- (void)badLock {
    // return;
    // [self bad01];
    [self bad02];
}

- (void)bad01 {
    NSLog(@"1");
    // dispatch_sync()将block提交到调度队列, 但是在block完成之前不会返回。
    // sync 会在block执行完成后才能返回，但block需要等待主队列的任务处理完成后才能执行
    // 主线程 又被sync阻塞无法执行 NSLog(@"3");
    // 所以造成死锁
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}

- (void)bad02 {
    dispatch_queue_t sQueue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    // 会造成死锁
//    dispatch_async(sQueue, ^{
//        NSLog(@"sa");
//        dispatch_sync(sQueue, ^{
//            NSLog(@"sb");
//        });
//    });
    
    //不会死锁
    dispatch_sync(sQueue, ^{
        NSLog(@"sa");
        dispatch_async(sQueue, ^{
            NSLog(@"sb");
        });
    });
}
// 信号量
- (void)semaphoreTest {
    self.semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 20; i++) {
        dispatch_async(queue, ^{
            [self countSubtract];
        });
    }
    // 5 秒后信号量加1
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 信号量的值加 1
        dispatch_semaphore_signal(self.semaphore);
    });
}

- (void)countSubtract {
    // 当信号量value<=0 的时，当前线程进入休眠状态等待（直到value>0,线程恢复执行）
    // 如果信号量 > 0, value 减 1， 然后执行后面的代码
    long wait = dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    self.count--;
    NSLog(@"self.count = %zd", self.count);
    // 信号量的值加 1
    dispatch_semaphore_signal(self.semaphore);
}

- (void)createThread {
    __weak __typeof(self)weakSelf = self;
    self.thread = [[XLThread alloc] initWithBlock:^{
        // 保持线程存活
        [weakSelf keepAlive];
    }];
    self.thread.name = @"diy thread-2021";
    [self.thread start];
}

- (void)keepAlive {
    
    NSLog(@"keepAlive");
    NSPort *port = [NSPort port];
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSDefaultRunLoopMode];
    // 保活
    // 方法1
    // run 之后不能停止，是个永不销毁的线程
    //[[NSRunLoop currentRunLoop] run];
    // 方法2
    while (!self.stopped) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self performSelector:@selector(threadPSelector) onThread:self.thread withObject:nil waitUntilDone:YES];
    // 10s 后停止线程runloop
    //    __weak __typeof(self)weakSelf = self;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [weakSelf stop];
    //    });
    

    
    CrashTestVC *vc = [[CrashTestVC alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gcdTest {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}

- (void)threadTest {
    NSLog(@"threadTest");
}

- (void)threadPSelector {
    NSLog(@"threadPSelector %@", [NSThread currentThread]);
}

- (void)stop {
    // 在dealloc中调用时， waitUntilDone:YES 停止线程后再执行dealloc，不然self.thread容易野指针
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stopThread {
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s-%@", __func__, [NSThread currentThread]);
}

- (void)operation {
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        
    }];
}

- (void)dealloc {

}



- (void)setNameArray:(NSArray*)nameArray {
    _nameArray = [nameArray copy];
}

- (NSArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSArray array];
    }
    return _nameArray;
}

@end
