//
//  XLNetManager.h
//  StudyDemo
//
//  Created by Lang on 8/30/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethod){
    RequestMethodGet,
    RequestMethodPost
};

typedef void(^RequestSuccessBlcok)(id json);
typedef void(^RequestFailureBlock)(NSError *error);


@interface XLNetRequest : NSObject


- (NSURLSessionDataTask *)postWithUrl:(NSString *)path
                 withParams:(NSDictionary *)params
                    success:(void (^)(id json))success
                    failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getWithUrl:(NSString *)path
         withParams:(NSDictionary *)params
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure;

@end
