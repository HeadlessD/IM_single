//
//  NIMNetAPIDefines.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/7/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#ifndef NIMNetAPIDefines_h
#define NIMNetAPIDefines_h


//TCP服务器IP地址
#define SERVER_DOMAIN_IM_SOCKET                               @"39.104.84.2"//221.228.203.11、192.168.131.41
#define SERVER_DOMAIN_IM_PORT                                 8001
#define HMACSHA1_KEY                                          @"yuanqq"//Pqb+E73fEMj8O


#define kMapAppkey                                            @"Q87wzCOqtSctovdw0QS77pkRnGeUbTo2"


#define SERVER_QB                                             @"http://m.qbao.com"     //钱宝 产品服务器
#define SERVER_USER_QB                                        @"http://user.qbao.com"   //钱宝 产品服务器
#define SERVER_QW                                             @"http://passport.qbao.com"  //钱旺 产品服务器
#define SERVER_API_USER                                       @"http://api.user.qbao.com"

#define SERVER_UCSLAVE_USER                                   @"http://ucslaveapi.qbao.com"

#define SERVER_SELF_USER                                      @"https://m.qbao.com"

//https://m.qbao.com/api/v30/userinfo4Client/getUserInfo

#define SERVER_LOGINAPI_USER                                  @"http://loginapi.qbao.com"
#define SERVER_ENTERPRISE                                     @"http://enterprise.qbao.com"
#define SERVER_GET_ORDERS                                     @"http://oc.qbao.com"

#define SERVER_DOMAIN_IM_HTTP                                 @"http://im.qbao.com/api/"
#define SERVER_QB                                             @"http://m.qbao.com"     //钱宝 产品服务器

#define SERVER_ACTIVE_QB                                      @"http://m.task.qbao.com"
#define SESSION_REDENVELOP_QB                                 @"http://fhb.qbao.com"
#define SESSION_COUPONS_QB                                    @"http://coupon.qbao.com"
#define SERVER_USER_QB                                        @"http://user.qbao.com"   //钱宝 产品服务器

//钱宝-通讯录-添加好友-添加趣味相投的人
#define SERVERURL_interestList                              URLSTRINGFORMAT(SERVER_DOMAIN_V32,@"account4Client/interestList")

//我的推广-推广好友
#define SERVERURL_spreadContent                             URLSTRINGFORMAT(SERVER_DOMAIN_V30,@"spread4Client/spreadContent")

//新版签到登陆
#define SERVER_SIGN                                            URLSTRINGFORMAT(SERVER_SIGN_QB,API)

#define SERVER_DOMAIN_V10                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_10)
#define SERVER_DOMAIN_V20                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_20)
#define SERVER_DOMAIN_V30                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_30)
#define SERVER_DOMAIN_V30_TASK                                 URLSTRINGFORMAT(SERVER_ACTIVE_QB,API_VERSION_30)
//add by wxj
#define SERVER_DOMAIN_HTTPS_V30                                URLSTRINGFORMAT(SERVER_HTTPSMQB,API_VERSION_30)
#define SERVER_DOMAIN_V31                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_31)
#define SERVER_DOMAIN_V40                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_40)
#define SERVER_DOMAIN_V23                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_23)
#define SERVER_DOMAIN_V32                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_32)
#define SERVER_DOMAIN_V33                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_33)

#define SERVER_DOMAIN_ACT_34                                   URLSTRINGFORMAT(SERVER_ACTIVE_QB,API_VERSION_ACT_34)

/**************************************钱宝Rest API 版本控制区*************************************************/
#define URLSTRINGFORMAT(STRA,STRB)                            [NSString stringWithFormat:@"%@/%@",STRA,STRB]
#pragma mark - 钱宝 api版本号

#define URLSTRINGFORMAT(STRA,STRB)                            [NSString stringWithFormat:@"%@/%@",STRA,STRB]

#define API                                                  @"api"
#define VERSION_10                                           @"v10"
#define VERSION_11                                           @"v11"
#define VERSION_30                                           @"v30"
#define VERSION_31                                           @"v31"
#define VERSION_40                                           @"v40"
#define VERSION_32                                           @"v32"
#define VERSION_33                                           @"v33"
#define VERSION_34                                           @"v34"
#define VERSION_35                                           @"v35"


#define API_VERSION_10                                       URLSTRINGFORMAT(API,VERSION_10)
#define API_VERSION_11                                       URLSTRINGFORMAT(API,VERSION_11)
#define API_VERSION_30                                       URLSTRINGFORMAT(API,VERSION_30)
#define API_VERSION_31                                       URLSTRINGFORMAT(API,VERSION_31)
#define API_VERSION_40                                       URLSTRINGFORMAT(API,VERSION_40)
#define API_VERSION_32                                       URLSTRINGFORMAT(API,VERSION_32)
#define API_VERSION_33                                       URLSTRINGFORMAT(API,VERSION_33)
#define API_VERSION_34                                       URLSTRINGFORMAT(API,VERSION_34)
#define API_VERSION_35                                       URLSTRINGFORMAT(API,VERSION_35)



#define QB_TICKETS      @"tickets"

/*****************************即时聊天相关url声明************************************/
#define kTaskHelperThread           @"1:2014:386864"        //首页任务助手thread
#define kPublicPacketThread         @"2:2014:386864"        //首页公众账号thread
#define kGroupAssistantThread       @"3:2014:386864"        //首页群助手thread
#define kNewFriendThread            @"4:2014:386864"        //首页新的朋友thread
#define kShopThread                 @"5:2014:386864"        //首页我的店铺thread
#define kSubscribeThread            @"6:2014:386864"        //首页订阅助手thread

#define kSystemID                   1000                    //系统消息公众号id

/*****************************TCP文件服务器************************************/

#define USER_ICON_DEFAULT         [UIImage imageNamed:@"fclogo"]


#define SERVER_FIM_HTTP             @"http://39.104.84.2:8088"     //文件服务器


#define USER_ICON_URL(userid)                                 [NSString stringWithFormat:@"%@/%lld.head",SERVER_FIM_HTTP,userid]

#define GROUP_ICON_URL(groupid)                               [NSString stringWithFormat:@"http://39.104.84.2:8088/group/1_%lld.icon",groupid]

#define ARTICLE_IMAGE_UPLOAD(articleId,index) [NSString stringWithFormat:@"%@/uploadmoments?user_id=%lld&message_id=%lld&index=%d",SERVER_FIM_HTTP,OWNERID,articleId,index]

#define DF_CACHEPATH [NSString stringWithFormat:@"%@/%@",[DFSandboxHelper getDocPath], @"dfCache/"]

#endif /* NIMNetAPIDefines_h */
