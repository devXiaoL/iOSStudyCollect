//
//  AppDelegate.m
//  Study
//
//  Created by lanbao on 2018/2/1.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "AppDelegate.h"
#import "XLTabBarController.h"

#import <UserNotifications/UserNotifications.h>

#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//#import <React/RCTBundleURLProvider.h>

#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import "AppDelegate+FlutterBoost.h"

#import "NSObject+Test2.h"
#import "NSObject+CrashLogHandler.h"

#import "SMLagMonitor.h"
#import "CrashHandler.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@property (nonatomic, assign)UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 测试分类方法调用顺序
    // NSObject *a = [NSObject new];
    // [a test];
    
    [self initFlutterBoostWithApplication:application];
    
    [[SMLagMonitor shareInstance] beginMonitor];
    
    NSDictionary *dict = @{@"1": @"a"};
    
    NSString *value = dict[@"2"];
    
    [CrashHandler open];
    
    
//    self.flutterEngine = [[FlutterEngine alloc] initWithName:@"my flutter engine"];
//    // Runs the default Dart entrypoint with a default Flutter route.
//    [self.flutterEngine run];
    // Used to connect plugins (only if you have plugins with iOS platform code).
//    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
    
    //[RCTBundleURLProvider sharedSettings].jsLocation = @"127.0.0.1";
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    XLTabBarController *tabBar = [[XLTabBarController alloc]init];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        [JPUSHService setupWithOption:launchOptions
    //                               appKey:@"dbab963d6f949c7b841463c7"
    //                              channel:@"ios"
    //                     apsForProduction:NO
    //                advertisingIdentifier:nil];
    //
    //        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    //        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    //        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //            // 可以添加自定义 categories
    //            // NSSet<UNNotificationCategory *> *categories for iOS10 or later
    //            // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    //        }
    //        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //    });
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^( void) {
        [self backgroundTask];
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"options = %@",options);
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",url]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
// app 后台运行时点击通知打开app调用的方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)backgroundTask {
    
}

@end
