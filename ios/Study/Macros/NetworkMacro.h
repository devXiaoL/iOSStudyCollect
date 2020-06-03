//
//  NetworkMacro.h
//  JinHangXian
//
//  Created by lanbao on 2017/9/15.
//  Copyright © 2017年 LanBao. All rights reserved.
//

#ifndef NetworkMacro_h
#define NetworkMacro_h

#define kListPerPageCount   (12)

#define kURLDomain          @"http://m63.lanbaoapp.com"
#define kURLBase            [NSString stringWithFormat:@"%@/%@",kURLDomain,@"index.php"]

//保存极光ID
#define kURLSaveJPushID     @"Api/User/save_registration_id"

//分享
#define kURLMeetingShare    @"Api/Meeting/meet_share"
#define kURLGoodsShare      @"Api/Goods/goods_share"

///用户相关
#define kURLLogin               @"Api/User/login"
#define kURLSendVCode           @"Api/User/sendcode"
#define kURLRegister            @"Api/User/register"
#define kURLUpdateAvatar        @"Api/User/avator"
#define kURLFinishRegister      @"Api/User/finish_register"
#define kURLEditUserInfo        @"Api/Center/edit"
#define kURLChangePWD           @"Api/Center/edit_pwd"
#define kURLChangePhone         @"Api/User/sendcode"
#define kURLChangePhoneCheck    @"Api/User/phone_valid"
#define kURLForgetPwd           @"Api/User/get_back_pwd"

///首页
#define kURLHome            @"Api/Index/home"

///会议列表
#define kURLMeetingList     @"Api/Meeting/mlist"
///会议详情
#define kURLMeetingDetail   @"Api/Meeting/detail"
///会议点赞
#define kURLMeetingPraise   @"Api/Meeting/praise"
///会议报名
#define kURLMeetingEnroll   @"Api/Meeting/enroll"
///报名提交
#define kURLEnrollSubmit    @"Api/Meeting/sign_up"

///商城首页
#define kURLShoppingHome    @"Api/Goods/home"
///根据一级分类获取子分类
#define kURLShoppingGetChildCategory @"Api/Goods/get_child_category"
///商品列表
#define kURLGoodslist       @"Api/Goods/goodslist"
///商品搜索
#define kURLGoodsSearch     @"Api/Goods/search"
///商品搜索提交搜索
#define kURLGoodsSearchSubmit     @"Api/Goods/goods_search"
//商品搜索清空历史
#define kURLDeleteSearchHistory   @"Api/Goods/clear_history"

///商品详情
#define kURLGoodsDetail     @"Api/Goods/goodsDetail"
///商品不同规格的价格和库存
#define kURLGoodsPriceStock @"Api/Goods/get_goods_info"
///添加购物车
#define kURLGoodsAddShopC   @"Api/Car/addcar"
///商品收藏
#define kURLGoodsCollect    @"Api/Goods/collect_goods"
///全部评论
#define kURLMoreComments    @"Api/Goods/more_comments"

///店铺首页
#define kURLShopHome        @"Api/Shop/home"
#define kURLShopAllGoods    @"Api/Shop/all_goods"
#define kURLShopNewGoods    @"Api/Shop/new_goods"


///立即购买 确认订单
#define kURLGoodsConfirmOrder       @"Api/Goods/confirm_order"
#define kURLGoodsPayOrder            @"Api/Goods/creat_order"
///我的购物车
#define kURLMyShoppingCart          @"Api/Car/home"
///修改商品数量
#define kURLMyShoppingCartChangeQty @"Api/Car/editcar"
///删除商品
#define kURLMyShoppingCartDelete    @"Api/Car/delcar"
///购物车确认订单
#define kURLConfirmOrder            @"Api/Car/confirm_order"
//购物车生成支付订单信息
#define kURLShopCartCreateOrder     @"Api/Car/create_order"
///添加或修改收货地址
#define kURLMyAddressEdit           @"Api/Center/editadr"
///删除地址
#define kURLMyAddressDelete         @"Api/Center/deladr"
///设置默认地址
#define kURLMyAddressDefault        @"Api/Center/defaultadr"

///我的订单
#define kURLMyOrder         @"Api/Order/all_order"
#define kURLMyOrderDetail   @"Api/Order/order_details"
#define kURLMyOrderCancel   @"Api/Order/cacal_order"
#define kURLMyOrderDelete   @"Api/Order/order_del"
#define kURLMyOrderPay      @"Api/Order/payment"
#define kURLMyOrderRemindSend        @"Api/Order/remind"
#define kURLMyOrderConfirmReceipt    @"Api/Order/goods_receipt"
#define kURLMyOrderLogistics         @"Api/Order/check_express"
#define kURLMyOrderCommentGoodsInfo  @"Api/Order/goods_comment"
#define kURLMyOrderCommentSubmit     @"Api/Order/comment_submit"

///我的地址列表
#define kURLMyAddressList   @"Api/Center/myadr"
///我的收藏
#define kURLMyCollect       @"Api/Center/mycollect"
///我的会议
#define kURLMyMeeting       @"Api/Center/mymeet"
///意见反馈
#define kURLFeedBack        @"Api/Center/feedback"
///我的消息
#define kURLMyMessage       @"Api/Center/message"
///消息类型列表 未读消息
#define kURLMyMessageType     @"Api/Center/msglist"
#define kURLMyMessageDelete   @"Api/Center/del_msg"

#define kURLShoppingCartNum   @"Api/Center/get_car_num"

//我的界面
#define kURLMyVHomePage       @"Api/Center/home"

//关于我们

#define kURLAboutOur        @"Api/Webpage/about"
#define kURLRegisterAgreement        @"Api/Webpage/regist_agreement"

#endif /* NetworkMacro_h */
