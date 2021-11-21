//
//  Person.m
//  Study
//
//  Created by lang.li on 2021/10/28.
//  Copyright © 2021 lanbao. All rights reserved.
//

#import "Person.h"

@interface Person ()

@end

@implementation Person

@synthesize name = _name;

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setName:(NSString *)name {
    @synchronized (self) {
        _name = [name copy];
    }
}

- (NSString *)name {
    return _name;
}

@end

/* @dynamic

@implementation Person{
    NSString *_name;
}
@dynamic name;

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setName:(NSString *)name {
    @synchronized (self) {
        _name = [name copy];
    }
}

- (NSString *)name {
    return _name;
}

@end

*/
