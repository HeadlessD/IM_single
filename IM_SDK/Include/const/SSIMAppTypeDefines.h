//
//  SSIMAppTypeDefines.h
//  QianbaoIM
//
//  Created by 秦雨 on 17/5/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//
/**
 *  需要对外爆露的类型声明处
 */
#import <Foundation/Foundation.h>
#ifndef QianbaoIM_SSIMAppTypeDefines_h
#define QianbaoIM_SSIMAppTypeDefines_h

/*************************************IM Chat*******************************/



typedef NS_ENUM(NSInteger, E_PLATFORM)
{
    PLATFORM_INVALID = 0,  //未知
    PLATFORM_APP	 = 1,  //客户端
    PLATFROM_WEB 	 = 2   //web端
};

typedef NS_ENUM(NSInteger, APP_ID_TYPE)
{
    APP_ID_TYPE_QB        = 1002,//钱宝公司
};

typedef NS_ENUM(NSInteger, GROUP_MESSAGE_STATUS) {
    GROUP_MESSAGE_STATUS_NORMAL        = 0,//正常
    GROUP_MESSAGE_STATUS_NO_HIT        = 1,//接收消息不提醒
    GROUP_MESSAGE_IN_HELP_NO_HIT       = 2,//收入群助手不提醒
};


typedef NS_ENUM(NSInteger, E_MSG_CHAT_TYPE) {  // 消息类型:
    INVALID             = -1,
    SYS                 = 1,           // 系统消息
    GROUP               = 2,           // 群组消息
    PUBLIC              = 3,           // 公众号消息
    PRIVATE             = 4,           // 私信
    SHOP_BUSINESS       = 5,           // 商家聊天（仅作为客户端生成会话框使用）
    CERTIFY_BUSINESS    = 6,           // 认证商家聊天（仅作为客户端生成会话框使用）
};

typedef NS_ENUM(NSInteger, E_MSG_M_TYPE) {  // 消息内容类型:
    TEXT   = 1,//纯文本，如："abcd emoji表情"
    
    /*
     商品、任务、宝约、游戏、雷拍等消息统一格式（根据情况，id和url需填一个）
     {
     "id": # 跳转id
     "url": # 跳转链接
     "product_name": # 标题
     "desc": # 描述文字
     "main_img": # 图片链接
     "source_img": # 分享来源logo
     "source_txt": # 分享来源名称：宝约、游戏、雷拍等
     }
     */
    
    ITEM   = 2,
    IMAGE  = 3,//图片，如：http://fim.qbao.com/5435110_5504149/6a698dbc426a999bdc1e1389eb69ad84.img
    VOICE  = 4,//语音，如：http://fim.qbao.com/5435110_5504149/5aa8eed6b191817ecb137ef50c568fe7.au
    SMILEY = 5,//动态贴图表情，如：http://im.qbao.com/upload/smiley/5fcab8bd82f04c8ab5904a03173935b3.gif
    JSON   = 6,//自定义json格式，通常用于系统消息，结合E_MSG_S_TYPE解析
    MAP    = 7,//地理位置经纬度，json格式的经纬度信息(address-位置名称，lng-经度, lat-维度) 如：'{"lat": 32.168954, "lng": 118.703751, "address": "江苏省南京市浦口区星火路9号"}'
    VIDEO  = 10,//小视频，如：http://fim.qbao.com/5435110_5504149/5aa8eed6b191817ecb137ef50c568fe7.mov

};

typedef NS_ENUM(NSInteger, E_MSG_S_TYPE) {
    CHAT                              = 0, //普通聊天
    
    /*
     红包消息
     {
     "id": # 红包id
     "desc": # 描述文字
     "type": # 红包类型
     }
     */
    RED_PACKET                        = 1, //红包
    
    /*
     订单消息
     {
     "id": # 订单id,
     "title": # 消息标题,
     "total": # 总价,
     "unit": # 商品价格单位，0：人民币；1：宝币,
     "number": # 商品数量,
     "state": # 订单状态,
     "img_url": # 订单图片url,
     "buyer_id": # 买家id,
     "refund_amount": # 退款金额,
     }
     */
    ORDER                             = 2, //订单
    
    /*
     名片消息
     消息内容：
     {
     "id": 好友id或公众号id
     "type": 名片类型：0：好友，1：公众号
     "showName": 好友昵称或公众号名称
     }
     */
    VCARD                             = 3, //名片
    
    ARTICLE                           = 4,//多图文
    
    
    
    
    
    
    
    
    /*
     仅作为客户端使用的类型，并不作为发送消息使用
     */
    TIP                               = 1001, //操作提示
    GROUP_NEED_AGREE                  = 1002, //需群主同意（去确认）
    GROUP_ADD_AGREE                   = 1003, //群主已同意（已确认）
    PRODUCT_TIP                       = 1004, //商品信息提示
    ORDER_TIP                         = 1005, //订单信息提示

};

typedef NS_ENUM(NSInteger, E_MSG_E_TYPE) {// 消息内容扩展类型:（1~60为语音时间）
    DEFAULT         = 0,    //普通聊天
    LONG_PICTURE    = 101,  //长图
    WIDE_PICTURE    = 102,  //宽图
    SQUARE_PICTURE  = 103,  //长宽相等
};


typedef NS_ENUM(NSInteger, USER_IS_REINSTALL_CLIENT) {// 获取群离线方式
    USER_NORMAL_LOGIN       = 1, //正常获取
    USER_REINSTALL_CLIENT   = 2, //第一次登陆获取
};


typedef NS_ENUM(NSInteger, GROUP_OFFLINE_MSG_IS_FINISH) {// 群离线是否结束
    GROUP_OFFLINE_MSG_NO_FINISH       = 1, //未结束
    GROUP_OFFLINE_MSG_FINISH          = 2, //结束
};

typedef NS_ENUM(NSInteger, NIM_GROUP_SAVE_TYPE) {// 是否保存到通讯录
    NIM_GROUP_SAVE_TYPE_NO      = 0, //默认不保存
    NIM_GROUP_SAVE_TYPE_YES     = 1, //保存到通讯录
};

typedef NS_ENUM(NSInteger, GROUP_CHAT_OFFLINE_TYPE)
{
    GROUP_OFFLINE_CHAT_NORMAL                   = 1,    // 群聊
    GROUP_OFFLINE_CHAT_ADD_USER                 = 2,    // 邀请进群
    GROUP_OFFLINE_CHAT_KICK_USER                = 3,    // 踢人
    GROUP_OFFLINE_CHAT_LEADER_CHANGE            = 4,    // 群主转让
    GROUP_OFFLINE_CHAT_ENTER_AGREE              = 5,    // 邀请需要群主统一
    GROUP_OFFLINE_CHAT_ENTER_DEFAULT            = 6,    // 默认方式
    GROUP_OFFLINE_CHAT_ADD_USER_AGREE           = 7,    // 邀请成员但是需要同意
    GROUP_OFFLINE_CHAT_AGREE                    = 8,    // 群主同意
    GROUP_OFFLINE_CHAT_SCANNING                 = 9,    // 通过扫二维码自己进入
    GROUP_OFFLINE_CHAT_CREATE                   = 10,   // 建群
    GROUP_OFFLINE_CHAT_MODIFY_GROUP_NAME        = 11, 	// 修改群名称
    GROUP_OFFLINE_CHAT_MODIFY_GROUP_REMARK      = 12,   // 修改群公告
    GROUP_OFFLINE_CHAT_MODIFY_GROUP_USER_NAME   = 13, 	// 修改群用户备注
    GROUP_OFFLINE_CHAT_SCAN_ADD_USER            = 14    // 扫描进群

};



typedef NS_ENUM(NSInteger, SourceType) { //预留
    ContactSource            = 0,//0: 通讯录匹配
    InterestSource           = 1,//1: 趣味相投的人
    NearstSource             = 2,//2: 附近的人
    ScanSource               = 3,//3: 扫描二维码
    SearchSource             = 4,//4: 搜索添加
    CardShareSource          = 5,//5: 名片分享
    TaskGeterSource          = 6,//6: 相同任务领取人
    PubAttentionSource       = 7,//7: 公众号关注者添加
    TaskCommetSource         = 8,//8: 任务评论者添加
    SquareSenderSource       = 9,//9: 动态发布者添加
    SquareCommetSource       = 10,//10: 动态评论者添加
    SquarePraiseSource       = 11,//11: 动态点赞者添加
    ChatSource               = 12,//12: 聊天会话页添加
    PubArticleCommetSource   = 13,//13: 公众号文章评论者添加
    GoodsCommetSource        = 14,//14: 商品评论者添加
    PubListSource            = 15,//15: 服务号列表页添加
    PubTextClickSource       = 16,//16: 图文页点击服务号名称添加
    ReferrerSource           = 17,//17: 推荐人自动加好友
    SystemRandomSource       = 18,//18: 系统随机推荐
};


typedef NS_ENUM(NSInteger, UpdataUserType) { //预留

    key_user_name			= 1, // user_name
    key_birthday           	= 2, // birthday
    key_city           		= 3, // city
    key_signature           = 4, // signature
    key_mobile              = 5, // mobile
    key_nick_name           = 6, // nick_name
    key_sex         	    = 7, // sex
    key_mail                = 8, // mail
    key_province           	= 9, // province
};

typedef NS_ENUM(NSInteger, FriendListType) { //预留
    
    FD_FRIEND_OP         =0,
    FD_PEERCONFIRM_OP    =1,
    FD_WAITCONFIRM_OP    =2,
    FD_NEEDCONFIRM_OP    =3,
    FD_OWNCONFIRM_OP     =4,
    FD_REMARK_OP         =5,
    FD_BLACK_OP          =6,
    FD_PEER_DEL_OP       =7,
    FD_OWN_DEL_OP        =8,
    FD_INVALID_OP        =9,
    FD_COMEBACK          =10,
    FD_OUTLAST           =11,
};

typedef NS_ENUM(NSInteger, FriendSourceType) { //预留
    /*
    0: 通讯录匹配
    1: 趣味相投的人
    2: 附近的人
    3: 扫描二维码
    4: 搜索添加
    5: 名片分享
    6: 相同任务领取人
    7: 公众号关注者添加
    8: 任务评论者添加
    9: 动态发布者添加
    10: 动态评论者添加
    11: 动态点赞者添加
    12: 聊天会话页添加
    13: 公众号文章评论者添加
    14: 商品评论者添加
    15: 服务号列表页添加
    16: 图文页点击服务号名称添加
    17: 推荐人自动加好友
    18: 系统随机推荐
*/
    Source = 0,
};

typedef NS_ENUM(NSInteger, FriendBlackType) { //预留
    FD_NOT_BLACK        =0,
    FD_ACTIVE_BLACK     =1,
    FD_PASSIVE_BLACK    =2,
};

typedef NS_ENUM(NSInteger, getUserInfo) { //预留
    Search_AddView      = 2,
    Search_PeedView     = 3,
};



typedef NS_ENUM(NSInteger, SDK_NET_STATUS) {
    SDK_CONNECTED       = 1,//连接成功
    SDK_CLOSED          = 2,//关闭
    SDK_FAILURE         = 3,//连接失败
    SDK_ERROR           = 4,//连接错误
    SDK_BEKICKED        = 5,//被踢
    SDK_LOGINED         = 6,//登录成功
};

typedef NS_ENUM(NSInteger, SDK_MESSAGE_RESULT)
{
    SDK_MESSAGE_OK,                 //发送成功
    SDK_MESSAGE_TIMEOUT,            //消息超时
    SDK_MESSAGE_LOSE,               //消息不全
    SDK_MESSAGE_CT_NOTFOUND,        //消息类型不存在
    SDK_MESSAGE_MT_NOTFOUND,        //消息内容类型不存在
    SDK_MESSAGE_ST_NOTFOUND,        //消息内容子类型不存在
    SDK_MESSAGE_ET_NOTFOUND,        //消息内容扩展类型不存在
    SDK_MESSAGE_USER_NOTFOUND,      //用户不存在
    SDK_MESSAGE_GROUP_NOTFOUND,     //群组不存在
};

typedef NS_ENUM(NSInteger, SDK_PUSH_VC_TYPE) {
    SDK_PUSH_NOTFOUND           = -1,//未知
    SDK_PUSH_Task               = 1,//任务助手
    SDK_PUSH_Subscribe          = 2,//订阅助手
    SDK_PUSH_OfficialList       = 3,//公众号列表
    SDK_PUSH_OfficialChat       = 4,//公众号聊天
    SDK_PUSH_BackHome           = 5,//返回到首页
    SDK_PUSH_RedBag             = 6,//红包界面
    SDK_PUSH_Item               = 7,//商品、宝约等链接
    SDK_PUSH_Favor              = 8,//收藏界面
    SDK_PUSH_Order              = 9,//订单界面
};

typedef NS_ENUM(NSInteger, SDK_CONTACT_TYPE) {
    SDK_CONTACT_TYPE_PRODUCT    = 1,//商品详情联系
    SDK_CONTACT_TYPE_ORDER      = 2,//订单详情联系

};

#endif
