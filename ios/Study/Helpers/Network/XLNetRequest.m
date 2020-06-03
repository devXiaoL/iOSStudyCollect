//
//  XLNetRequest.m
//  StudyDemo
//
//  Created by Lang on 8/30/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "XLNetRequest.h"
#import "XLNetManager.h"

@interface XLNetRequest ()



@end


@implementation XLNetRequest

- (NSURLSessionDataTask *)getWithUrl:(NSString *)path
         withParams:(NSDictionary *)params
            success:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure{
    
    NSURLSessionDataTask *task = [[self createNetManager] GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"current thread = %@",[NSThread currentThread]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    NSLog(@"url = %@",task.currentRequest.URL.absoluteString);
    return task;
}

- (NSURLSessionDataTask *)postWithUrl:(NSString *)path
         withParams:(NSDictionary *)params
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure{
    
    return [[self createNetManager] POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (XLNetManager *)createNetManager{
    XLNetManager *manager = [XLNetManager sharedManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    return manager;
}

- (AFSecurityPolicy*)customSecurityPolicy{
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"shanbaycom" ofType:@"cer"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"startImage" ofType:@"jpg"];
    //证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //AFSSLPinningModeNone不做任何验证，只要服务器返回了证书就行
    //AFSSLPinningModePublicKey只验证公钥
    //AFSSLPinningModeCertificate 所有内容一致才能通过
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = @[certData];
    return securityPolicy;
}



@end
