//
//  SSIMUserManager.h
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/15.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SSIMUserBlock)(BOOL result,NSString * error);

@interface SSIMUserManager : NSObject

//单例初始化
+ (instancetype)sharedInstance;

//上传用户信息
-(void)userUpdateUserInfoRQ:(SSIMUserInfo *)userInfo resultBlock:(SSIMUserBlock)resultBlock;

//修改用户手机号
-(void)userChangeMobileWithOldMb:(NSString *)oldMb newMb:(NSString *)newMb resultBlock:(SSIMUserBlock)resultBlock;

//修改用户邮箱
-(void)userChangeMailWithOldMa:(NSString *)oldMa newMa:(NSString *)newMa resultBlock:(SSIMUserBlock)resultBlock;

//传入专属邀请码和邀请链接
-(void)userSendInviteUrl:(NSString *)inviteUrl andDescSms:(NSString *)descSms;

//跳转个人中心界面
-(void)userPushToPersonalWithType:(int)type userId:(NSString *)userId navi:(UINavigationController *)navi;

@end
