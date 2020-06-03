//
//  XLImageOperationVC.m
//  Study
//
//  Created by Lang on 2019/6/8.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import "XLImageOperationVC.h"
#import <SDWebImage/SDWebImageCoder.h>

@interface XLImageOperationVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@end

@implementation XLImageOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"wallpaper"];
    
    [self decodeImageWithImage:image completion:^(UIImage *newImage) {

        NSData *data1 = UIImagePNGRepresentation(newImage);
        //重新绘制image
        CGRect bounds = self.imageView1.bounds;
        UIGraphicsBeginImageContextWithOptions(bounds.size, YES, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef pathRef = [UIBezierPath bezierPathWithRect:bounds].CGPath;
        CGContextAddPath(context, pathRef);
        CGContextClip(context);
        [newImage drawInRect:bounds];
        //    [self.imageView1.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *drawImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.imageView1.image = drawImage;
    }];
    
    self.imageView.image = image;
    
    NSData *data = UIImagePNGRepresentation(image);
}

- (void)decodeImageWithImage:(UIImage *)image completion:(void(^)(UIImage *image))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        UIImage *newImage = [self decodeImageWithImage:image];
        
        if (completion) {
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(newImage);
            });
        }
    });
}

/*
 CGContextRef CGBitmapContextCreate(void *data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef space, uint32_t bitmapInfo);
 
 新位图上下文的像素格式由三个参数确定 - 每个组件的位数，颜色空间和alpha选项
 
 CGBitmapContextCreate 函数中每个参数所代表的具体含义：
 
 data ：如果不为 NULL ，那么它应该指向一块大小至少为 bytesPerRow * height 字节的内存；如果 为 NULL ，那么系统就会为我们自动分配和释放所需的内存，所以一般指定 NULL 即可；
 width 和 height ：位图的宽度和高度，分别赋值为图片的像素宽度和像素高度即可；
 bitsPerComponent ：像素的每个颜色分量使用的 bit 数，在 RGB 颜色空间下指定 8 即可；
 bytesPerRow ：位图的每一行使用的字节数，大小至少为 width * bytes per pixel 字节。有意思的是，当我们指定 0 时，系统不仅会为我们自动计算，而且还会进行 cache line alignment 的优化，更多信息可以查看 what is byte alignment (cache line alignment) for Core Animation? Why it matters? 和 Why is my image’s Bytes per Row more than its Bytes per Pixel times its Width? ，亲测可用；
 space ：就是我们前面提到的颜色空间，一般使用 RGB 即可；
 bitmapInfo ：就是我们前面提到的位图的布局信息。
 
 */

- (UIImage *)decodeImageWithImage:(UIImage *)image {
    //        NSData *data = UIImagePNGRepresentation(image);
    //        CGImageSourceRef imageSource = CGImageSourceCreateIncremental(NULL);
    //        CGImageSourceUpdateData(imageSource, (__bridge CFDataRef)data, YES);
    //        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    // 获取位图图像
    CGImageRef imageRef = image.CGImage;
    // 获取像素的 宽、高
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    // 创建一个 位图上下文
    // kCGBitmapByteOrderDefault 默认的字节顺序
    // kCGImageAlphaPremultipliedFirst
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8,  0, SDCGColorSpaceGetDeviceRGB(), kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    if (!bmContext) {
        CGContextRelease(bmContext);
        return image;
    }
    
    // 将图片绘制到 位图上下文中
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), imageRef);
    
    CGImageRelease(imageRef);
    // 创建一张新的解码之后的位图
    imageRef = CGBitmapContextCreateImage(bmContext);
    
    CGContextRelease(bmContext);
    //CFRelease(imageSource);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
    return newImage;
}

@end
