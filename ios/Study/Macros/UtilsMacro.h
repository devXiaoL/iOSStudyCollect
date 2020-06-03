//
//  UtilsMacro.h
//  JinHangXian
//
//  Created by lanbao on 2017/9/15.
//  Copyright © 2017年 LanBao. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

#define BaseTagValue 10000

#define kDefaultImage [UIImage imageNamed:@"common_listNoImage"]
#define kDefaultBannerImage [UIImage imageNamed:@"common_bannerDefault"]

//非空判断 宏
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)

//当前系统的宽度比例
#define SCALE_WIDTH    (ScreenWidth/375)
//当前系统的高度比例
#define SCALE_HEIGHT   (ScreenHeight/667)

#define ScaleWidth(_h)    ((_h) * SCALE_WIDTH)
#define ScaleHeight(_h)  ((_h) * SCALE_HEIGHT)

#define LB_KEY_WINDOW [[UIApplication sharedApplication] keyWindow]

#define LBRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/*
#ifdef DEBUG //开发调试阶段
#define NSLog(FORMAT, ...)  do { \
fprintf(stderr,"%s:%d\n%s\n%s\n",[[[NSString stringWithUTF8String:__FILE__]  lastPathComponent] UTF8String], __LINE__, __func__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);   \
fprintf(stderr, "*********************************************\n");        \
} while (0);
#else  //发布上线阶段
#define NSLog(...)
#endif
*/

#endif /* UtilsMacro_h */
