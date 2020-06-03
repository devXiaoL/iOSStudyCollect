//
//  ENUMMacros.h
//  JinHangXian
//
//  Created by lanbao on 2017/10/21.
//  Copyright © 2017年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

//发送验证码类型
typedef NS_ENUM(NSUInteger, LBSendVCodeType) {
    LBSendVCodeTypeRegister = 1,
    LBSendVCodeTypeForget = 2,
    LBSendVCodeTypeOldPhone = 3,
    LBSendVCodeTypeChange = 4,
};

/*1：待付款 2：待发货 3：待收货 4：待评价 什么都不传就是全部*/

typedef NS_ENUM(NSUInteger, LBOrderType) {
    LBOrderTypeAllType = 0,              //全部
    LBOrderTypePendingPayment = 1,       // 待付款
    LBOrderTypePendingSend = 2,          // 待发货
    LBOrderTypePendingReceipt = 3,       // 待收货
    LBOrderTypePendingComment = 4,       // 待评价
    LBOrderTypeFinish = 5,               // 已完成
    LBOrderTypePendingRefund,            // 退款中
    LBOrderTypeRefundSuccess,            // 退款成功
    LBOrderTypeCancel,                   // 已取消
    LBOrderTypeUnknow                    // 未知
};

///商品列表排序类型 综合、价格降序、价格升序、销量优先
typedef NS_ENUM(NSUInteger, GoodsListRequestOrderType) {
    GoodsListRequestOrderTypeCombination = 1,
    GoodsListRequestOrderTypPriceDescending = 2,
    GoodsListRequestOrderTypePriceAscending= 3,
    GoodsListRequestOrderTypeSales = 4,
};

/**
 消息类型
 
 - MessageTypeSystem: 系统消息
 - MessageTypeInfo: 通知消息
 - MessageTypeTrade: 交易消息
 */
typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeTrade = 0,
    MessageTypeNotice = 1,
    MessageTypeSystem = 2,
};


@interface ENUMMacros : NSObject

@end
