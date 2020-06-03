//
//  UIImage+Until.h
//  Study
//
//  Created by Lang on 2019/5/27.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Until)

- (UIImage *)roundImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor;
- (UIImage *)resizedImageWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
