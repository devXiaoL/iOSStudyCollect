//
//  XLRNBridgeManager.h
//  Study
//
//  Created by Lang on 2019/6/5.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

//@interface XLRNBridgeManager : RCTBridge
//
//+ (instancetype)sharedManager;
//
//@end
//
//@interface BridgeHandler : NSObject <RCTBridgeDelegate>
//
//@end

@interface XLRNBridgeManager : NSObject

+ (instancetype)sharedManager;

@end

@interface BridgeHandler : NSObject

@end

NS_ASSUME_NONNULL_END
