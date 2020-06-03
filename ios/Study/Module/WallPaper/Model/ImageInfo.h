//
//  ImageInfo.h
//  StudyDemo
//
//  Created by Lang on 2017/6/9.
//  Copyright © 2017年 Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject

@property (nonatomic, strong)NSString *thumb;

@property (nonatomic, strong)NSString *url;

@property (nonatomic, strong)NSArray *tag;


+ (ImageInfo *)imageInfoWithDict:(NSDictionary *)dict;

- (ImageInfo *)initWithDict:(NSDictionary *)dict;

@end
