#import <Foundation/Foundation.h>


#define HEART_INTERVAL  2*60*1000*1000   //ms

#define kAPI_PREUPLOAD  @"preupload"


typedef NS_ENUM(NSInteger, E_NET_STATUS)
{
    CONNECTING, //连接中
    CONNECTED,  //已连接
    LOGINING,   //登录
    LOGINED,    //登录成功
    LOGINFAIL,  //登录失败
    DISCONNECT, //断开连接
    CLOSING,    //关闭中
    CLOSED,     //关闭
    BEKICKED    //被踢掉
};

typedef NS_ENUM(NSInteger, QIMMessageStatu) {
    QIMMessageStatuNormal         = 0,//发送成功
    QIMMessageStatuIsUpLoading    = 1,//发送之前设置为发送中
    QIMMessageStatuUpLoadFailed   = 2,//发送失败
};

//联系人列表搜索结果
typedef NS_ENUM(NSInteger, NIM_SEARCH_TYPE) {
    NIM_SEARCH_TYPE_NONE        = 0,//无结果
    NIM_SEARCH_TYPE_FRIEND      = 1,//搜索结果仅有好友
    NIM_SEARCH_TYPE_GROUP       = 2,//搜索结果仅有群组
    NIM_SEARCH_TYPE_BOTH        = 3,//搜索结果两者都有
};

typedef NS_ENUM(NSInteger, QIMAudioStatu) {
    QIMMessageStatuNone    = 0,
    QIMMessageStatuPlaying = 1,
    QIMMessageStatuStopped = 2,
};

typedef NS_ENUM(NSInteger, IMGroupRoleType) {
    IMGroupRoleTypeNone             = 0,
    IMGroupRoleTypeBuilder          = 9,
};
//Feed
typedef NS_ENUM(NSInteger, IMFeedContentType) {
    IMFeedContentTypeNone             = 0,
    IMFeedContentTypeText             = 1,
    IMFeedContentTypeImage            = 2,
    IMFeedContentTypeJson             = 3,
};

typedef NS_ENUM(NSInteger, IMFeedSubType) {
    IMFeedSubTypeNone               = 0,
    IMFeedSubTypeImgTxt             = 1,
    IMFeedSubTypeTask               = 2,
    IMFeedSubTypeHtml               = 3,
    IMFeedSubTypeGoods              = 4,
    IMFeedSubTypeGames              = 5,
    IMFeedSubTypeGift               = 6,
};


typedef enum HttpMethod{
    HttpMethodGet,
    HttpMethodPost,
    HttpMethodDelete,
    HttpMethodunPostAndDelete, //带json的delete
}HttpMethod;

typedef NS_OPTIONS(NSUInteger, NETWORK_TYPE)
{
    NETWORK_TYPE_NONE   = 0,
    
    NETWORK_TYPE_2G     = 1,
    
    NETWORK_TYPE_3G     = 2,
    
    NETWORK_TYPE_4G     = 3,
    
    NETWORK_TYPE_5G     = 4, //5G目前为猜测结果
    
    NETWORK_TYPE_WIFI   = 5
};


enum GROUP_IS_ENTER_AGREE
{
    GROUP_ENTER_AGREE_DEFAULT = 0, //默认方式
    GROUP_ENTER_AGREE_USER    = 1, //邀请成员需要群主同意

};


typedef NS_ENUM(NSInteger, CustomType) {// 自定义
    GROUP_OFFLINE_CHAT_EXIT         = 100,
    GROUP_AGREE_ENTER               = 1001,
};


typedef NS_ENUM(NSInteger, MsgBodyIdType) {
    None                = 0,
    PublicPacket        = 1,
    NewFriend           = 2,
    GroupAssistant      = 3,
    SubscribeAssistant  = 4,
    TaskHelper          = 5,
};


//我得任务完成状态大类
typedef enum _TASK_STATUS
{
    TASK_STATUS_ING                 = 1,    //进行中
    TASK_STATUS_FINISHED            = 2,    //已完成
    TASK_STATUS_FAILED              = 3,    //失败
    
    TASK_STATUS_STOP                = 4,    //终止
    TASK_STATUS_ERROR               = 5,    //异常
    
}TASK_STATUS;

//进行中任务子类型
typedef enum _TASK_SUBSTATUS_ING
{
    TASK_SUBSTATUS_ING_TOADYNOFINISHED     = 1,    //今天未完成
    TASK_SUBSTATUS_ING_TODAYFINISHED       = 2,    //今日已完成
}TASK_SUBSTATUS_ING;

typedef enum _TASK_ING_DATASOURCE
{
    TASK_ING_DATASOURCE_RECVLIST           = 0,      //来源于领取列表
    TASK_ING_DATASOURCE_TASKHELPER         = 1,      //来源于任务助手
    
}TASK_ING_DATASOURCE;

//任务结算状态
typedef enum _TASKFINISH_REWARDSTATUS
{
    TASK_SUBSTATUS_FINISHED_ALL             = -1,
    TASKFINISH_REWARDSTATUS_WILL            = 0,   //完成待结算
    TASKFINISH_REWARDSTATUS_REWARDED        = 1,   //已经结算
}TASKFINISH_REWARDSTATUS;

typedef enum _TASKACTIVE_FLAG
{
    TASKACTIVE_FLAG_ACTIVE      = 1,        //上架
    TASKACTIVE_FLAG_UNACTIVE    = 2,        //下架
}TASKACTIVE_FLAG;

typedef enum _COMMENT_SOURCE
{
    COMMENT_SOURCE_TASKPANNEL   = 1,
    COMMENT_SOURCE_CARPANNEL    = 2,
}COMMENT_SOURCE;

//QBMyTaskViewController的表示类型，任务或者分销。
typedef enum _MY_TASK_VIEWCT_TYPE
{
    CONTROLLER_TYPE_TASK   = 0,
    CONTROLLER_TYPE_DISTRIBUTION    = 1,
}MY_TASK_VIEWCT_TYPE;

//广告类型
typedef enum _TASKADSTYPE
{
    TASKADSTYPE_PIC     = 1,
    TASKADSTYPE_VEDIO   = 2,
}TASKADSTYPE;

//1，体验任务 2，会员任务 3，VIP任务 4，新用户体验任务 5，推荐任务 6，专题任务 7，临时任务 8，国庆专题任务 9，CPA体验任务 10，专题任务 任务改版后：11，广告任务 12，体验任务 13，问卷任务
typedef enum _TASKTYPE
{
    TASKTYPE_INVALID        = -1,
    
    TASKTYPE_HOT            = 0,
    
    TASKTYPE_EXPER          = 1,            //体验任务
    TASKTYPE_MEMBER         = 2,            //会员任务
    TASKTYPE_VIP            = 3,            //vip任务
    TASKTYPE_NEWEXPER       = 4,            //新用户体验任务
    TASKTYPE_RECOMMEND      = 5,            //推荐任务
    TASKTYPE_SPECIAL        = 6,            //专题任务
    TASKTYPE_TEMP           = 7,            //临时任务
    TASKTYPE_GUOQING        = 8,            //国庆任务
    TASKTYPE_CPAEXPER       = 9,            //CPA体验任务
    TASKTYPE_SPECIALACTION  = 10,           //专题活动
    TASKTYPE_ADS            = 11,           //广告任务
    TASKTYPE_EXPER2         = 12,           //体验任务（现在采用，废弃1）
    TASKTYPE_QUESTION       = 13,
    //    TASKTYPE_QUESTION   = 8, //问卷任务    //问卷任务
    //    TASKTYPE_ZERO   = 9,    //0保证金
    TASKTYPE_SHARE          = 15,            //分享任务
    TASKTYPE_FULI           = 16,            //福利任务
}TASKTYPE;



//主题色
typedef enum _THEME_COLOR
{
    THEME_COLOR_RED,                    //红色
    THEME_COLOR_GRID,                   //格子
    THEME_COLOR_WHITHE,                 //白色
    THEME_COLOR_WHITHE_K,
    THEME_COLOR_WHITHE_D,                 //白色
    THEME_COLOR_BLACK,                  //黑色
    THEME_COLOR_TRANSPARENT_PINK,       //透明,左右粉
    THEME_COLOR_TRANSPARENT_LIGHTGRAY,  //透明,左右灰
    THEME_COLOR_TRANSPARENT_WHITE,      //透明,左右白
    THEME_COLOR_RED_NO_BACKICON,        //红色无返回箭头
    THEME_COLOR_WHITHE_NO_BACKICON,        //白色无返回箭头
    THEME_COLOR_BUSINESS,               //商家
    THEME_COLOR_BUSINESS_GRID,          //商家格子
    THEME_COLOR_BUSINESS_TRANSPARENT,
    THEME_COLOR_UNENABLED,
    THEME_COLOR_BUSINESS_UNENABLED,
    THEME_COLOR_RED_PACKET, //红包
    THEME_COLOR_BAOYUE,//宝约
    THEME_COLOR_ZHUSHOU,//钱宝助手
    THEME_COLOR_COOLYA,//钱宝医生
    
}THEME_COLOR;

enum QBIMErrorCode {
    QBIMErrorCommandDisconnectTypeAuthFailed           = -1,
    QBIMErrorCommandDisconnectTypeLoginOnAnotherDevice = -2,
    QBIMErrorCommandDisconnectTypeServerBusy           = -3,
    QBIMErrorOk                                        = 1000,///< 正确，无错误
    QBIMErrorNeedUpdate                                = 1001,//当前接口弃用需要客户端强制升级
    QBIMErrorMaintenancing                             = 1002,//维护中
    QBIMErrorNewAPI                                    = 1003,//当前访问的接口有新版本可使用
    QBIMErrorJsessionInvalid                           = 1004,//jsession失效
    QBIMErrorAbnormal                                  = 1005,//接口异常或错误
    
    QBIMErrorConnect                                   = 2,///< 网络连接错误
    QBIMErrorData                                      = 3,///< 数据错误
    QBIMErrorParameter                                 = 4,///参数错误
    QBIMErrorLoginInfoError                            = 11,///100508名或密码错误
    QBIMErrorDisconnect                                = 101,///服务器断开
    
    // add by shiji
    // 添加订单失败信息
    /*
     100501：查询交易密码失败
     100502：未设置交易密码
     100503：未绑定银行卡
     100504：交易密码不正确
     100505：余额不足
     100506：密码校验失败
     100507：失败次数过多限制使用
     100508：重复支付
     100509：宝币余额不足
     100510：宝券余额不足
     100511：扫码失败
     1005021：未绑定手机号
     */
    QBIMErrorFailedSearchTradePWD                          = 100501,
    QBIMErrorNotBindTradePWD                          = 100502,
    QBIMErrorNotBindBankCard                          = 100503,
    QBIMErrorInvalidTradePWD                          = 100504,
    QBIMErrorMoneyLess                                = 100505,
    QBIMErrorPwdFailed                                = 100506,
    QBIMErrorLimitInputPWD                            = 100507,
    QBO2OErrorDuplicatePay                            = 100508,
    QBO2OErrorLackBaoBi                               = 100509,
    QBO2OErrorLackBaoQuan                             = 100510,
    QBO2OErrorScanFailed                              = 100511,
    QBO2OErrorUnBindPhone                             = 1005021,
    QBO2OErrorOUTOFRAGE = 3502,
    QBO2OErrorOVERTIME  = 3503,
};

typedef NS_ENUM(NSInteger, NIM_MESSAGE_MODE)
{
    MESSAGE_MODE_SOUND,       //声音
    MESSAGE_MODE_SHOCK,       //振动
    MESSAGE_MODE_BOTH,        //声音加振动
    MESSAGE_MODE_NONE         //无声音加振动

};

typedef NS_ENUM(NSInteger, NIM_INGROUP_STATUS) //我在群中状态
{
    NIM_INGROUP_STATUS_NORMAL,  //正常
    NIM_INGROUP_STATUS_BANNED,  //被踢
    NIM_INGROUP_STATUS_EXIT,    //主动退群
};


typedef NS_ENUM(NSInteger, NIM_GROUP_TIP_MODE) // 群操作关于黑名单和对方把我删除提示
{
    NIM_GROUP_TIP_MODE_BLACK    = 1,     //全为黑名单
    NIM_GROUP_TIP_MODE_DELETE   = 2,     //全为被对方删除好友
    NIM_GROUP_TIP_MODE_BOTH     = 3,     //黑名单和被对方删除好友结合
};



typedef NS_ENUM(NSInteger, NIMFriendshipType) {
    FriendShip_NotFriend                = 0,
    FriendShip_IsMe                     = 1,
    FriendShip_Ask_Peer                 = 2,
    FriendShip_Ask_Me                   = 3,
    FriendShip_Consent_Peer             = 8,
    FriendShip_UnilateralFriended       = 9,
    FriendShip_Friended                 = 10,
    FriendShip_Outlast                  = 11,
    FriendShip_MobileRecommend          = 12
    
};

typedef NS_ENUM(NSInteger, NIMFDBlackShipType) {
    FD_BLACK_NOT_BLACK                = 0,
    FD_BLACK_PASSIVE_BLACK            = 1,
    FD_BLACK_ACTIVE_BLACK             = 2,
    FD_BLACK_MUTUAL_BLACK             = 3,
};


typedef NS_ENUM(NSInteger, ADD_TYPE)
{
    FD_ADD_TYPE_CONTACTS = 0,                       // 通讯录匹配
    FD_ADD_TYPE_CONGENIAL = 1,                      // 趣味相投的人
    FD_ADD_TYPE_NEARBY = 2,                         // 附近的人
    FD_ADD_TYPE_QRCODE = 3,                         // 扫描二维码
    FD_ADD_TYPE_SEARCH = 4,                         // 搜索添加
    FD_ADD_TYPE_VCARD = 5,                          // 名片分享
    FD_ADD_TYPE_SAME_TASK = 6,                      // 相同任务领取人
    FD_ADD_TYPE_PUBLIC_FOLLOW = 7,                  // 公众号关注者添加
    FD_ADD_TYPE_TASK_COMMENT = 8,                   // 任务评论者添加
    FD_ADD_TYPE_PUBLISHER = 9,                      // 动态发布者添加
    FD_ADD_TYPE_PUBLISH_COMMENT = 10,               // 动态评论者添加
    FD_ADD_TYPE_PUBLISH_LIKE = 11,                  // 动态点赞者添加
    FD_ADD_TYPE_CHATTING = 12,                      // 聊天会话页添加
    FD_ADD_TYPE_PUBLIC_COMMENT = 13,                // 公众号文章评论者添加
    FD_ADD_TYPE_COMMODITY_COMMENT = 14,             // 商品评论者添加
    FD_ADD_TYPE_SEVRICE_LIST = 15,                  // 服务号列表页添加
    FD_ADD_TYPE_SEARCHER = 16,                      // 图文页点击服务号名称添加
    FD_ADD_TYPE_RECOMMEND = 17,                     // 推荐人自动加好友
    FD_ADD_TYPE_SYSTEM_RANDOM = 18,                 // 系统随机推荐
};


typedef NS_ENUM(NSInteger, NIMChatUIType)//聊天界面底部宫格显示
{
    NIMChatUIType_NORMAL              = 0,  //普通聊天
    NIMChatUIType_BUSINESS            = 1,  //个人商家聊天
    NIMChatUIType_OFFCIAL             = 2,  //企业商家／公众号
};

typedef NS_ENUM(NSInteger, NIMMessage_OP_Type)//聊天界面底部宫格显示
{
    NIMMessage_OP_Type_ADD              = 0,  //写入内存
    NIMMessage_OP_Type_UPDATE           = 1,  //更新内存
    NIMMessage_OP_Type_RELOAD           = 2,  //更新内存
};

typedef NS_ENUM(NSInteger, Moments_Content_Type)//朋友圈内容类型
{
    Moments_Content_Type_Text           = 10,  //纯文本
    Moments_Content_Type_TextImg        = 20,  //图文
    Moments_Content_Type_Video          = 30,  //视频
    Moments_Content_Type_Web            = 40,  //网页
    Moments_Content_Type_AD             = 50,  //广告
};

typedef NS_ENUM(NSInteger, Moments_Priv_Type)//朋友圈内容类型
{
    Moments_Priv_Type_Pub            = 1,  //公开
    Moments_Priv_Type_Pri            = 2,  //秘密
    Moments_Priv_Type_White          = 3,  //白名单
    Moments_Priv_Type_Black          = 4,  //黑名单
};

typedef NS_ENUM(NSInteger, Comment_Type)//朋友圈内容类型
{
    Comment_Type_Comment            = 1,  //普通评论
    Comment_Type_Like               = 2,  //点赞
};

typedef NS_ENUM(NSInteger, Moments_Scope)//朋友圈查看范围
{
    Moments_Scope_All               = 0,  //全部
    Moments_Scope_Day               = 1,  //最近三天
    Moments_Scope_Year              = 2,  //最近半年

};

typedef NS_ENUM(NSInteger, List_Type)//朋友圈查看范围
{
    List_Type_Black                 = 1,  //黑名单
    List_Type_NotCare               = 2,  //不关注
};

typedef NS_ENUM(NSInteger, FILE_TYPE)//上传文件类型
{
    FILE_TYPE_AUDIO                 = 1,  //语音
    FILE_TYPE_IMAGE                 = 2,  //图片
    FILE_TYPE_VIDEO                 = 3,  //视频

};

