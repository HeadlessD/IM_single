//
//  NIMCurrentUserInfo.m
//  QianbaoIM
//
//  Created by Yun on 14/8/27.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMCurrentUserInfo.h"
//#import "AFHTTPRequestOperationManager.h"
#import "NIMLoginOperationBox.h"

static NIMCurrentUserInfo* info;

@implementation NIMCurrentUserInfo

+ (NIMCurrentUserInfo*)currentInfo
{
    if(info == nil)
    {
        info = [[NIMCurrentUserInfo alloc] init];
    }
    return info;
}

- (void)setDefaultUserInfo:(NSDictionary*)dict//设置用户的基本信息，登录后调用
{
    if(isDictWithCountMoreThan0(dict))
    {
        self.authInfo = dict;
        if(isDictContainKey(dict, @"userId"))
            self.userId  = PUGetObjFromDict(@"userId",       dict, [NSString class]);
        if(isDictContainKey(dict, @"imToken"))
            self.imToken = PUGetObjFromDict(@"imToken",      dict, [NSString class]);
        if(isDictContainKey(dict, @"realName"))
            self.realName  = PUGetObjFromDict(@"realName",   dict, [NSString class]);
        if(isDictContainKey(dict, @"sessionId"))
            self.sessionId = PUGetObjFromDict(@"jSessionId", dict, [NSString class]);
        if(isDictContainKey(dict, @"tGrantingTicket"))
            self.tGrantingTicket = PUGetObjFromDict(@"tgt",  dict, [NSString class]);
        if(isDictContainKey(dict, @"userName"))
            self.userName = PUGetObjFromDict(@"userName",    dict, [NSString class]);
        if(isDictContainKey(dict, @"username"))
            self.userName = PUGetObjFromDict(@"username",    dict, [NSString class]);
        if(isDictContainKey(dict, @"realNameAuthenticated"))
            self.realNameAuthenticated = [PUGetObjFromDict(@"isAuthenticated",  dict, [NSNumber class]) boolValue];
        if(isDictContainKey(dict, @"isSpringFestival"))
            self.isSpringFestival      = [PUGetObjFromDict(@"isSpringFestival", dict, [NSNumber class]) boolValue];
        if(isDictContainKey(dict, @"idCode"))
            self.idCode   = PUGetObjFromDict(@"idCode", dict, [NSString class]);
        self.currentUserFolder = nil;
        self.coreDataIsOk = NO;
        self.bindPhone = PUGetObjFromDict(@"bindingMobile",       dict, [NSString class]);
    }
}

- (void)clearnCurrentInfo//清空当前用户基本信息
{
    self.authInfo = nil;
    self.userId  = nil;
    self.imToken = nil;
    self.realName  = nil;
    self.sessionId = nil;
    self.tGrantingTicket = nil;
    self.userName = nil;
    self.realNameAuthenticated = NO;
    self.isSpringFestival      = NO;
    self.idCode   = nil;
    self.currentUserFolder = nil;
    self.coreDataIsOk = NO;
}

- (BOOL)writeUserInfoToDisk//把用户信息写入磁盘
{
    return [self.authInfo writeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userinfo.plist" ,self.currentUserFolder]] atomically:YES];
}
- (NSDictionary*)readUserInfoFromDisk//从磁盘读取用户基本信息
{
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:self.currentUserFolder]];
    return dic;
}

@end
