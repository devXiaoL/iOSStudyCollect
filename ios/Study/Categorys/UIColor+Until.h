//
//  UIColor+Until.h
//  Study
//
//  Created by lanbao on 2018/2/1.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorHex(hex) [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#hex))]

@interface UIColor (Until)

+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)randomColor;

@end
