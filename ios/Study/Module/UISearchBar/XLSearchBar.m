//
//  XLSearchBar.m
//  Study
//
//  Created by lanbao on 2018/5/16.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLSearchBar.h"

@implementation XLSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)didMoveToWindow {
    
}

- (void)setDisplayCenter:(BOOL)displayCenter {
    _displayCenter = displayCenter;
    if (displayCenter) {
        if (@available(iOS 11, *)) {
            if (self.displayCenter) {
                UITextField  *seachTextFild = [self valueForKey:@"searchField"];
                seachTextFild.font = [UIFont systemFontOfSize:14];
                NSDictionary *dict = @{NSFontAttributeName:seachTextFild.font};
                CGSize size = [self.placeholder sizeWithAttributes:dict];
                [self setPositionAdjustment:UIOffsetMake((self.bounds.size.width - size.width - 40)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
            }
        }
    }else {
        [self setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
}

@end
