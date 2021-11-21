//
//  MemoryDemoVC.m
//  Study
//
//  Created by Lang on 2021/9/9.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "MemoryDemoVC.h"
#import "TestRelease.h"
#import <malloc/malloc.h>
#import "Person.h"

extern void _objc_autoreleasePoolPrint(void);

@interface MemoryDemoVC ()

@property (nonatomic, strong) NSObject *obj1;

@property (nonatomic, assign) void(^assignBlock)(void);

@end

@implementation MemoryDemoVC {
    CFRunLoopObserverRef runLoopObserver;
    NSArray *arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //    [self memoryLayout];
    
    
    
    [self arrCopy];
    
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"%zd", malloc_size((__bridge const void*)(obj)));
    NSLog(@"%zd", class_getInstanceSize([obj class]));
    NSLog(@"%zd", sizeof(obj));
    
    NSNumber *number = @4;
    NSLog(@"number = %p", number);
    //    arr = [NSArray array];
    
    self.obj1 = [[NSObject alloc] init];
    
    [self test];
    int a = 1;
    
    void(^block)(void) = ^(void){
        //        NSLog(@"%d", a);
        NSLog(@"%@", arr);
        NSLog(@"%@", _obj1);
    };
    [self testBlock:block];
    // self.weakBlock 的修饰符为 assign
    self.assignBlock = ^(){
        NSLog(@"assignBlock a = %d", a);
    };
    
    __weak void(^weakBlock)(void) = ^(){
        NSLog(@"weakBlock a = %d", a);
    };
    
    NSLog(@"assignBlock = %@", self.assignBlock); // assignBlock = <__NSMallocBlock__: 0x6000027860d0>
    
    NSLog(@"weakBlock = %@", weakBlock);        // weakBlock = <__NSStackBlock__: 0x30d319ab0>
    
//    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
//    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
//                                              kCFRunLoopAllActivities,
//                                              YES,
//                                              0,
//                                              &runLoopObserverCallBack,
//                                              &context);
//    CFRunLoopAddObserver(CFRunLoopGetCurrent(), runLoopObserver, kCFRunLoopCommonModes);
//    CFRelease(runLoopObserver);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fun];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


- (void)fun {
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        const char *label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
        const char *mainLabel = dispatch_queue_get_label(dispatch_get_main_queue());
        
        NSLog(@"\n thread = %@ \n label = %s \n mainLabel = %s", [NSThread currentThread], label, mainLabel);
        
        BOOL isMain = [NSThread isMainThread];
        if (isMain) {
            NSLog(@"---主线程---");
        }else{
            NSLog(@"---子线程---");
        }
    });
}

- (void)arrCopy {
    //
    Person *p1 = [[Person alloc] init];
    p1.name = @"p1";
    
    Person *p2 = [Person new];
    p2.name = @"p2";
    
    NSMutableArray<Person *> *arr = @[p1, p2].mutableCopy;
    arr[0].name = @"pp1";
    NSLog(@"arr[0].name = %@", arr[0].name);
}

- (void)memoryLayout {
    // 内存分区， 下面的分区按地址从低到高排列
    
    /** 代码区
     
     */
    /** 数据区
     
     字符串常量
     已初始化全局变量、静态变量
     未初始化的全局变量、静态变量
     */
    /** 堆区
     分配的地址越来越大
     */
    /** 栈区
     局部变量
     （分配的地址越来越小）
     */
    
    static int abc;
    // abc = 0x103aa0920,  10进制 4356442400
    // str = 0x103a64f70   4356198256
    
    // @"123"是字符串常量，存储在数据区
    // str是局部变量，存储在 栈区
    // __NSCFConstantString
    NSString *str = @"123";
    NSString *str1 = [NSString stringWithFormat:@"abc"];
    NSString *str2 = [NSString stringWithFormat:@"abcdefghijklmnopq"];
    NSString *str3 = [str1 copy];
    NSMutableString *str4 = [str1 mutableCopy];
    NSString *str5 = [str4 copy];
    // &str  = 0x7ffee8966a98 __NSCFConstantString  content p  = 0x107352fb0
    // &str1 = 0x7ffee8966a90 NSTaggedPointerString content p = 0xa000000006362613
    //&str2  = 0x7ffee8966a88 __NSCFString          content p = 0x600003b9bba0
    //&str3  = 0x7ffee8966a80 NSTaggedPointerString content p = 0xa000000006362613
    //&str4  = 0x7ffee8966a78 __NSCFString          content p = 0x600003b9bbd0
    //&str5  = 0x7ffee8966a70 NSTaggedPointerString content p = 0xa000000003332313
    NSLog(@"&str = %p %@ content p = %p", &str, [str class], str);
    NSLog(@"&str1 = %p %@ content p = %p", &str1, [str1 class], str1);
    NSLog(@"&str2 = %p %@ content p = %p", &str2, [str2 class], str2);
    NSLog(@"&str3 = %p %@ content p = %p", &str3, [str3 class], str3);
    NSLog(@"&str4 = %p %@ content p = %p", &str4, [str4 class], str4);
    NSLog(@"&str5 = %p %@ content p = %p", &str5, [str5 class], str5);
    NSLog(@"&abc = %p", &abc);
}

- (void)testBlock:(void(^)())block {
    block();
}

- (void)test {
    
    for (int i = 0; i<10; i++) {
        NSString *temp = [NSString stringWithFormat:@"adfadfjldsjfljdsljfljsadfjds;jf;lsdajf"];
        _objc_autoreleasePoolPrint();
    }
    
    NSLog(@"------------");
    
    _objc_autoreleasePoolPrint();
    //    @autoreleasepool {
    ////        NSObject *obj1 = [NSObject new];
    //
    //        @autoreleasepool {
    ////            NSObject *obj2 = [NSObject new];
    //        }
    //
    //    }
}

- (void)dealloc {
    _objc_autoreleasePoolPrint();
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
        {
            NSLog(@"kCFRunLoopBeforeTimers");
            _objc_autoreleasePoolPrint();
        }
            break;
        case kCFRunLoopBeforeSources:
        {
            NSLog(@"kCFRunLoopBeforeSources");
            _objc_autoreleasePoolPrint();
        }
            break;
        case kCFRunLoopBeforeWaiting:
        {
            NSLog(@"kCFRunLoopBeforeWaiting");
            _objc_autoreleasePoolPrint();
        }
            break;
        case kCFRunLoopAfterWaiting:
        {
            NSLog(@"kCFRunLoopAfterWaiting");
            _objc_autoreleasePoolPrint();
        }
            break;
        case kCFRunLoopExit:
        {
            NSLog(@"kCFRunLoopBeforeWaiting");
            _objc_autoreleasePoolPrint();
        }
            break;
        default:
            break;
    }
}

@end
