//
//  NIMUserOperationBox.h
//  qbim
//
//  Created by 秦雨 on 17/2/17.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMUserOperationBox : NSObject
SingletonInterface(NIMUserOperationBox)

//用户注册
-(void)fcUserregisterUserName:(NSString * )userName passWord:(NSString * )passWord;

//获取个人用户信息包
-(void)sendGetSelfInfoRQ:(NSString *)meToken;
-(void)recvGetSelfInfoRS:(QBUserInfoPacket *)userInfoPack;

//获取用户信息
-(void)sendUserInfo:(NSString*)searchContent type:(int32)type;
-(void)recvUserInfoRS:(QBUserInfoPacket *)userInfoPack type:(int32)type;

//批量获取用户信息
-(void)sendUserInfoListRQ:(NSMutableArray *)userInfos phone:(NSMutableArray *)phones;
-(void)recvUserInfoListRS:(NSMutableArray *)userInfos phone:(NSMutableArray *)phones;

//更新用户信息
-(void)sendUpdateUserInfoRQ:(NSMutableArray *)userInfos sessionID:(int)sessionID;
-(void)recvUpdateUserInfoRS:(NSMutableArray *)userInfos;

-(void)searchUser:(NSNotification*)noti;

//推送注册
-(void)sendRegisterApnsRQ:(NSData *)deToken;
-(void)recvRegisterApnsRQ;

//设置单聊消息免打扰
-(void)sendSingleChatStatusWithUserid:(int64_t)userid status:(int)status;

//获取免打扰好友
-(void)getUserStatus;

//举报用户
-(void)sendReportUserID:(int64_t)userID type:(int32)cpType reason:(NSString *)cpReason;
-(void)recvReportUserID:(int64_t)userID type:(int32)cpType reason:(NSString *)cpReason;

//修改用户邮箱
-(void)sendChangeOldMailRQ:(NSString *)oldMail newMail:(NSString *)newMail sessionID:(int)sessionID;
-(void)recvChangeOldMailRS:(QBTransParam *)trans_param;

//修改用户手机号
-(void)sendChangeoldMobileRQ:(NSString *)oldMobile newMobile:(NSString *)newMobile sessionID:(int)sessionID;
-(void)recvChangeOldMobilRS:(QBTransParam *)trans_param;

//传入专属邀请码和邀请链接
-(void)sendInviteUrl:(NSString *)inviteUrl andDescSms:(NSString *)descSms;


@end
