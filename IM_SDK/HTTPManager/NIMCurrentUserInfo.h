//
//  NIMCurrentUserInfo.h
//  QianbaoIM
//
//  Created by Yun on 14/8/27.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMLoginUserInfo.h"
//#import "LoginUser.h"

@class NIMCurrentUserInfo;

typedef void (^NIMCurrentUserInfoCallbackBlock)(BOOL loginStatus);

@interface NIMCurrentUserInfo : NIMLoginUserInfo
@property (nonatomic, strong) NSString* currentUserFolder;
@property (nonatomic, strong) NSDictionary *authInfo;
@property (nonatomic, assign) BOOL coreDataIsOk;
@property (nonatomic) BOOL firstLogin;

+ (NIMCurrentUserInfo*)currentInfo;

- (void)setDefaultUserInfo:(NSDictionary*)dict;//设置用户的基本信息，登录后调用
- (void)clearnCurrentInfo;//清空当前用户基本信息
- (BOOL)writeUserInfoToDisk;//把用户信息写入磁盘
- (NSDictionary*)readUserInfoFromDisk;//从磁盘读取用户基本信息

@end
