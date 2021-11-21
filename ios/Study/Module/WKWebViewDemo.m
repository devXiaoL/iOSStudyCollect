//
//  WKWebViewDemo.m
//  Study
//
//  Created by Lang on 2021/9/3.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "WKWebViewDemo.h"
#import <WebKit/WKWebView.h>

@interface WKWebViewDemo ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKWebViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.webView = [[WKWebView alloc] init];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    return ![self.webView canGoBack];
}


@end
