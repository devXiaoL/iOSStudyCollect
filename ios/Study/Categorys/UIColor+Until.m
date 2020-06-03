//
//  UIColor+Until.m
//  Study
//
//  Created by lanbao on 2018/2/1.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "UIColor+Until.h"

@implementation UIColor (Until)

+ (UIColor *)colorWithHexString:(NSString *)hex{
    NSInteger length = hex.length;
    if (length != 6 && length != 8) {
        return nil;
    }
    unsigned int red, green,blue;
    unsigned int alpha = 255;
    NSRange range;
    range.length = 2;
    //红色
    range.location = 0;
    [[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&blue];
    
    if (length == 8) {
        range.location = 6;
        [[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&alpha];
    }
    return [UIColor colorWithRed:(CGFloat)(red/255.0f)
                           green:(CGFloat)(green/255.0f)
                            blue:(CGFloat)(blue/255.0f)
                           alpha:(CGFloat)(alpha/255.0f)];
}

+ (UIColor *)randomColor{
    return [UIColor colorWithRed:arc4random_uniform(255)/254.0 green:arc4random_uniform(255)/254.0 blue:arc4random_uniform(255)/254.0 alpha:1];
}

@end
