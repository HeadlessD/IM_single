//
//  NIMLoginUserInfo.h
//  QianbaoIM
//
//  Created by liu nian on 14-4-24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//
#import "NIMSingelton.h"


@interface NIMLoginUserInfo : NSObject
@property (nonatomic, copy) NSString *accountType;


@property (nonatomic, retain) NSString      *userName;
@property (nonatomic, retain) NSString      *userId;
@property (nonatomic, retain) NSString      *imToken;
@property (nonatomic, retain) NSString      *sessionId;
@property (nonatomic, retain) NSString      *tGrantingTicket;
@property (nonatomic, retain) NSString      *realName;
@property (nonatomic, assign) BOOL          realNameAuthenticated;

@property (nonatomic, assign) BOOL          isSpringFestival;    //是否春节活动
@property (nonatomic, retain) NSString      *idCode;

@property (nonatomic, retain) NSString      *lat;
@property (nonatomic, retain) NSString      *lon;
@property (nonatomic, strong) NSString      *cookie;
@property (nonatomic, strong) NSDictionary  *authInfo;

@property (nonatomic, strong) NSString      *setcookie;
SingletonInterface(NIMLoginUserInfo);

//邦定的手机号码
@property (nonatomic,strong) NSString       *bindPhone;
@property (nonatomic,strong) NSString       *avatar;

//key 为对应的一级域名(统一带http或https 开头) 值为cookies
@property (nonatomic,readonly) NSDictionary  *cookies;


//3.0

+ (id)createWithDict:(NSDictionary *)dict;

- (void)clearCookie;

//根据域名添加cookie 域名统一使用http或https全域名
- (void)addCookie:(NSString *)cookie withDomain:(NSString *)domain;
//根据域名获取cookie
- (NSString *)getDomainCookie:(NSString *)domain;
//根据域名清除cookie
- (void)cleanCookieForDomain:(NSString *)domain;

@end
