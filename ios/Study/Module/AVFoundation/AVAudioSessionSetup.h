//
//  AVAudioSessionSetup.h
//  Study
//
//  Created by mac on 2020/6/3.
//  Copyright © 2020 lanbao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioSessionSetup : NSObject

+ (void)SetupAudioSession;
+ (void)EndAudioSession;

@end

NS_ASSUME_NONNULL_END
