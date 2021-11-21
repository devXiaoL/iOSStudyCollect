//
//  XLFMDBVC.m
//  Study
//
//  Created by lanbao on 2018/4/12.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLFMDBVC.h"
#import <FMDB.h>

@interface XLFMDBVC ()

@end

@implementation XLFMDBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSString *path = [[NSBundle mainBundle] pathForResource:@"ci" ofType:@"db"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    [dataBase open];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([dataBase open]) {
            NSString *query = @"select * from ci";
            FMResultSet *result = [dataBase executeQuery:query];
            
            [dataBase executeStatements:query withResultBlock:^int(NSDictionary * _Nonnull resultsDictionary) {
                NSLog(@"%@", resultsDictionary[@"value"]);
                NSLog(@"%@", resultsDictionary[@"author"]);
                NSLog(@"%@", resultsDictionary[@"content"]);
                NSLog(@"%@", resultsDictionary[@"rhythmic"]);
                NSLog(@"-----------------------------------");
                return 0;
            }];
            [dataBase close];
        }
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
