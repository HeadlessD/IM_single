//
//  NIMUserOperationBox.m
//  qbim
//
//  Created by 秦雨 on 17/2/17.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMUserOperationBox.h"
#import "NIMGlobalProcessor.h"
#import "NIMManager.h"

#import "NIMSearchUserManager.h"

#import "PinYinManager.h"

@implementation NIMUserOperationBox
SingletonImplementation(NIMUserOperationBox)

-(void)fcUserregisterUserName:(NSString * )userName passWord:(NSString * )passWord{
    
}

#pragma mark 获取个人用户信息
-(void)sendGetSelfInfoRQ:(NSString *)meToken{
    [[NIMGlobalProcessor sharedInstance].user_processor sendGetSelfInfoRQ:meToken];
}

-(void)recvGetSelfInfoRS:(QBUserInfoPacket *)userInfoPack
{
    NSManagedObjectContext * privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    int64_t msg_time = [NIMBaseUtil GetServerTime];
    VcardEntity *  vcard = [VcardEntity instancetypeFindUserid:userInfoPack.searchUserid];
    
    if (!vcard) {
        vcard = [VcardEntity NIM_createEntity];
        vcard.userid = userInfoPack.searchUserid;
    }
    
    vcard.signature = userInfoPack.signature;
    vcard.birthday = userInfoPack.birthday;
    vcard.localtionCity = userInfoPack.city;
    vcard.locationPro = userInfoPack.province;
    vcard.age =  [[SSIMSpUtil creatBirthdayWithtime:userInfoPack.birthday] intValue];
    vcard.mail = userInfoPack.mail;
    vcard.sex = userInfoPack.userSex;
    vcard.mobile = userInfoPack.mobile;
    vcard.nickName = userInfoPack.nickName;
    vcard.userName = userInfoPack.username;
    vcard.avatar300 = userInfoPack.avatarPic300;
    vcard.ct = msg_time/1000;
    vcard.userToken = userInfoPack.userToken;
    
    if (userInfoPack.avatarPic) {
        vcard.avatar = userInfoPack.avatarPic;
    }
    
    vcard.avatar = USER_ICON_URL(vcard.userid);
    
    [privateContext MR_saveToPersistentStoreAndWait];
    DBLog(@"%hd",vcard.age);
    //    [[NIMSearchUserManager sharedInstance] getSelfInfoFailureSearchCon:[NSString stringWithFormat:@"%lld",OWNERID] errorStr:@"dsds"];
    [[NIMSearchUserManager sharedInstance] getSelfInfoSuccessPacket:userInfoPack.searchUserid];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginTCP" object:nil];
}

#pragma mark 获取用户信息
-(void)sendUserInfo:(NSString*)searchContent type:(int32)type{
    [[NIMGlobalProcessor sharedInstance].user_processor sendUserInfoRQ:searchContent type:type];
}

-(void)recvUserInfoRS:(QBUserInfoPacket *)userInfoPack type:(int32)type{
    
    NSManagedObjectContext * privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    int64_t msg_time = [NIMBaseUtil GetServerTime];
    
    
    VcardEntity *  vcard = [VcardEntity instancetypeFindUserid:userInfoPack.searchUserid];
    
    if (!vcard) {
        vcard = [VcardEntity NIM_createEntity];
        vcard.userid = userInfoPack.searchUserid;
    }
    
    vcard.signature = userInfoPack.signature;
    vcard.birthday = userInfoPack.birthday;
    vcard.localtionCity = userInfoPack.city;
    vcard.locationPro = userInfoPack.province;
    vcard.mail = userInfoPack.mail;
    vcard.age =  [[SSIMSpUtil creatBirthdayWithtime:userInfoPack.birthday] intValue];
    vcard.sex = userInfoPack.userSex;
    vcard.mobile = userInfoPack.mobile;
    vcard.nickName = userInfoPack.nickName;
    vcard.userName = userInfoPack.username;
    vcard.avatar300 = userInfoPack.avatarPic300;
    vcard.ct = msg_time/1000;
    vcard.userToken = userInfoPack.userToken;
    
    if (userInfoPack.avatarPic) {
        vcard.avatar = userInfoPack.avatarPic;
    }
    
    vcard.avatar = USER_ICON_URL(vcard.userid);
    [privateContext MR_saveToPersistentStoreAndWait];
    
    [[NIMSearchUserManager sharedInstance] getUserInfoSuccessPacket:userInfoPack.searchUserid type:type];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginTCP" object:nil];
}

#pragma mark 批量获取用户信息
-(void)sendUserInfoListRQ:(NSMutableArray *)userInfos phone:(NSMutableArray *)phones
{
    [[NIMGlobalProcessor sharedInstance].user_processor sendUserInfoListRQ:userInfos phone:phones];
}

-(void)recvUserInfoListRS:(NSMutableArray *)userInfos phone:(NSMutableArray *)phones
{
    NSManagedObjectContext * privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    int64_t msg_time = [NIMBaseUtil GetServerTime];
    
    for (QBUserInfoPacket * pack in userInfos) {
        
        VcardEntity *  vcard = [VcardEntity instancetypeFindUserid:pack.searchUserid];
        
        if (!vcard) {
            vcard = [VcardEntity NIM_createEntity];
        }
        vcard.userid = pack.searchUserid;
        vcard.nickName = pack.nickName;
        vcard.userName = pack.username;
        vcard.mobile = pack.mobile;
        vcard.ct = msg_time/1000;
        vcard.avatar = USER_ICON_URL(pack.searchUserid);
        
        vcard.fullLitter =[PinYinManager getFullPinyinString:[vcard defaultName]];
        vcard.fLitter = [PinYinManager getFirstLetter:[vcard defaultName]];
        
        FDListEntity * fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,pack.searchUserid]];
        if (!fdListEntity) {
            fdListEntity = [FDListEntity NIM_createEntity];
        }
        fdListEntity.fdOwnId = OWNERID;
        fdListEntity.fdPeerId = pack.user_id;
        fdListEntity.fdAvatar = USER_ICON_URL(pack.user_id);
        fdListEntity.ct = msg_time/1000;
        fdListEntity.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PRIVATE  toId:pack.user_id];
        if (pack.remarkName){
            fdListEntity.fdRemarkName = pack.remarkName;
        }
        
        fdListEntity.fdNickName = [vcard defaultNickName];
        
        NSString * firstName = [NIMStringComponents finFristNameWithID:fdListEntity.fdPeerId];
        
        fdListEntity.fullLitter = [PinYinManager getFullPinyinString:firstName];
        fdListEntity.firstLitter = [PinYinManager getFirstLetter:firstName];
        fdListEntity.fullAllLitter = [PinYinManager getAllFullPinyinString:firstName];
        fdListEntity.fullCNLitter = pack.nickName;
        fdListEntity.vcard = vcard;
        
    }
    [privateContext MR_saveToPersistentStoreAndWait];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_USERLST_INFO_RQ object:userInfos];
}

#pragma mark 更新用户信息

-(void)sendUpdateUserInfoRQ:(NSMutableArray *)userInfos sessionID:(int)sessionID{
    [[NIMGlobalProcessor sharedInstance].user_processor sendUpdateUserInfoRQ:userInfos sessionID:sessionID];
}

-(void)recvUpdateUserInfoRS:(NSMutableArray *)userInfos
{
}

-(void)sendRegisterApnsRQ:(NSData *)deToken{
    [[NIMGlobalProcessor sharedInstance].user_processor sendRegisterApnsRQ:deToken];
}

-(void)recvRegisterApnsRQ{
    
}


-(void)sendSingleChatStatusWithUserid:(int64_t)userid status:(int)status
{
    [[NIMGlobalProcessor sharedInstance].user_processor sendSingleChatStatusWithUserid:userid status:status];
    
}

-(void)getUserStatus
{
    [[NIMGlobalProcessor sharedInstance].user_processor getUserStatus];
}


#pragma mark 举报用户
-(void)sendReportUserID:(int64_t)userID type:(int32)cpType reason:(NSString *)cpReason
{
    [[NIMGlobalProcessor sharedInstance].user_processor sendReportUserID:userID type:cpType reason:cpReason];
}

-(void)recvReportUserID:(int64_t)userID type:(int32)cpType reason:(NSString *)cpReason{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_COMPLAINT_RQ object:cpReason];
    
}



//修改用户邮箱
-(void)sendChangeOldMailRQ:(NSString *)oldMail newMail:(NSString *)newMail sessionID:(int)sessionID{
    [[NIMGlobalProcessor sharedInstance].user_processor sendChangeOldMailRQ:oldMail newMail:newMail sessionID:sessionID];
}

-(void)recvChangeOldMailRS:(QBTransParam *)trans_param{
    
}

//修改用户手机号
-(void)sendChangeoldMobileRQ:(NSString *)oldMobile newMobile:(NSString *)newMobile  sessionID:(int)sessionID{
    [[NIMGlobalProcessor sharedInstance].user_processor sendChangeoldMobileRQ:oldMobile newMobile:newMobile sessionID:sessionID];
}

-(void)recvChangeOldMobilRS:(QBTransParam *)trans_param{
    
}

//传入专属邀请码和邀请链接
-(void)sendInviteUrl:(NSString *)inviteUrl andDescSms:(NSString *)descSms{
    [[NSUserDefaults standardUserDefaults] setObject:inviteUrl forKey:[NSString stringWithFormat:@"IM_InviteUrl_%lld",OWNERID]];
    [[NSUserDefaults standardUserDefaults] setObject:descSms forKey:[NSString stringWithFormat:@"IM_DescSms_%lld",OWNERID]];
}




@end
