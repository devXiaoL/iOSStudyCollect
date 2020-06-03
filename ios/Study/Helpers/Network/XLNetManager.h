//
//  XLNetManager.h
//  StudyDemo
//
//  Created by Lang on 8/30/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface XLNetManager : AFHTTPSessionManager

+ (XLNetManager *)sharedManager;

@end
