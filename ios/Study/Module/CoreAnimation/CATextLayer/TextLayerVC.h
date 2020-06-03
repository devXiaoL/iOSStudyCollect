//
//  TextLayerVC.h
//  Study
//
//  Created by Lang on 2019/6/9.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextLayerVC : UIViewController

@end

@interface NormalCell : UITableViewCell



@end

@interface TextLayerCell : UITableViewCell

- (void)setupText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
