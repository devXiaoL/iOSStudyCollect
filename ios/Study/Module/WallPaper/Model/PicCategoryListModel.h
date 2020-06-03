//
//  PicListModel.h
//  Study
//
//  Created by lanbao on 2018/2/2.
//  Copyright © 2018年 lanbao. All rights reserved.
//

#import "XLBaseModel.h"

@interface PicCategoryListModel : XLBaseModel
/*
"ename": "woman",
"atime": 1291266021,
"name": "美女",
"cover": "http://img0.adesk.com/download/5886ee1ce7bce728c4b74681",
"tcname": "美女",
"korean_name": "미녀",
"imgs": 50741,
"desc": "",
"_id": "4e4d610cdf714d2966000000",
"uid": null,
"sn": 1
*/
@property (nonatomic, copy) NSString *ename;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *tcname;
@property (nonatomic, copy) NSString *korean_name;
@property (nonatomic, copy) NSString *imgs;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *sn;
@property (nonatomic, copy) NSString *atime;

@end
