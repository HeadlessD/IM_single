//
//  SSIMUserManager.m
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/15.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "SSIMUserManager.h"
#import "NIMLatestVcardViewController.h"
#import "NIMSelfViewController.h"
#import "SSIMAppTypeDefines.h"

@interface SSIMUserManager()

@property(nonatomic,strong)NSMutableDictionary *blockDict;

@end

@implementation SSIMUserManager


SingletonImplementation(SSIMUserManager)

-(instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvChangeUserInfo:) name:NC_SDK_USER object:nil];
        self.blockDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

//上传用户信息
-(void)userUpdateUserInfoRQ:(SSIMUserInfo *)userInfo resultBlock:(SSIMUserBlock)resultBlock{
    int packetID = [NIMBaseUtil getPacketSessionID];

    [self.blockDict setObject:resultBlock forKey:@(packetID)];
    NSMutableArray * userInfoArr = [NSMutableArray array];
    NSString * dateBir = [SSIMSpUtil creatTimeWithBirthday:userInfo.user_birthday];
    [userInfoArr addObject:@{@(key_birthday):dateBir}];
    [userInfoArr addObject:@{@(key_city):userInfo.user_city}];
    [userInfoArr addObject:@{@(key_nick_name):userInfo.user_nickName}];
    [userInfoArr addObject:@{@(key_sex):userInfo.user_sex}];
    [userInfoArr addObject:@{@(key_province):userInfo.user_provice}];
    [userInfoArr addObject:@{@(key_signature):userInfo.user_signature}];
    //    [userInfoArr addObject:@{@(key_user_name):userInfo.user_userName}];
    //    [userInfoArr addObject:@{@(key_mobile):userInfo.user_mobile}];
    //    [userInfoArr addObject:@{@(key_mail):userInfo.user_mail}];

    [[NIMUserOperationBox sharedInstance]sendUpdateUserInfoRQ:userInfoArr sessionID:packetID];
}

//修改用户手机号
-(void)userChangeMobileWithOldMb:(NSString *)oldMb newMb:(NSString *)newMb resultBlock:(SSIMUserBlock)resultBlock{
    int packetID = [NIMBaseUtil getPacketSessionID];
    [self.blockDict setObject:resultBlock forKey:@(packetID)];
    [[NIMUserOperationBox sharedInstance]sendChangeoldMobileRQ:oldMb newMobile:newMb sessionID:packetID];
}

//修改用户邮箱
-(void)userChangeMailWithOldMa:(NSString *)oldMa newMa:(NSString *)newMa resultBlock:(SSIMUserBlock)resultBlock{
    int packetID = [NIMBaseUtil getPacketSessionID];
    [self.blockDict setObject:resultBlock forKey:@(packetID)];
    [[NIMUserOperationBox sharedInstance]sendChangeOldMailRQ:oldMa newMail:newMa sessionID:packetID];
}

//传入专属邀请码和邀请链接
-(void)userSendInviteUrl:(NSString *)inviteUrl andDescSms:(NSString *)descSms{
    [[NIMUserOperationBox sharedInstance]sendInviteUrl:inviteUrl andDescSms:descSms];
}

//跳转个人中心界面
-(void)userPushToPersonalWithType:(int)type userId:(NSString *)userId navi:(UINavigationController *)navi{
    NIMSelfViewController *selfVC = [[NIMSelfViewController alloc]init];
    selfVC.feedSourceType = type;
    selfVC.searchContent = userId;
    [navi pushViewController:selfVC animated:YES];
}

-(void)recvChangeUserInfo:(NSNotification * )noti{
    NSDictionary * noDic = noti.object;
    SSIMUserBlock userCall = [self.blockDict objectForKey:[noDic objectForKey:@"sessionID"]];
    userCall([[noDic objectForKey:@"result"]boolValue],[noDic objectForKey:@"error"]);
    [self.blockDict removeObjectForKey:[noDic objectForKey:@"sessionID"]];
}

@end
