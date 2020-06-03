//
//  NSURLTestVC.m
//  Study
//
//  Created by lanbao on 2018/4/27.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "NSURLTestVC.h"
#import <Photos/Photos.h>
#import "MessageForwarding.h"
#import "MessageForwardingHandler.h"


@interface NSURLTestVC ()

@property (nonatomic, strong)NSOperationQueue *queue;

@end

@implementation NSURLTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:nil forKey:@"test"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [userDefaults integerForKey:@"childCount"];
    
    self.navigationItem.title = [NSString stringWithFormat:@"第%zd个页面",count];
    
    NSString *urlStr = @"http://service.store.dandanjiang.tv/v1/wallpaper/category?height=2208&sys_language=zh-Hans-CN&width=1242";
    NSURLComponents *components = [NSURLComponents componentsWithString:urlStr];
    NSLog(@"scheme = %@",components.scheme);
    NSLog(@"host   = %@",components.host);
    NSLog(@"path   = %@",components.path);
    NSLog(@"query = %@",components.query);
    NSLog(@"queryItems = %@",components.queryItems);
    
    NSURL *url1 = [NSURL URLWithString:urlStr relativeToURL:[NSURL URLWithString:@"http://service.store.dandanjiang.tv"]];
    NSLog(@"URLWithString:(NSString *)URLString relativeToURL:(nullable NSURL *)baseURL---url = %@",url1);
    /*
    //如果path前面或者baseURL有多余的'/',系统会自动去除多余的
    [[NSURL URLWithString:@"/v1/wallpaper/category" relativeToURL:[NSURL URLWithString:@"http://service.store.dandanjiang.tv"]] absoluteURL];
    //输出
    @"http://service.store.dandanjiang.tv/v1/wallpaper/category";
     
    [[NSURL URLWithString:@"/v1/wallpaper/category" relativeToURL:[NSURL URLWithString:@"http://service.store.dandanjiang.tv/"]] absoluteURL];
    //输出
    @"http://service.store.dandanjiang.tv/v1/wallpaper/category";
     */
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ci" ofType:@"db"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    NSLog(@"pathURL = %@",pathURL);
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = kMainColor;
    [button setTitle:@"返回首页。双击测试消息转发" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(50);
    }];
    
    [button addTarget:self action:@selector(doubleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self readPhotos];
    // 多线程测试
//    [self multiThread];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.queue cancelAllOperations];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)multiThread {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    self.queue = queue;
    queue.maxConcurrentOperationCount = 10;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
            NSLog(@"%@ 1---%@", self.navigationItem.title,[NSThread currentThread]); // 打印当前线程
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
            NSLog(@"%@ 2---%@",self.navigationItem.title, [NSThread currentThread]); // 打印当前线程
        }
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
            NSLog(@"%@ 3---%@",self.navigationItem.title, [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [userDefaults integerForKey:@"childCount"];
    [userDefaults setInteger:count+1 forKey:@"childCount"];
    [userDefaults synchronize];
    
    NSURLTestVC *vc = [NSURLTestVC new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doubleTapButtonAction:(UIButton *)button {
    MessageForwarding *msg = [MessageForwarding new];
    [msg instanceMethodTest];
//    [MessageForwarding classMethodTest];
}

- (void)backHomeAction:(UIButton *)button {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:@"childCount"];
    [userDefaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"%s---%@",__func__,self.navigationItem.title);
}

- (void)readPhotos{
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    for (PHAssetCollection *assetCollection in collections) {
        NSLog(@"assetCollection = %@",assetCollection);
    }
    for (PHAsset *asset in assets) {
        NSLog(@"asset = %@",asset);
    }
}

@end
