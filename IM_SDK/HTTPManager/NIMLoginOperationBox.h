//
//  NIMLoginOperationBox.h
//  QianbaoIM
//
//  Created by liunian on 14/9/24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMOperationBox.h"


static NSString *wapLoginCallBackNotification = @"wapLoginCallBackNotification";

@interface NIMLoginOperationBox : NIMOperationBox
/**
 *  第三方授权token
 */
@property (nonatomic, strong) NSString *tGrantingTicket;
/**
 *  cas授权token
 */
@property (nonatomic, strong) NSString *imToken;

//查服务器配置是否要显示红包
@property (nonatomic, assign,readonly) BOOL     isShowRedPacket;

@property (nonatomic, assign) BOOL     baoyueloginSuccess;
@property (nonatomic, assign) BOOL     banyanloginSuccess;
@property (nonatomic, strong) NSString *pqb_baoyuest;
SingletonInterface(NIMLoginOperationBox);

/**
 *  登录钱宝服务器
 *
   name          用户名
   password      密码
   completeBlock 登录完成的Block
 */
- (void)loginWithUsername:(NSString *)name password:(NSString *)password type:(NSInteger)type completeBlock:(CompleteBlock)completeBlock;

@end

