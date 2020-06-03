//
//  XLNetManager.m
//  StudyDemo
//
//  Created by Lang on 8/30/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "XLNetManager.h"

@implementation XLNetManager


static XLNetManager *_shareClient = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [super allocWithZone:zone];
        
        //先导入证书，找到证书的路径
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"apis.942hf.com" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        securityPolicy.allowInvalidCertificates = YES;
        
        //validatesDomainName 是否需要验证域名，默认为YES;
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = NO;
        
        if (certData) {
            securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
        }
        
        [_shareClient setSecurityPolicy:securityPolicy];
        
        
        
    });
    return _shareClient;
}

- (id)copyWithZone:(NSZone *)zone{
    return _shareClient;
}

+ (XLNetManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[self alloc]init];
    });
    return _shareClient;
}

@end
