//
//  PhotoViews.h
//  StudyDemo
//
//  Created by Lang on 11/19/16.
//  Copyright © 2016 Lang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViews : UIView

@property (nonatomic, copy)NSArray *picUrls;

+(CGSize)sizeWithImageCount:(NSInteger)picCount;

@end
