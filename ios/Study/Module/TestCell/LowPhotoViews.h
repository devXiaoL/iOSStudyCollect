//
//  LowPhotoViews.h
//  Study
//
//  Created by mac on 2020/5/15.
//  Copyright © 2020 lanbao. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LowPhotoViews : UIView

@property (nonatomic, copy)NSArray *picUrls;

+(CGSize)sizeWithImageCount:(NSInteger)picCount;

@end

NS_ASSUME_NONNULL_END
