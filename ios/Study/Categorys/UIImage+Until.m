//
//  UIImage+Until.m
//  Study
//
//  Created by Lang on 2019/5/27.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import "UIImage+Until.h"
#import <AVFoundation/AVUtilities.h>

@implementation UIImage (Until)

- (UIImage *)roundImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // 开启图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    // 填充颜色
    [fillColor setFill];
    UIRectFill(rect);
    // 圆形绘制路径
    CGFloat radius = MIN(size.width, size.height) * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];
    [self drawInRect:rect];
    
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return roundImage;
}

- (UIImage *)resizedImageWithSize:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(self.size, CGRectMake(0, 0, size.width, size.height));
    
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(rect.size.width,rect.size.height)];
        UIImage *resizedImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [self drawInRect:CGRectMake(0, 0, size.width * scale, size.height * scale)];
        }];
        return resizedImage;
        
    } else {
        // Fallback on earlier versions
    }
    
    return nil;
}

@end
