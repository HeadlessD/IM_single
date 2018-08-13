//
//  SSIMModel.h
//  qbnimclient
//
//  Created by 秦雨 on 2017/12/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************登录相关******************/
@interface SSIMLogin : NSObject

@property(nonatomic, assign) int64_t user_id;//用户id
@property(nonatomic, assign) int ap_id;//子公司id
@property(nonatomic, strong) NSString* token;//http登陆获取的token

@end

/******************用户相关******************/
@interface SSIMUserInfo : NSObject
@property (nonatomic,strong) NSString * user_userName;       //用户名
@property (nonatomic,strong) NSString * user_birthday;       //生日
@property (nonatomic,strong) NSString * user_mobile;         //手机号
@property (nonatomic,strong) NSString * user_mail;           //邮箱
@property (nonatomic,strong) NSString * user_city;           //城市  男"1" 女"0"
@property (nonatomic,strong) NSString * user_nickName;       //昵称
@property (nonatomic,strong) NSString * user_sex;            //性别
@property (nonatomic,strong) NSString * user_provice;        //省份
@property (nonatomic,strong) NSString * user_signature;      //个人签名

@end

/******************聊天相关******************/


/******************商家相关******************/
@interface SSIMBusinessModel : NSObject
@property(nonatomic, assign) int64_t bid;                   //商家id
@property(nonatomic, assign) int64_t cid;                   //小二id
@property(nonatomic, assign) int bType;                     //商家类型(0:个人商家，1:企业商家)
@property(nonatomic, strong) NSString* avatar;              //头像链接
@property(nonatomic, strong) NSString* name;                //商家名称
@property(nonatomic, strong) NSString* url;                 //商铺链接
@property(nonatomic, strong) NSArray* waiters;              //商家下小二列表

@end

@interface SSIMOrderModel : NSObject
@property (nonatomic, strong) NSString* order_id;           //订单id
@property (nonatomic, strong) NSString* buyer_id;           //买家ID
@property (nonatomic, strong) NSString* seller_id;          //卖家ID
@property (nonatomic, strong) NSString* order_title;        //订单名称
@property (nonatomic, strong) NSString* order_price;        //订单价格
@property (nonatomic, strong) NSString* order_pay;          //订单金额
@property (nonatomic, strong) NSString* order_num;          //订单商品数量
@property (nonatomic, strong) NSString* order_url;          //订单跳转链接
@property (nonatomic, strong) NSString* order_status;       //订单状态
@property (nonatomic, strong) NSString* stateVale;          //订单状态值
@property (nonatomic, strong) NSString* order_img;          //订单图片
@property (nonatomic, strong) NSString* order_list_desc;    //状态描述
@property (nonatomic, strong) NSString* refund_amount;      //退款金额
@property (nonatomic, strong) NSString* refund_id;          //退款id
@property (nonatomic, assign) BOOL refund_order;            //是否为退款
@property (nonatomic, strong) NSString* order_source_img;   //来源图片(可不填)
@property (nonatomic, strong) NSString* order_source_txt;   //订单来源(可不填)
@end

@interface SSIMProductModel : NSObject
@property (nonatomic, strong) NSString* product_id;          //商品id
@property (nonatomic, strong) NSString* main_img;            //商品图片
@property (nonatomic, strong) NSString* product_name;        //商品名称
@property (nonatomic, strong) NSString* product_title;       //商品标题
@property (nonatomic, strong) NSString* product_price;       //商品价格
@property (nonatomic, strong) NSString* product_url;         //商品跳转链接
@property (nonatomic, strong) NSString* stock_num;           //库存量
@property (nonatomic, strong) NSString* product_desc;        //商品描述
@property (nonatomic, strong) NSString* source_img;          //来源图片(可不填)
@property (nonatomic, strong) NSString* source_txt;          //商品来源(可不填)
@end

/******************分享相关******************/
@interface SSIMShareModel : NSObject
@property (nonatomic, strong) NSString* title;              //分享标题
@property (nonatomic, strong) NSString* imgUrl;             //图片
@property (nonatomic, strong) NSString* url;                //跳转链接
@property (nonatomic, strong) NSString* desc;               //描述
@property (nonatomic, strong) NSString* sourceImg;          //分享来源图片（宝约、宝购。。。LOGO）
@property (nonatomic, strong) NSString* sourceTxt;          //分享来源（宝约、宝购。。。）

@end

@interface SSIMArticleModel : NSObject
@property (nonatomic, strong) NSString* title;              //标题
@property (nonatomic, strong) NSString* img_url;            //图片
@property (nonatomic, strong) NSString* url;                //跳转链接
@property (nonatomic, strong) NSString* desc;               //描述
@property (nonatomic, strong) NSString* time;               //时间

@end

/******************红包相关******************/
@interface SSIMRedbagModel : NSObject

@property (nonatomic, assign) BOOL      isSend;           //是否是发红包
@property (nonatomic, assign) BOOL      isGroup;          //是否是群红包
@property (nonatomic, strong) NSString* target_id;        //接受者ID
@property (nonatomic, strong) NSString* send_user_id;     //发送者ID
@property (nonatomic, assign) int       redbag_status;    //0表示未领，1表示已经领取
@property (nonatomic, strong) NSString* redbag_id;        //红包ID
@property (nonatomic, strong) NSString* openUrl;          //红包链接
@property (nonatomic, strong) NSString* open_user_name;   //用户昵称
@property (nonatomic, strong) NSString* redbag_desc;      //红包简介
@property (nonatomic, strong) NSString* redbag_type;      //红包类型
@property (nonatomic, strong) NSString* reSend;           //待定
@property (nonatomic, strong) NSString* desc;             //红包简介
@property (nonatomic, strong) NSString* status;           //红包状态


@end

