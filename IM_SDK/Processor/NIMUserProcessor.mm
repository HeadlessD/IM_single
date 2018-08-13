//
//  NIMUserProcessor.m
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMUserProcessor.h"
#import "NIMCallBackManager.h"
#import "NIMMessageStruct.h"
#import "NIMGlobalProcessor.h"


#import "fb_get_me_info_rq_generated.h"
#import "fb_get_me_info_rs_generated.h"

#import "fb_get_user_info_rq_generated.h"
#import "fb_get_user_info_rs_generated.h"
#import "fb_get_userlst_info_rq_generated.h"
#import "fb_get_userlst_info_rs_generated.h"

#import "fb_update_user_info_rq_generated.h"
#import "fb_update_user_info_rs_generated.h"
#import "fb_register_apns_rq_generated.h"
#import "fb_register_apns_rs_generated.h"

#import "fb_get_user_status_rq_generated.h"
#import "fb_get_user_status_rs_generated.h"

#import "fb_single_chat_status_rq_generated.h"
#import "fb_single_chat_status_rs_generated.h"

#import "fb_user_complaint_rq_generated.h"
#import "fb_user_complaint_rs_generated.h"

#import "fb_change_mail_rq_generated.h"
#import "fb_change_mail_rs_generated.h"

#import "fb_change_mobile_rq_generated.h"
#import "fb_change_mobile_rs_generated.h"


@implementation NIMUserProcessor
{
    
}

using namespace userpack;
using namespace scpack;
using namespace commonpack;
- (id)init
{
    self = [super init];
    [self initCallBack];
    
    return self;
}

- (void)dealloc
{
}

-(void)initCallBack
{
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_ME_INFO_RS class_name:self func_name:@"recvGetSelfInfoRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_USER_INFO_RS class_name:self func_name:@"recvUserInfoRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_USERLST_INFO_RS class_name:self func_name:@"recvUserInfoListRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_USER_CHANGE_RS class_name:self func_name:@"recvUpdateUserInfoRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_REGISTER_APNS_RS class_name:self func_name:@"recvRegisterApnsRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SINGLE_CHAT_STATUS_RS class_name:self func_name:@"recvSingleChatStatus:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GET_USER_STATUS_RS class_name:self func_name:@"recvUserStatus:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_USER_COMPLAINT_RS class_name:self func_name:@"recvComplaintUser:"];

    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CHANGE_MAIL_RS class_name:self func_name:@"recvChangeOldMailRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CHANGE_MOBILE_RS class_name:self func_name:@"recvChangeOldMobilRS:"];

}

#pragma mark 获取个人用户信息
-(void)sendGetSelfInfoRQ:(NSString *)meToken{
    
    flatbuffers::FlatBufferBuilder fbbuilder;
//    auto token = fbbuilder.CreateString([meToken UTF8String]);
    userpack::T_GET_ME_INFO_RQBuilder user_rq = T_GET_ME_INFO_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    user_rq.add_s_rq_head(&s_rq);
    flatbuffers::Offset<T_GET_ME_INFO_RQ> offset_rq = user_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_ME_INFO_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_ME_INFO_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",OWNERID]];
}

-(void)recvGetSelfInfoRS:(QBTransParam *)trans_param
{
    T_GET_ME_INFO_RS *t_user_rs = (userpack::T_GET_ME_INFO_RS*)GetT_GET_ME_INFO_RS(trans_param.buffer.bytes);
    
    //检查头
    if(!t_user_rs || ![super checkHead:t_user_rs->s_rs_head()]){
        DBLog(@"user_id->获取用户信息的id:%llu",t_user_rs->user_id());
        return;
    }
    //todo 删除pack_session_id
    int pack_id = t_user_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //装入模型->生成字典
    QBUserInfoPacket *packet = [[QBUserInfoPacket alloc] init];
    packet.user_id = t_user_rs->s_rs_head()->user_id();
    packet.pack_id = t_user_rs->s_rs_head()->pack_session_id();
    packet.result  = t_user_rs->s_rs_head()->result();
    packet.searchUserid = t_user_rs->user_id();
    
    if (t_user_rs->sex() == 0) {
        packet.userSex = USER_SEX_FEMALE;
    }else if (t_user_rs->sex() == 1){
        packet.userSex = USER_SEX_MALE;
    }
    
    if (t_user_rs->user_name()) {
        packet.username = [NSString stringWithCString:t_user_rs->user_name()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->city()) {
        packet.city = [NSString stringWithCString:t_user_rs->city()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->mobile()) {
        packet.mobile = [NSString stringWithFormat:@"%llu",t_user_rs->mobile()];
    }
    if (t_user_rs->nick_name()) {
        packet.nickName = [NSString stringWithCString:t_user_rs->nick_name()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->province()) {
        packet.province = [NSString stringWithCString:t_user_rs->province()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->mail()) {
        packet.mail = [NSString stringWithCString:t_user_rs->mail()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->birthday()) {
        packet.birthday = [NSString stringWithFormat:@"%llu",t_user_rs->birthday()];
    }
    if (t_user_rs->signature()) {
        packet.signature = [NSString stringWithCString:t_user_rs->signature()->c_str() encoding:NSUTF8StringEncoding];
    }
    DBLog(@">>>>>获取个人数据user_id:%llu",t_user_rs->user_id());
    DBLog(@">>>>>user_name:%@",[NSString stringWithCString:t_user_rs->user_name()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>mobile:%@",[NSString stringWithFormat:@"%llu",t_user_rs->mobile()]);
    DBLog(@">>>>>nick_name:%@",[NSString stringWithCString:t_user_rs->nick_name()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>user_sex:%@",packet.userSex);
    DBLog(@">>>>>mail:%@",[NSString stringWithCString:t_user_rs->mail()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>city:%@",[NSString stringWithCString:t_user_rs->city()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>birthday:%llu",t_user_rs->birthday());
    DBLog(@">>>>>province:%@",[NSString stringWithCString:t_user_rs->province()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>signature:%@",[NSString stringWithCString:t_user_rs->signature()->c_str() encoding:NSUTF8StringEncoding]);
    
    [[NIMUserOperationBox sharedInstance] recvGetSelfInfoRS:packet];
}

#pragma mark 获取用户信息
-(bool)sendUserInfoRQ:(NSString *)searchContent type:(int32)type{
    
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    auto userMsg = fbbuilder.CreateString([searchContent UTF8String]);
//    auto token = fbbuilder.CreateString([@"" UTF8String]);

    userpack::T_GET_USER_INFO_RQBuilder user_rq = T_GET_USER_INFO_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(type) forKey:[NSString stringWithFormat:@"%d",packetID]];
    
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    user_rq.add_s_rq_head(&s_rq);
    user_rq.add_user_msg(userMsg);

    flatbuffers::Offset<T_GET_USER_INFO_RQ> offset_rq = user_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_USER_INFO_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_USER_INFO_RQ buffer:buf buf_len:len packID:packetID msgId:searchContent];
    
    return true;
}

-(void)recvUserInfoRS:(QBTransParam *)trans_param
{
    T_GET_USER_INFO_RS *t_user_rs = (userpack::T_GET_USER_INFO_RS*)GetT_GET_USER_INFO_RS(trans_param.buffer.bytes);
    
    //检查头
    if(!t_user_rs || ![super checkHead:t_user_rs->s_rs_head()]){
        DBLog(@"user_id->获取用户信息的id:%llu",t_user_rs->user_id());
        
        return;
    }
    DBLog(@"len:%d",trans_param.buf_len);
    
    //todo 删除pack_session_id
    int pack_id = t_user_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //装入模型->生成字典
    QBUserInfoPacket *packet = [[QBUserInfoPacket alloc] init];
    packet.user_id = t_user_rs->s_rs_head()->user_id();
    packet.pack_id = t_user_rs->s_rs_head()->pack_session_id();
    packet.result  = t_user_rs->s_rs_head()->result();
    
    packet.searchUserid = t_user_rs->user_id();
   
    if (t_user_rs->sex() == 0) {
        packet.userSex = USER_SEX_FEMALE;
    }else if (t_user_rs->sex() == 1){
        packet.userSex = USER_SEX_MALE;
    }
    
    if (t_user_rs->user_name()) {
        packet.username = [NSString stringWithCString:t_user_rs->user_name()->c_str() encoding:NSUTF8StringEncoding];
    }

    if (t_user_rs->city()) {
        packet.city = [NSString stringWithCString:t_user_rs->city()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->mobile()) {
        packet.mobile = [NSString stringWithFormat:@"%llu",t_user_rs->mobile()];
    }
    if (t_user_rs->nick_name()) {
        packet.nickName = [NSString stringWithCString:t_user_rs->nick_name()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->province()) {
        packet.province = [NSString stringWithCString:t_user_rs->province()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->mail()) {
        packet.mail = [NSString stringWithCString:t_user_rs->mail()->c_str() encoding:NSUTF8StringEncoding];
    }
    if (t_user_rs->birthday()) {
        packet.birthday = [NSString stringWithFormat:@"%llu",t_user_rs->birthday()];
    }
    if (t_user_rs->signature()) {
        packet.signature = [NSString stringWithCString:t_user_rs->signature()->c_str() encoding:NSUTF8StringEncoding];
    }
    DBLog(@">>>>>获取他人数据user_id:%llu",t_user_rs->user_id());
    DBLog(@">>>>>user_name:%@",[NSString stringWithCString:t_user_rs->user_name()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>mobile:%llu",t_user_rs->mobile());
    DBLog(@">>>>>nick_name:%@",[NSString stringWithCString:t_user_rs->nick_name()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>user_sex:%@",packet.userSex);
    DBLog(@">>>>>mail:%@",[NSString stringWithCString:t_user_rs->mail()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>city:%@",[NSString stringWithCString:t_user_rs->city()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>birthday:%llu",t_user_rs->birthday());
    DBLog(@">>>>>province:%@",[NSString stringWithCString:t_user_rs->province()->c_str() encoding:NSUTF8StringEncoding]);
    DBLog(@">>>>>signature:%@",[NSString stringWithCString:t_user_rs->signature()->c_str() encoding:NSUTF8StringEncoding]);
    
    [[NIMUserOperationBox sharedInstance]recvUserInfoRS:packet type:[[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%d",pack_id]] intValue]];
}

#pragma mark 批量获取用户信息
-(void)sendUserInfoListRQ:(NSMutableArray *)userInfos phone:(NSMutableArray *)phones
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    std::vector<uint64> userList;
    std::vector<uint64> mobileList;
    
    if (userInfos) {
        for (int i=0; i<userInfos.count; i++) {
            QBUserBaseInfo *info =userInfos[i];
            userList.push_back(info.user_id);
        }
    }else if (phones){
        for (int i = 0; i < phones.count; i++) {
            uint64 phoneA = [phones[i] longLongValue];
            DBLog(@"%lld",phoneA);
            mobileList.push_back(phoneA);
        }
    }
    
    auto userListAuto = fbbuilder.CreateVector(userList);
    auto mobileListAuto = fbbuilder.CreateVector(mobileList);
    
    userpack::T_GET_USERLST_INFO_RQBuilder user_rq = T_GET_USERLST_INFO_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    user_rq.add_s_rq_head(&s_rq);
    if (userInfos) {
        user_rq.add_userLst(userListAuto);
    }else if (phones){
        user_rq.add_mobileLst(mobileListAuto);
    }
    
    flatbuffers::Offset<T_GET_USERLST_INFO_RQ> offset_rq = user_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_USERLST_INFO_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_USERLST_INFO_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvUserInfoListRS:(QBTransParam *)trans_param{
    T_GET_USERLST_INFO_RS *t_user_rs = (userpack::T_GET_USERLST_INFO_RS*)GetT_GET_USERLST_INFO_RS(trans_param.buffer.bytes);
    
    DBLog(@"len:%d",trans_param.buf_len);
    
    
    //检查头
    if(!t_user_rs || ![super checkHead:t_user_rs->s_rs_head()]){
        DBLog(@"批量获取user_id:%llu",t_user_rs->s_rs_head()->user_id());
        return;
    }
    //todo 删除pack_session_id
    int pack_id = t_user_rs->s_rs_head()->pack_session_id();
    const flatbuffers::Vector<flatbuffers::Offset<userpack::T_GET_USERINFO>> *friend_list = t_user_rs->user_lst_info();
    NSMutableArray * userinfoArr = [NSMutableArray array];
    
    for (flatbuffers::uoffset_t i = 0; i < friend_list->size(); i++){
        T_GET_USERINFO * getuserinfo = (T_GET_USERINFO *)t_user_rs->user_lst_info()->Get(i);
        QBUserInfoPacket *packet = [[QBUserInfoPacket alloc] init];
        packet.pack_id = t_user_rs->s_rs_head()->pack_session_id();
        packet.result  = t_user_rs->s_rs_head()->result();
        //packet.user_id = t_user_rs->s_rs_head()->user_id();
        packet.searchUserid = getuserinfo->user_id();
        
        if (getuserinfo->user_name()) {
            packet.username = [NSString stringWithCString:getuserinfo->user_name()->c_str() encoding:NSUTF8StringEncoding];
        }
        if (getuserinfo->nick_name()) {
            packet.nickName = [NSString stringWithCString:getuserinfo->nick_name()->c_str() encoding:NSUTF8StringEncoding];
        }
        if (getuserinfo->user_id()) {
            packet.user_id = getuserinfo->user_id();
        }
        if (getuserinfo->mobile()) {
            packet.mobile = [NSString stringWithFormat:@"%llu",getuserinfo->mobile()];
        }
        [userinfoArr addObject:packet];
    }
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    [[NIMUserOperationBox sharedInstance] recvUserInfoListRS:userinfoArr phone:nil];
}

#pragma mark 更新用户信息
-(void)sendUpdateUserInfoRQ:(NSMutableArray *)userInfos sessionID:(int)sessionID{
    
    flatbuffers::FlatBufferBuilder upBuild;
    
    std::vector<flatbuffers::Offset<userpack::T_KEYINFO>> vector_userlst;
    
    for (NSDictionary * ud in userInfos) {
        
        int32 upKeyName = [ud.allKeys.firstObject intValue];
        
        auto upContent = upBuild.CreateString([ud.allValues.firstObject UTF8String]);
        
        T_KEYINFOBuilder keyInfo = T_KEYINFOBuilder(upBuild);
        keyInfo.add_key_name(upKeyName);
        keyInfo.add_key_value(upContent);
        const flatbuffers::Offset<userpack::T_KEYINFO> keyFin = keyInfo.Finish();
        vector_userlst.push_back(keyFin);
    }
    auto vector_list_builder = upBuild.CreateVector(vector_userlst);
    
    T_UPDATE_USER_INFO_RQBuilder user_rq = T_UPDATE_USER_INFO_RQBuilder(upBuild);
    
    int packetID = [NIMBaseUtil getPacketSessionID];

    if (sessionID) {
        packetID = sessionID;
    }
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    user_rq.add_s_rq_head(&s_rq);
    user_rq.add_key_lst_info(vector_list_builder);
    
    flatbuffers::Offset<T_UPDATE_USER_INFO_RQ> offset_rq = user_rq.Finish();
    upBuild.Finish(offset_rq);
    
    BYTE*	buf = upBuild.GetBufferPointer();
    WORD	len = (WORD)upBuild.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_USER_CHANGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_USER_CHANGE_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvUpdateUserInfoRS:(QBTransParam *)trans_param
{
    T_UPDATE_USER_INFO_RS *t_user_rs = (userpack::T_UPDATE_USER_INFO_RS*)GetT_UPDATE_USER_INFO_RS(trans_param.buffer.bytes);
    DBLog(@"len:%d",trans_param.buf_len);
    //检查头
    if(!t_user_rs || ![super checkHead:t_user_rs->s_rs_head()]){
        DBLog(@"updata_user_id:%llu",t_user_rs->s_rs_head()->user_id());
        return;
    }
    //todo 删除pack_session_id
    int pack_id = t_user_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //成功获取用户信息
    [[NIMUserOperationBox sharedInstance] sendGetSelfInfoRQ:nil];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pack_id) forKey:@"sessionID"];
    [dict setValue:@1 forKey:@"result"];
    [dict setValue:nil forKey:@"error"];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
}


#pragma mark 发送推送注册信息
-(void)sendRegisterApnsRQ:(NSData *)deToken{
    
    flatbuffers::FlatBufferBuilder RABuild;
    
    NSString *token = [[deToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *value = getObjectFromUserDefault(PUSH_DEVICE_TOKEN);
    
    NSArray *arr = [value componentsSeparatedByString:@"_"];
    
    NSString *preToken = arr.firstObject;
    int64_t userid = [arr.lastObject longLongValue];

    if ([preToken isEqualToString:token] && userid == OWNERID) {
        return;
    }    
    auto tokenStr = RABuild.CreateString([token UTF8String]);
    
    T_REGISTER_APNS_RQBuilder ra_rq= T_REGISTER_APNS_RQBuilder(RABuild);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    ra_rq.add_s_rq_head(&s_rq);
    ra_rq.add_device_token(tokenStr);
    
    flatbuffers::Offset<T_REGISTER_APNS_RQ> offset_rq = ra_rq.Finish();
    RABuild.Finish(offset_rq);
    
    BYTE*	buf = RABuild.GetBufferPointer();
    WORD	len = (WORD)RABuild.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_REGISTER_APNS_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_REGISTER_APNS_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvRegisterApnsRS:(QBTransParam *)trans_param
{
    T_REGISTER_APNS_RS * t_user_rs = (userpack:: T_REGISTER_APNS_RS *)GetT_REGISTER_APNS_RS(trans_param.buffer.bytes);
    DBLog(@"len:%d",trans_param.buf_len);
    //检查头
    if(!t_user_rs || ![super checkHead:t_user_rs->s_rs_head()]){
        DBLog(@"register_user_id:%llu",t_user_rs->s_rs_head()->user_id());
        return;
    }
    
    NSString *token = [NSString stringWithCString:t_user_rs->device_token()->c_str() encoding:NSUTF8StringEncoding];
    
    
    NSString *value = [NSString stringWithFormat:@"%@_%lld",token,OWNERID];
    
    setObjectToUserDefault(PUSH_DEVICE_TOKEN, value);
    //todo 删除pack_session_id
    int pack_id = t_user_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
}

#pragma mark 单聊消息免打扰
-(void)sendSingleChatStatusWithUserid:(int64_t)userid status:(int)status
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_SINGLE_CHAT_STATUS_RQBuilder chat_status = T_SINGLE_CHAT_STATUS_RQBuilder(fbbuilder);
    
    chat_status.add_s_rq_head(&s_rq);
    chat_status.add_op_user_id(userid);
    chat_status.add_chat_status(status);
    
    
    fbbuilder.Finish(chat_status.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_SINGLE_CHAT_STATUS_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_SINGLE_CHAT_STATUS_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvSingleChatStatus:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_SINGLE_CHAT_STATUS_RSBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
        return;
    }
    
    T_SINGLE_CHAT_STATUS_RS *chat_status = (T_SINGLE_CHAT_STATUS_RS *)GetT_SINGLE_CHAT_STATUS_RS(trans_param.buffer.bytes);
    
    if(!chat_status)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat_status->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat_status->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    int64_t userid = chat_status->op_user_id();
    int status = chat_status->chat_status();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SINGLE_CHAT_STATUS object:@{@"userid":@(userid),@"status":@(status)}];
}

#pragma mark 获取免打扰好友
-(void)getUserStatus
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_GET_USER_STATUS_RQBuilder chat_status = T_GET_USER_STATUS_RQBuilder(fbbuilder);
    
    chat_status.add_s_rq_head(&s_rq);
        
    fbbuilder.Finish(chat_status.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GET_USER_STATUS_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GET_USER_STATUS_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvUserStatus:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_GET_USER_STATUS_RSBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
        return;
    }
    
    T_GET_USER_STATUS_RS *chat_status = (T_GET_USER_STATUS_RS *)GetT_GET_USER_STATUS_RS(trans_param.buffer.bytes);
    
    if(!chat_status)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat_status->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat_status->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
}

#pragma mark 举报用户
-(void)sendReportUserID:(int64_t)userID type:(int32)cpType reason:(NSString *)cpReason{
    
    flatbuffers::FlatBufferBuilder fbbuilder;
    auto cpUserReason = fbbuilder.CreateString([cpReason UTF8String]);
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    T_USER_COMPLAINT_RQBuilder chat_status = T_USER_COMPLAINT_RQBuilder(fbbuilder);
    chat_status.add_s_rq_head(&s_rq);
    chat_status.add_user_id(userID);
    chat_status.add_type(cpType);
    chat_status.add_reason(cpUserReason);
    
    fbbuilder.Finish(chat_status.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_USER_COMPLAINT_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_USER_COMPLAINT_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvComplaintUser:(QBTransParam *)trans_param{
    
    T_USER_COMPLAINT_RS * t_add_rs = (userpack::T_USER_COMPLAINT_RS *)GetT_USER_COMPLAINT_RS(trans_param.buffer.bytes);

    //检查头
    if(!t_add_rs || ![super checkHead:t_add_rs->s_rs_head()]){
        return;
    }
    //todo 删除pack_session_id
    int pack_id = t_add_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    NSString * type = [NSString stringWithFormat:@"%hhd",t_add_rs->type()];
    
     NSString * reason = @"";
    
    if (t_add_rs->reason()) {
         reason = [NSString stringWithFormat:@"%s",t_add_rs->reason()->c_str()];
    }
    
    [[NIMUserOperationBox sharedInstance] recvReportUserID:t_add_rs->user_id() type:[type intValue] reason:reason];
}


#pragma mark 修改用户邮箱
-(void)sendChangeOldMailRQ:(NSString *)oldMail newMail:(NSString *)newMail sessionID:(int)sessionID{
    
    flatbuffers::FlatBufferBuilder RABuild;
    auto oldMailStr = RABuild.CreateString([oldMail UTF8String]);
    auto newMailStr = RABuild.CreateString([newMail UTF8String]);
    
    T_CHANGE_MAIL_RQBuilder  mailBuilder  = T_CHANGE_MAIL_RQBuilder(RABuild);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    if (sessionID) {
        packetID = sessionID;
    }
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    mailBuilder.add_s_rq_head(&s_rq);
    mailBuilder.add_old_mail(oldMailStr);
    mailBuilder.add_new_mail(newMailStr);
    
    flatbuffers::Offset<T_CHANGE_MAIL_RQ> offset_rq = mailBuilder.Finish();
    
    RABuild.Finish(offset_rq);
    
    BYTE*    buf = RABuild.GetBufferPointer();
    WORD    len = (WORD)RABuild.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CHANGE_MAIL_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CHANGE_MAIL_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvChangeOldMailRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
   
    bool is_fbs = VerifyT_CHANGE_MAIL_RQBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
        return;
    }
    
    T_CHANGE_MAIL_RS *chat_status = (T_CHANGE_MAIL_RS *)GetT_CHANGE_MAIL_RS(trans_param.buffer.bytes);
    
    if(!chat_status)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat_status->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat_status->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
 
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pack_id) forKey:@"sessionID"];
    [dict setValue:@1 forKey:@"result"];
    [dict setValue:nil forKey:@"error"];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
}


#pragma mark 修改用户手机号
-(void)sendChangeoldMobileRQ:(NSString *)oldMobile newMobile:(NSString *)newMobile sessionID:(int)sessionID{
    
    flatbuffers::FlatBufferBuilder RABuild;
    
    NSInteger oldMobileInt = [oldMobile integerValue];
    NSInteger newMobileInt = [newMobile integerValue];

//    auto oldMobileStr = RABuild.CreateString([oldMobile UTF8String]);
//    auto newMobileStr = RABuild.CreateString([newMobile UTF8String]);
    
    T_CHANGE_MOBILE_RQBuilder  mailBuilder  = T_CHANGE_MOBILE_RQBuilder(RABuild);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    if (sessionID) {
        packetID = sessionID;
    }
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    mailBuilder.add_s_rq_head(&s_rq);
    mailBuilder.add_old_moblie(oldMobileInt);
    mailBuilder.add_new_moblie(newMobileInt);
    
    flatbuffers::Offset<T_CHANGE_MOBILE_RQ> offset_rq = mailBuilder.Finish();
    
    RABuild.Finish(offset_rq);
    
    BYTE*    buf = RABuild.GetBufferPointer();
    WORD    len = (WORD)RABuild.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CHANGE_MOBILE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CHANGE_MOBILE_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvChangeOldMobilRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    
    bool is_fbs = VerifyT_CHANGE_MOBILE_RQBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
        return;
    }
    
    T_CHANGE_MOBILE_RS *chat_status = (T_CHANGE_MOBILE_RS *)GetT_CHANGE_MOBILE_RS(trans_param.buffer.bytes);
    
    if(!chat_status)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat_status->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat_status->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pack_id) forKey:@"sessionID"];
    [dict setValue:@1 forKey:@"result"];
    [dict setValue:nil forKey:@"error"];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
}

@end
