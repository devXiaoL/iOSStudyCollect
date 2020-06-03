//
//  AVAudioSessionSetup.m
//  Study
//
//  Created by mac on 2020/6/3.
//  Copyright © 2020 lanbao. All rights reserved.
//

#import "AVAudioSessionSetup.h"
#import <AVFoundation/AVFoundation.h>

@implementation AVAudioSessionSetup

+ (void)SetupAudioSession {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Category Error: %@", [error localizedDescription]);
    }
    
    if (![session setActive:YES error:&error]) {
        NSLog(@"Activation Error: %@", [error localizedDescription]);
    }
}

+ (void)EndAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    if (![session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
        NSLog(@"endAudioSession Error: %@", [error localizedDescription]);
    }
}

@end
