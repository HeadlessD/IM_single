//
//  NIMUserProcessor.h
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMBaseProcessor.h"
#import "NetCenter.h"
#import "NIMUserStruct.h"

@interface NIMUserProcessor : NIMBaseProcessor

//获取个人用户信息包
-(void)sendGetSelfInfoRQ:(NSString *)meToken;

//获取用户信息包
-(bool)sendUserInfoRQ:(NSString *)searchContent type:(int32)type;

//批量获取用户信息
-(void)sendUserInfoListRQ:(NSMutableArray *)userInfos phone:(NSMutableArray *)phones;

//更新用户信息
-(void)sendUpdateUserInfoRQ:(NSMutableArray *)userInfos sessionID:(int)sessionID;

//发送推送注册信息
-(void)sendRegisterApnsRQ:(NSData *)deToken;

//设置单聊消息免打扰
-(void)sendSingleChatStatusWithUserid:(int64_t)userid status:(int)status;

//获取免打扰好友
-(void)getUserStatus;

//举报用户
-(void)sendReportUserID:(int64_t)userID type:(int32)cpType reason:(NSString *)cpReason;

//修改用户邮箱
-(void)sendChangeOldMailRQ:(NSString *)oldMail newMail:(NSString *)newMail sessionID:(int)sessionID;

//修改用户手机号
-(void)sendChangeoldMobileRQ:(NSString *)oldMobile newMobile:(NSString *)newMobile sessionID:(int)sessionID;


@end
