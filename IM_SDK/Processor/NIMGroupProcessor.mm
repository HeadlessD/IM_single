//
//  NIMGroupProcessor.m
//  qbim
//
//  Created by 秦雨 on 17/2/13.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMGroupProcessor.h"
#import "NIMCallBackManager.h"
#import "NIMMessageStruct.h"
#import "RemarkEntity+CoreDataClass.h"
#import "fb_group_list_rq_generated.h"
#import "fb_group_list_rs_generated.h"
#import "fb_group_info_generated.h"
#import "fb_group_detail_info_rq_generated.h"
#import "fb_group_detail_info_rs_generated.h"
#import "fb_group_create_rq_generated.h"
#import "fb_group_create_rs_generated.h"
//#import "fb_group_create_server_rq_generated.h"
//#import "fb_group_create_server_rs_generated.h"
#import "fb_group_modify_change_rq_generated.h"
#import "fb_group_modify_change_rs_generated.h"
//#import "fb_group_modify_server_rq_generated.h"
//#import "fb_group_modify_server_rs_generated.h"
#import "fb_group_leader_change_rq_generated.h"
#import "fb_group_leader_change_rs_generated.h"
//#import "fb_group_get_info_rq_generated.h"
//#import "fb_group_get_info_rs_generated.h"
#import "fb_group_remark_detail_rq_generated.h"
#import "fb_group_remark_detail_rs_generated.h"
#import "fb_group_list_ids_rq_generated.h"
#import "fb_group_list_ids_rs_generated.h"
#import "fb_group_message_status_rq_generated.h"
#import "fb_group_message_status_rs_generated.h"
#import "fb_group_type_list_rq_generated.h"
#import "fb_group_type_list_rs_generated.h"
#import "fb_group_type_info_generated.h"
#import "fb_get_user_remark_name_rq_generated.h"
#import "fb_get_user_remark_name_rs_generated.h"
#import "fb_group_relation_user_info_generated.h"
#import "fb_group_save_change_rq_generated.h"
#import "fb_group_save_change_rs_generated.h"
#import "fb_group_scan_rq_generated.h"
#import "fb_group_scan_rs_generated.h"
#import "fb_get_batch_group_info_rq_generated.h"
#import "fb_get_batch_group_info_rs_generated.h"
@interface NIMGroupProcessor ()

@property(nonatomic,strong)NSMutableArray *groupArr;
@property(nonatomic,strong)NSMutableDictionary *blockDict;

@end

@implementation NIMGroupProcessor

using namespace grouppack;
using namespace commonpack;

- (id)init
{
    self = [super init];
    [self initCallBack];
    self.groupArr = [NSMutableArray arrayWithCapacity:10];
    self.blockDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGroupMember:) name:NC_GROUP_DETAIL object:nil];
    return self;
}

- (void)dealloc
{
}

-(void)initCallBack
{
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_LIST_RS class_name:self func_name:@"recvGroupListRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_LIST_IDS_RS class_name:self func_name:@"recvGroupidListRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_DETAIL_INFO_RS class_name:self func_name:@"recvGroupMemberRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_CREATE_RS class_name:self func_name:@"recvGroupCreateRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_MODIFY_CHANGE_RS class_name:self func_name:@"recvGroupModifyChangeRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_LEADER_CHANGE_RS class_name:self func_name:@"recvLeaderChangeRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_REMARK_DETAIL_RS class_name:self func_name:@"recvGroupRemarkDetail:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_MESSAGE_STATUS_RS class_name:self func_name:@"recvGroupMessageStatue:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_TYPE_LIST_RS class_name:self func_name:@"recvGroupTypeListRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_GET_USER_REMARK_NAME_RS class_name:self func_name:@"recvMemberNameRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_SAVE_CHANGE_RS class_name:self func_name:@"recvGroupSaveStatus:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_SCAN_RS class_name:self func_name:@"recvGroupScan:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_BATCH_INFO_RS class_name:self func_name:@"recvGroupBatchInfoRS:"];



}
/*+++++++++++++++++++++++++群ID列表+++++++++++++++++++++++++*/
-(void)sendGroupidListRQWithIndex:(int32_t)index
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_GROUP_LIST_IDS_RQBuilder list = T_GROUP_LIST_IDS_RQBuilder(fbbuilder);
    list.add_s_rq_head(&s_rq);
    list.add_group_list_index(index);
    fbbuilder.Finish(list.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_LIST_IDS_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_LIST_IDS_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvGroupidListRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_LIST_IDS_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_LIST_IDS_RS *groups_rs = (grouppack::T_GROUP_LIST_IDS_RS*)GetT_GROUP_LIST_IDS_RS(trans_param.buffer.bytes);
    if(!groups_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:groups_rs->s_rs_head()])
    {
        return;
    }
    int pack_id = groups_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    int32_t index = groups_rs->group_list_index();
    
    NSMutableArray *groupids = [NSMutableArray array];
    
    for (flatbuffers::uoffset_t i = 0; i<groups_rs->group_info_list()->size(); i++) {
        
        T_GROUP_RELATION_USER_INFO *user_info = (T_GROUP_RELATION_USER_INFO *)groups_rs->group_info_list()->Get(i);
    
        int64_t groupid = user_info->group_id();
        
        if (groupid == 0) {
            continue;
        }

        GROUP_MESSAGE_STATUS message_status = (GROUP_MESSAGE_STATUS)user_info->message_status();
        NIM_GROUP_SAVE_TYPE save_type  = (NIM_GROUP_SAVE_TYPE)user_info->save_type();
        
        [[NIMSysManager sharedInstance].relationDict setObject:@{@"status":@(message_status),@"type":@(save_type)} forKey:@(groupid)];
        
        GroupList *groupList = [GroupList instancetypeFindGroupId:groupid];
        setObjectToUserDefault(KEY_Group_Icon(groupid),@NO);
        if (!groupList) {
            [[NIMSysManager sharedInstance].gidsArr addObject:@(groupid)];
        }else{
            [[NIMSysManager sharedInstance].groupShowDict setObject:@(groupList.showname) forKey:@(groupid)];

            BOOL isSave = NO;
            if (groupList.switchnotify != message_status) {
                groupList.switchnotify = message_status;
                isSave = YES;
            }
            if (groupList.savedwitch != save_type) {
                groupList.savedwitch = save_type;
                isSave = YES;
            }
            if (isSave) {
                [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
            }
        }
        [groupids addObject:@(groupid)];
        [[NIMSysManager sharedInstance].offlinesArr addObject:@(groupid)];

    }
    //处理本地多余的群
    [[NIMGroupOperationBox sharedInstance] recvGroupidList:groupids];
    if (index != -1) {
        [self sendGroupidListRQWithIndex:index];
    }else{
        
        //批量获取信息
        if ([NIMSysManager sharedInstance].gidsArr.count>20) {
            NSArray *tmpArr = [NIMBaseUtil splitArray:[NIMSysManager sharedInstance].gidsArr withSubSize:20];
            [self sendBatchGroupInfoRQ:tmpArr];
        }else if([NIMSysManager sharedInstance].gidsArr.count>0){
            [self sendBatchGroupInfoRQ:[NIMSysManager sharedInstance].gidsArr];
        }
        
        //获取离线
        if ([NIMSysManager sharedInstance].offlinesArr.count>0) {
            [[NIMGroupOperationBox sharedInstance] fetchGroupOffline:[NIMSysManager sharedInstance].offlinesArr];
        }
        
    }

}




/*+++++++++++++++++++++++++群列表+++++++++++++++++++++++++*/


-(void)sendGroupListRQWithindex:(int32_t)index
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_GROUP_LIST_RQBuilder list = T_GROUP_LIST_RQBuilder(fbbuilder);
    list.add_s_rq_head(&s_rq);
    list.add_group_list_index(index);
    fbbuilder.Finish(list.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_LIST_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_LIST_RQ buffer:buf buf_len:len packID:packetID msgId:0];
    
    
}

-(void)recvGroupListRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_LIST_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_LIST_RS *groups_rs = (grouppack::T_GROUP_LIST_RS*)GetT_GROUP_LIST_RS(trans_param.buffer.bytes);
    if(!groups_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:groups_rs->s_rs_head()])
    {
        return;
    }
    int pack_id = groups_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    int32_t index = groups_rs->group_list_index();
    QBGroupListPacket *groupList = [[QBGroupListPacket alloc] init];
    groupList.user_id = groups_rs->s_rs_head()->user_id();
    groupList.groupList = [NSMutableArray arrayWithCapacity:10];
    for (flatbuffers::uoffset_t i = 0; i < groups_rs->group_info_list()->size(); i++) {
        T_GROUP_BASE_INFO *info = (grouppack::T_GROUP_BASE_INFO *)groups_rs->group_info_list()->Get(i);
        QBGroupInfoPacket *groupinfo = [[QBGroupInfoPacket alloc] init];
        groupinfo.group_id = info->group_id();
        groupinfo.group_count = info->group_count();
        groupinfo.group_manager_user_id = info->group_manager_user_id();
        groupinfo.group_max_count = info->group_max_count();
        groupinfo.group_add_is_agree = info->group_add_is_agree();
        groupinfo.group_ct = info->group_ct();
        groupinfo.message_status = info->message_status();
        groupinfo.group_add_max_count = info->group_add_max_count();
        if (info->group_name()) {
            groupinfo.group_name = [NIMBaseUtil getStringWithCString:info->group_name()->c_str()];
        }else{
            groupinfo.group_name = @"";
        }
        if (info->group_img_url()) {
            groupinfo.group_img_url =  [NIMBaseUtil getStringWithCString:info->group_img_url()->c_str()];
        }else{
            groupinfo.group_img_url = @"";
        }
        if (info->group_remark()) {
            groupinfo.group_remark =  [NIMBaseUtil getStringWithCString:info->group_remark()->c_str()];
        }else{
            groupinfo.group_remark = @"";
        }
        NSDictionary *dict = [groupinfo compositeWithAttributes];
        [self.groupArr addObject:dict];

    }
    if (index == -1) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:[NSString stringWithFormat:@"%lld_first",OWNERID]];
        [userDefaults synchronize];
        [[NIMGroupOperationBox sharedInstance] recvGroupList:self.groupArr complete:^(id object, NIMResultMeta *result) {
            [self.groupArr removeAllObjects];
            [self sendGroupidListRQWithIndex:0];
        }];
        
    }else{
        [self sendGroupListRQWithindex:index];
    }

}


static int remain;
/*+++++++++++++++++++++++++群成员+++++++++++++++++++++++++*/
-(void)sendGroupMemberRQ:(int64_t)groupid index:(int32_t)index complete:(CompleteBlock)complete
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    remain = index;
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    if (complete) {
        [self.blockDict setObject:complete forKey:@(packetID)];
    }
    T_GROUP_DETAIL_INFO_RQBuilder detail = T_GROUP_DETAIL_INFO_RQBuilder(fbbuilder);
    detail.add_s_rq_head(&s_rq);
    detail.add_group_id(groupid);
    detail.add_group_member_index(index);
    fbbuilder.Finish(detail.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_DETAIL_INFO_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_DETAIL_INFO_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvGroupMemberRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_DETAIL_INFO_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    
    T_GROUP_DETAIL_INFO_RS *group_rs = (grouppack::T_GROUP_DETAIL_INFO_RS*)GetT_GROUP_DETAIL_INFO_RS(trans_param.buffer.bytes);
    if(!group_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:group_rs->s_rs_head()])
    {
        return;
    }
    int pack_id = group_rs->s_rs_head()->pack_session_id();
    int32_t index = group_rs->group_member_index();
    int64_t groupid = group_rs->group_id();
    int MemIndex = [getObjectFromUserDefault(KEY_Member_Index(groupid)) intValue];
    if (MemIndex == index) {
        return;
    }
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    QBGroupListPacket *groupList = [[QBGroupListPacket alloc] init];
    groupList.user_id = group_rs->s_rs_head()->user_id();
    groupList.group_id = group_rs->group_id();
    groupList.groupList = [NSMutableArray arrayWithCapacity:10];
    groupList.pack_id = remain;
    if (!group_rs->list_members_info() || group_rs->list_members_info()->size()==0) {
        NSLog(@"群里没有成员%lld",groupid);
        return;
    }
    for (flatbuffers::uoffset_t i = 0; i < group_rs->list_members_info()->size(); i++) {
        
        USER_BASE_INFO *user_info = (USER_BASE_INFO *)group_rs->list_members_info()->Get(i);
        uint64_t memberId = user_info->user_id();
        int32_t index = user_info->user_group_index();
        NSString *name= [NSString stringWithCString:user_info->user_nick_name()->c_str() encoding:NSUTF8StringEncoding];

        NSDictionary *dict = @{@"userId":@(memberId),@"memberNickName":name,@"index":@(index)};
        [groupList.groupList addObject:dict];
    }
    NSDictionary *dict = [groupList compositeWithAttributes];
    NSLog(@"群成员：%@",dict);
    
    CompleteBlock complete = [self.blockDict objectForKey:@(pack_id)];

    [[NIMGroupOperationBox sharedInstance] recvGroupMember:groupList iconBlock:(CompleteBlock)complete completeBlock:^(id object, NIMResultMeta *result) {
        setObjectToUserDefault(KEY_Member_Index(groupid), @(index));
        if (index == -1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_DETAIL object:@(groupid)];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:KEY_Member_Fetch(groupid)];
            [userDefault synchronize];
            if (remain==0) {
                if (complete) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_DETAIL object:@{@"packid":@(pack_id),@"content":groupList.groupList}];
                }
            }
            return;
        }else{
            if (complete) {
                [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_DETAIL object:@{@"packid":@(pack_id),@"content":groupList.groupList}];
            }else{
                [self sendGroupMemberRQ:groupid index:index complete:nil];
            }
        }
    }];
}

-(void)recvGroupMember:(NSNotification *)notification
{
    id object = notification.object;
    
    if ([object isKindOfClass:[NSNumber class]]) {
        int pack_id = [object intValue];
        CompleteBlock complete = [self.blockDict objectForKey:@(pack_id)];
        NSError *error;
        if (complete) {
            complete(nil,[NIMResultMeta resultWithNSError:error]);
        }
    }else{
        NSDictionary *dict = object;
        int pack_id = [[dict objectForKey:@"packid"] intValue];
        id obj = [dict objectForKey:@"content"];
        if ([obj isKindOfClass:[NSArray class]])
        {
            CompleteBlock complete = [self.blockDict objectForKey:@(pack_id)];
            complete(obj,nil);
        }else{
            CompleteBlock complete = [self.blockDict objectForKey:@(pack_id)];
            NSError *error;
            if (complete) {
                complete(nil,[NIMResultMeta resultWithNSError:error]);
            }
        }
    }
}

/*+++++++++++++++++++++++++群详情+++++++++++++++++++++++++*/

/*
-(void)sendGroupDetailInfoRQ:(int64_t)groupid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    T_GROUP_GET_INFO_RQBuilder info= T_GROUP_GET_INFO_RQBuilder(fbbuilder);
    info.add_s_rq_head(&s_rq);
    info.add_group_id(groupid);
    fbbuilder.Finish(info.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_GET_INFO_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_GET_INFO_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvGroupDetailInfoRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_GET_INFO_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_GET_INFO_RS *group_rs = (grouppack::T_GROUP_GET_INFO_RS*)GetT_GROUP_GET_INFO_RS(trans_param.buffer.bytes);
    if(!group_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:group_rs->s_rs_head()])
    {
        return;
    }
    int pack_id = group_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    BOOL isMember  = group_rs->isMember();
    T_GROUP_BASE_INFO *baseInfo = (T_GROUP_BASE_INFO *)group_rs->group_info();
    QBGroupInfoPacket *groupInfo = [[QBGroupInfoPacket alloc] init];
    groupInfo.group_id = baseInfo->group_id();
    groupInfo.group_count = baseInfo->group_count();
    groupInfo.group_add_is_agree = baseInfo->group_add_is_agree();
    groupInfo.group_manager_user_id = baseInfo->group_manager_user_id();
    groupInfo.group_ct = baseInfo->group_ct();
    groupInfo.message_status = baseInfo->message_status();
    groupInfo.group_max_count = baseInfo->group_max_count();
    groupInfo.group_add_max_count = baseInfo->group_add_max_count();
    if (baseInfo->group_img_url()) {
        groupInfo.group_img_url = [NSString stringWithUTF8String:baseInfo->group_img_url()->c_str()];
    }
    if (baseInfo->group_name()) {
        groupInfo.group_name = [NSString stringWithUTF8String:baseInfo->group_name()->c_str()];
    }
    [[NIMGroupOperationBox sharedInstance] recvGroupDetailInfo:@[groupInfo] isMember:isMember];
}
*/

/*+++++++++++++++++++++++++批量群详情+++++++++++++++++++++++++*/
-(void)sendBatchGroupInfoRQ:(NSArray *)groupids
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    std::vector<uint64_t> groupid_list;
    for (int i=0; i<groupids.count; i++) {
        int64_t groupid = [groupids[i] longLongValue];
        groupid_list.push_back(groupid);
    }
    auto list = fbbuilder.CreateVector(groupid_list);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    T_GET_BATCH_GROUP_INFO_RQBuilder info= T_GET_BATCH_GROUP_INFO_RQBuilder(fbbuilder);
    info.add_s_rq_head(&s_rq);
    info.add_list_group_id(list);
    fbbuilder.Finish(info.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_BATCH_INFO_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_BATCH_INFO_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvGroupBatchInfoRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GET_BATCH_GROUP_INFO_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GET_BATCH_GROUP_INFO_RS *group_rs = (grouppack::T_GET_BATCH_GROUP_INFO_RS*)GetT_GET_BATCH_GROUP_INFO_RS(trans_param.buffer.bytes);
    if(!group_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:group_rs->s_rs_head()])
    {
        return;
    }
    int pack_id = group_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    NSMutableArray *infoArr = [NSMutableArray arrayWithCapacity:10];

    for (int i = 0; i<group_rs->list_group_id()->size(); i++) {
        int64_t groupid = group_rs->list_group_id()->Get(i);
        NSLog(@"批量无效群id:%lld",groupid);
        [[NIMSysManager sharedInstance].gidsArr removeObject:@(groupid)];
    }
    
    for (flatbuffers::uoffset_t i = 0; i < group_rs->list_group_info()->size(); i++) {
        
        T_GROUP_BASE_INFO *baseInfo = (T_GROUP_BASE_INFO *)group_rs->list_group_info()->Get(i);
        QBGroupInfoPacket *groupInfo = [[QBGroupInfoPacket alloc] init];
        int64_t group_id = baseInfo->group_id();
        [[NIMSysManager sharedInstance].gidsArr removeObject:@(group_id)];
        NSLog(@"批量成功群id:%lld",group_id);
        groupInfo.group_id = group_id;
        groupInfo.group_count = baseInfo->group_count();
        groupInfo.group_add_is_agree = baseInfo->group_add_is_agree();
        groupInfo.group_manager_user_id = baseInfo->group_manager_user_id();
        groupInfo.group_ct = baseInfo->group_ct();
        groupInfo.message_status = baseInfo->message_status();
        groupInfo.group_max_count = baseInfo->group_max_count();
        groupInfo.group_add_max_count = baseInfo->group_add_max_count();
        if (baseInfo->group_img_url()) {
            groupInfo.group_img_url = [NSString stringWithUTF8String:baseInfo->group_img_url()->c_str()];
        }
        if (baseInfo->group_name()) {
            groupInfo.group_name = [NSString stringWithUTF8String:baseInfo->group_name()->c_str()];
        }
        if (baseInfo->group_remark()) {
            groupInfo.group_remark = [NSString stringWithUTF8String:baseInfo->group_remark()->c_str()];
        }
        
        [infoArr addObject:groupInfo];
    }
    
    //本地数据处理
    if (infoArr.count>0) {
        [[NIMGroupOperationBox sharedInstance] recvGroupDetailInfo:infoArr isMember:YES];
    }
    //批量获取信息
    if ([NIMSysManager sharedInstance].gidsArr.count>20) {
        NSArray *tmpArr = [NIMBaseUtil splitArray:[NIMSysManager sharedInstance].gidsArr withSubSize:20];
        [self sendBatchGroupInfoRQ:tmpArr];
    }else if([NIMSysManager sharedInstance].gidsArr.count>0){
        [self sendBatchGroupInfoRQ:[NIMSysManager sharedInstance].gidsArr];
    }

}


/*+++++++++++++++++++++++++建群+++++++++++++++++++++++++*/
-(void)sendGroupCreateRQ:(QBCreateGroup *)group
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    int packetID = [NIMBaseUtil getPacketSessionID];
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    NSString *operate_user_name = [card defaultName];
    auto operate_name = fbbuilder.CreateString([operate_user_name UTF8String]);
    std::vector<flatbuffers::Offset<commonpack::USER_BASE_INFO> > user_info_list;
    for (int i=0; i<group.user_info_list.count; i++) {
        QBUserBaseInfo *info = group.user_info_list[i];
        auto nick = fbbuilder.CreateString([info.user_nick_name UTF8String]);

        flatbuffers::Offset<USER_BASE_INFO> baseinfo = CreateUSER_BASE_INFO(fbbuilder,info.user_id,nick);

        user_info_list.push_back(baseinfo);
    }
    auto list = fbbuilder.CreateVector(user_info_list);
    T_OPERATE_GROUP_MSGBuilder operateMsg = T_OPERATE_GROUP_MSGBuilder(fbbuilder);
    operateMsg.add_operate_user_name(operate_name);
    operateMsg.add_msg_time(group.group_ct);
    operateMsg.add_user_info_list(list);
    flatbuffers::Offset<T_OPERATE_GROUP_MSG> operate_group_msg = operateMsg.Finish();
    
    T_OFFLINE_GROUP_MSGBuilder msg = T_OFFLINE_GROUP_MSGBuilder(fbbuilder);
    msg.add_user_id(OWNERID);
    msg.add_big_msg_type(GROUP_OFFLINE_CHAT_CREATE);
    msg.add_message_id([NIMBaseUtil GetServerTime]);
    msg.add_operate_group_msg(operate_group_msg);
    
    flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG> offline_group_msg = msg.Finish();

    
    flatbuffers::Offset<flatbuffers::String> remark;
    flatbuffers::Offset<flatbuffers::String> url;
    if (!IsStrEmpty(group.group_remark)) {
        remark = fbbuilder.CreateString([group.group_remark UTF8String]);
    }
    if (!IsStrEmpty(group.group_img_url)) {
        url = fbbuilder.CreateString([group.group_img_url UTF8String]);
    }
    
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    flatbuffers::Offset<T_GROUP_CREATE_RQ> create = grouppack::CreateT_GROUP_CREATE_RQDirect(fbbuilder,&s_rq,[group.group_name UTF8String],[group.group_img_url UTF8String],[group.group_remark UTF8String],group.group_ct,1,offline_group_msg);
    fbbuilder.Finish(create);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_CREATE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_CREATE_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvGroupCreateRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_CREATE_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_CREATE_RS *group_rs = (grouppack::T_GROUP_CREATE_RS*)GetT_GROUP_CREATE_RS(trans_param.buffer.bytes);
    if(!group_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:group_rs->s_rs_head()])
    {
        return;
    }
    int pack_id = group_rs->s_rs_head()->pack_session_id();
    int64_t user_id = group_rs->s_rs_head()->user_id();
    T_OFFLINE_GROUP_MSG *msg = (grouppack::T_OFFLINE_GROUP_MSG *)group_rs->offline_group_msg();
    T_OPERATE_GROUP_MSG *opmsg = (grouppack::T_OPERATE_GROUP_MSG *)msg->operate_group_msg();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    QBGroupCreatePacket *create = [[QBGroupCreatePacket alloc] init];
    create.user_id_list  = [NSMutableArray arrayWithCapacity:10];
    create.group_id = group_rs->group_info()->group_id();
    create.user_id = user_id;
    create.group_ct = group_rs->group_info()->group_ct();
    create.group_count = group_rs->group_info()->group_count();
    create.group_max_count = group_rs->group_info()->group_max_count();
    create.group_manager_user_id = group_rs->group_info()->group_manager_user_id();
    create.group_type = group_rs->group_type();
    create.group_add_max_count = group_rs->group_info()->group_add_max_count();
    create.message_id = msg->message_id();
    if (group_rs->group_info()->group_name()) {
        NSString *group_name= [NSString stringWithCString:group_rs->group_info()->group_name()->c_str() encoding:NSUTF8StringEncoding];
        create.group_name = group_name;
    }
    if (group_rs->group_info()->group_remark()) {
        NSString *group_remark= [NSString stringWithCString:group_rs->group_info()->group_remark()->c_str() encoding:NSUTF8StringEncoding];
        create.group_remark = group_remark;
    }
    if (group_rs->group_info()->group_img_url()) {
        NSString *group_img_url= [NSString stringWithCString:group_rs->group_info()->group_img_url()->c_str() encoding:NSUTF8StringEncoding];
        create.group_img_url = group_img_url;
    }

    for (flatbuffers::uoffset_t i = 0; i < opmsg->user_info_list()->size(); i++) {
        
        USER_BASE_INFO *info = (USER_BASE_INFO *)opmsg->user_info_list()->Get(i);
        NSString *name= [NSString stringWithCString:info->user_nick_name()->c_str() encoding:NSUTF8StringEncoding];
        
        int16_t index = info->user_group_index();
        
        NSNumber *memberType = @(IMGroupRoleTypeNone);
        if (i==0) {
            memberType = @(IMGroupRoleTypeBuilder);
        }
        NSDictionary *dict = @{@"userId":@(info->user_id()),@"memberType":memberType,@"memberNickName":name,@"index":@(index)};
        [create.user_id_list addObject:dict];
    }
    
    NSDictionary *dict = [create compositeWithAttributes];
    NSLog(@"创建群：%@",dict);
    setObjectToUserDefault(_IM_FormatStr(@"%@_lateid",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:create.group_id]), @(create.message_id));
    [[NIMGroupOperationBox sharedInstance] recvCreateGroupWithResponse:create];
}


/*+++++++++++++++++++++++++群操作+++++++++++++++++++++++++*/

//踢人
-(void)sendGroupKickUsers:(NSArray *)userInfos groupid:(int64_t)groupid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    NSString *operate_user_name = [card defaultName];
    auto operate_name = fbbuilder.CreateString([operate_user_name UTF8String]);
    int64_t msg_time = [NIMBaseUtil GetServerTime]/1000;
    int32_t type = GROUP_OFFLINE_CHAT_KICK_USER;
    std::vector<flatbuffers::Offset<commonpack::USER_BASE_INFO> > user_info_list;
    for (int i=0; i<userInfos.count; i++) {
        int64_t userid = [userInfos[i] longLongValue];
        VcardEntity *vcard = [VcardEntity instancetypeFindUserid:userid];
        auto nick = fbbuilder.CreateString([[vcard defaultName] UTF8String]);
        flatbuffers::Offset<USER_BASE_INFO> baseinfo = CreateUSER_BASE_INFO(fbbuilder,userid,nick);
        user_info_list.push_back(baseinfo);
    }
    auto list = fbbuilder.CreateVector(user_info_list);
    
    T_OPERATE_GROUP_MSGBuilder operateMsg = T_OPERATE_GROUP_MSGBuilder(fbbuilder);
    operateMsg.add_operate_user_name(operate_name);
    operateMsg.add_msg_time(msg_time);
    operateMsg.add_user_info_list(list);
    flatbuffers::Offset<T_OPERATE_GROUP_MSG> operate_group_msg = operateMsg.Finish();
    
    T_OFFLINE_GROUP_MSGBuilder msg = T_OFFLINE_GROUP_MSGBuilder(fbbuilder);
    msg.add_user_id(OWNERID);
    msg.add_big_msg_type(type);
    msg.add_message_id([NIMBaseUtil GetServerTime]);
    msg.add_operate_group_msg(operate_group_msg);
    
    flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG> offline_group_msg = msg.Finish();
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    flatbuffers::Offset<T_GROUP_MODIFY_ChANGE_RQ> modify = grouppack::CreateT_GROUP_MODIFY_ChANGE_RQ(fbbuilder,&s_rq,groupid,offline_group_msg);
    
    
    fbbuilder.Finish(modify);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_MODIFY_CHANGE_RQ buffer:buf buf_len:len];
    //加入回调
    int64_t userid =[userInfos[0] longLongValue];
    if (userid==OWNERID) {
        type = GROUP_OFFLINE_CHAT_EXIT;
    }
    
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_MODIFY_CHANGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%d",type]];

}

//邀请
-(void)sendGroupAddUserinfos:(NSArray *)userInfos groupid:(int64_t)groupid opUserid:(int64_t)opUserid oldMsgid:(int64_t)oldMsgid reason:(id)reason
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    NSString *operate_user_name = [card defaultName];
    auto operate_name = fbbuilder.CreateString([operate_user_name UTF8String]);
    int64_t msg_time = [NIMBaseUtil GetServerTime]/1000;
    int32_t type = GROUP_OFFLINE_CHAT_ADD_USER;
    if ([reason isKindOfClass:[NSNumber class]]) {
        type = GROUP_OFFLINE_CHAT_SCAN_ADD_USER;
    }
    
    flatbuffers::Offset<flatbuffers::String> reasonStr;
//    if (!IsStrEmpty(reason)) {
//        reasonStr = fbbuilder.CreateString([reason UTF8String]);
//    }
    
    std::vector<flatbuffers::Offset<commonpack::USER_BASE_INFO> > user_info_list;
    for (int i=0; i<userInfos.count; i++) {
        QBUserBaseInfo *info =userInfos[i];
        auto nick = fbbuilder.CreateString([info.user_nick_name UTF8String]);
        flatbuffers::Offset<USER_BASE_INFO> baseinfo = CreateUSER_BASE_INFO(fbbuilder,info.user_id,nick);
        user_info_list.push_back(baseinfo);
    }
    auto list = fbbuilder.CreateVector(user_info_list);
    
    T_OPERATE_GROUP_MSGBuilder opMsg = T_OPERATE_GROUP_MSGBuilder(fbbuilder);
    opMsg.add_msg_time(msg_time);
    opMsg.add_operate_user_name(operate_name);
    opMsg.add_user_info_list(list);
    //opMsg.add_group_modify_content(reasonStr);
    flatbuffers::Offset<T_OPERATE_GROUP_MSG> op_group_msg = opMsg.Finish();

    T_OFFLINE_GROUP_MSGBuilder msg = T_OFFLINE_GROUP_MSGBuilder(fbbuilder);
    msg.add_user_id(opUserid);
    msg.add_big_msg_type(type);
    msg.add_message_id([NIMBaseUtil GetServerTime]);
    msg.add_operate_group_msg(op_group_msg);
    msg.add_message_old_id(oldMsgid);
    flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG> offline_group_msg = msg.Finish();
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    flatbuffers::Offset<T_GROUP_MODIFY_ChANGE_RQ> modify = grouppack::CreateT_GROUP_MODIFY_ChANGE_RQ(fbbuilder,&s_rq,groupid,offline_group_msg);
    
    
    fbbuilder.Finish(modify);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_MODIFY_CHANGE_RQ buffer:buf buf_len:len];
    //加入回调
    if (opUserid!=OWNERID) {
        type = GROUP_AGREE_ENTER;
    }
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_MODIFY_CHANGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%d",type]];
}


//邀请需要群主同意
-(void)sendInviteAgreeWithType:(int32_t)type groupid:(int64_t)groupid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    auto operate_name = fbbuilder.CreateString([[card defaultName] UTF8String]);
    int64_t msg_time = [NIMBaseUtil GetServerTime]/1000;
    T_OPERATE_GROUP_MSGBuilder operateMsg = T_OPERATE_GROUP_MSGBuilder(fbbuilder);
    operateMsg.add_msg_time(msg_time);
    operateMsg.add_operate_user_name(operate_name);
    flatbuffers::Offset<T_OPERATE_GROUP_MSG> operate_group_msg = operateMsg.Finish();
    
    
    
    T_OFFLINE_GROUP_MSGBuilder msg = T_OFFLINE_GROUP_MSGBuilder(fbbuilder);
    msg.add_user_id(OWNERID);
    msg.add_big_msg_type(type);
    msg.add_message_id([NIMBaseUtil GetServerTime]);
    msg.add_operate_group_msg(operate_group_msg);
    flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG> offline_group_msg = msg.Finish();
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    flatbuffers::Offset<T_GROUP_MODIFY_ChANGE_RQ> modify = grouppack::CreateT_GROUP_MODIFY_ChANGE_RQ(fbbuilder,&s_rq,groupid,offline_group_msg);
    
    fbbuilder.Finish(modify);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_MODIFY_CHANGE_RQ buffer:buf buf_len:len];

    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_MODIFY_CHANGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%d",type]];
}

//群信息修改
-(void)changeGroupInfo:(int64_t)groupid content:(NSString *)content type:(GROUP_CHAT_OFFLINE_TYPE)type
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    auto operate_name = fbbuilder.CreateString([[card defaultName] UTF8String]);
    int64_t msg_time = [NIMBaseUtil GetServerTime]/1000;
    auto mfcontent = fbbuilder.CreateString([content UTF8String]);

    T_OPERATE_GROUP_MSGBuilder operateMsg = T_OPERATE_GROUP_MSGBuilder(fbbuilder);
    operateMsg.add_msg_time(msg_time);
    operateMsg.add_operate_user_name(operate_name);
    operateMsg.add_group_modify_content(mfcontent);
    flatbuffers::Offset<T_OPERATE_GROUP_MSG> operate_group_msg = operateMsg.Finish();
    
    T_OFFLINE_GROUP_MSGBuilder msg = T_OFFLINE_GROUP_MSGBuilder(fbbuilder);
    msg.add_user_id(OWNERID);
    msg.add_big_msg_type(type);
    msg.add_message_id([NIMBaseUtil GetServerTime]);
    msg.add_operate_group_msg(operate_group_msg);
    flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG> offline_group_msg = msg.Finish();
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    flatbuffers::Offset<T_GROUP_MODIFY_ChANGE_RQ> modify = grouppack::CreateT_GROUP_MODIFY_ChANGE_RQ(fbbuilder,&s_rq,groupid,offline_group_msg);
    
    fbbuilder.Finish(modify);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_MODIFY_CHANGE_RQ buffer:buf buf_len:len];
    
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_MODIFY_CHANGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%ld",(long)type]];
    
}



-(void)recvGroupModifyChangeRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_MODIFY_ChANGE_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_MODIFY_ChANGE_RS *group_rs = (grouppack::T_GROUP_MODIFY_ChANGE_RS*)GetT_GROUP_MODIFY_ChANGE_RS(trans_param.buffer.bytes);
    if(!group_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:group_rs->s_rs_head()])
    {
        return;
    }
    int pack_id = group_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    T_OFFLINE_GROUP_MSG *msg = (T_OFFLINE_GROUP_MSG *)group_rs->offline_group_msg();
    int64_t opUserid = msg->user_id();
    int32_t bigType = msg->big_msg_type();
    int64_t msgId = msg->message_id();
    int64_t oldMsgId = msg->message_old_id();
    if (bigType==GROUP_OFFLINE_CHAT_ADD_USER_AGREE) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_ADD object:@(bigType)];
        return;
    }
    
    QBGroupOfflinePacket *modify = [[QBGroupOfflinePacket alloc] init];

    T_GROUP_BASE_INFO *info = (grouppack::T_GROUP_BASE_INFO *)group_rs->group_info();
    int64_t group_count = info->group_count();;
    int64_t group_id = info->group_id();;

    if (info->group_name()) {
        modify.group_name = [NIMBaseUtil getStringWithCString:info->group_name()->c_str()];
    }else{
        modify.group_name = @"";
    }
    if (info->group_img_url()) {
        modify.group_img_url =  [NIMBaseUtil getStringWithCString:info->group_img_url()->c_str()];
        
    }else{
        modify.group_img_url = @"";
    }
    modify.group_id = group_id;
    modify.group_count = group_count;
    modify.user_id = opUserid;
    modify.group_manager_user_id = info->group_manager_user_id();
    modify.big_msg_type = bigType;
    modify.message_id = msgId;
    modify.group_add_is_agree = info->group_add_is_agree();
    modify.message_old_id = oldMsgId;
    modify.group_max_count = info->group_max_count();
    modify.group_add_max_count = info->group_add_max_count();
    T_OPERATE_GROUP_MSG *opMsg = (T_OPERATE_GROUP_MSG *)msg->operate_group_msg();
    QBGroupOperatePacket *op = [[QBGroupOperatePacket alloc] init];
    op.msg_time = opMsg->msg_time();
    if (opMsg->group_modify_content()) {
        op.group_modify_content = [NSString stringWithUTF8String:opMsg->group_modify_content()->c_str()];
    }
    if (opMsg->operate_user_name()) {
        op.operate_user_name = [NSString stringWithCString:opMsg->operate_user_name()->c_str() encoding:NSUTF8StringEncoding];
    }
    op.user_info_list = [NSMutableArray arrayWithCapacity:10];
    if (opMsg->user_info_list()) {
        for (flatbuffers::uoffset_t i = 0; i < opMsg->user_info_list()->size(); i++) {
            
            USER_BASE_INFO *info = (USER_BASE_INFO *)opMsg->user_info_list()->Get(i);
            QBUserBaseInfo *user = [[QBUserBaseInfo alloc] init];
            
            NSString *name= [NSString stringWithCString:info->user_nick_name()->c_str() encoding:NSUTF8StringEncoding];
            
            int16_t index = info->user_group_index();
            
            user.user_id = info->user_id();
            user.user_nick_name = name;
            user.user_group_index = index;
            
            [op.user_info_list addObject:user];
        }
    }
    
    modify.groupOperate = op;
    
    [[NIMGroupOperationBox sharedInstance] recvGroupModifyChangeRQWithResponse:modify];
}


/*+++++++++++++++++++++++++收到群操作+++++++++++++++++++++++++*/

//废弃，改为通过离线消息类型获取
/*
-(void)recvServerGroupModifyChangeRQ:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_MODIFY_SERVER_RQBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_MODIFY_SERVER_RQ *group_rq = (grouppack::T_GROUP_MODIFY_SERVER_RQ*)GetT_GROUP_MODIFY_SERVER_RQ(trans_param.buffer.bytes);
    if(!group_rq)
    {
        return;
    }
    T_OFFLINE_GROUP_MSG *msg = (grouppack::T_OFFLINE_GROUP_MSG *)group_rq->offline_group_msg();
    int64_t opUserid = msg->user_id();
    int32_t bigType = msg->big_msg_type();
    int64_t msgId = msg->message_id();
    
    QBGroupOfflinePacket *modify = [[QBGroupOfflinePacket alloc] init];
    T_GROUP_BASE_INFO *info = (grouppack::T_GROUP_BASE_INFO *)group_rq->group_base_info();
    int64_t group_count = info->group_count();;
    int64_t group_id = info->group_id();
    if (info->group_name()) {
        modify.group_name = [NIMBaseUtil getStringWithCString:info->group_name()->c_str()];
    }else{
        modify.group_name = @"";
    }
    if (info->group_img_url()) {
        modify.group_img_url =  [NIMBaseUtil getStringWithCString:info->group_img_url()->c_str()];
        
    }else{
        modify.group_img_url = @"";
    }
    modify.group_id = group_id;
    modify.group_count = group_count;
    modify.user_id = opUserid;
    modify.group_manager_user_id = info->group_manager_user_id();
    modify.big_msg_type = bigType;
    modify.message_id = msgId;
    modify.group_add_is_agree = info->group_add_is_agree();
    modify.message_old_id = msg->message_old_id();
    modify.group_max_count = info->group_max_count();
    modify.group_add_max_count = info->group_add_max_count();
    T_OPERATE_GROUP_MSG *opMsg = (T_OPERATE_GROUP_MSG *)msg->operate_group_msg();

    QBGroupOperatePacket *op = [[QBGroupOperatePacket alloc] init];
    op.msg_time = opMsg->msg_time();
    if (opMsg->operate_user_name()) {
        op.operate_user_name = [NSString stringWithCString:opMsg->operate_user_name()->c_str() encoding:NSUTF8StringEncoding];
    }
    op.user_info_list = [NSMutableArray arrayWithCapacity:10];
    if (opMsg->user_info_list()) {
        for (flatbuffers::uoffset_t i = 0; i < opMsg->user_info_list()->size(); i++) {
            
            USER_BASE_INFO *info = (USER_BASE_INFO *)opMsg->user_info_list()->Get(i);
            QBUserBaseInfo *user = [[QBUserBaseInfo alloc] init];
            
            NSString *name= [NSString stringWithCString:info->user_nick_name()->c_str() encoding:NSUTF8StringEncoding];
            
            int16_t index = info->user_group_index();
            
            user.user_id = info->user_id();
            user.user_nick_name = name;
            user.user_group_index = index;
            
            [op.user_info_list addObject:user];
        }
    }
    modify.groupOperate = op;
    NSLog(@"收到群操作");
    [[NIMGroupOperationBox sharedInstance] recvGroupModifyChangeRQWithResponse:modify];

}

-(void)sendServerGroupModifyChangeRQWithType:(GROUP_CHAT_OFFLINE_TYPE)type opUserid:(int64_t)opUserid
{
//    flatbuffers::FlatBufferBuilder fbbuilder;
//    
//    int packetID = [NIMBaseUtil getPacketSessionID];
//    S_RS_HEAD s_rs(OWNERID,packetID,0,PLATFORM_APP);
//    
//    T_GROUP_MODIFY_SERVER_RSBuilder modify = T_GROUP_MODIFY_SERVER_RSBuilder(fbbuilder);
    
}
*/
/*+++++++++++++++++++++++++群主转让+++++++++++++++++++++++++*/
-(void)sendLeaderChangeUserid:(int64_t)opUserid groupid:(int64_t)groupid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    NSString *operate_user_name = [card defaultName];
    auto operate_name = fbbuilder.CreateString([operate_user_name UTF8String]);
    
    int64_t msg_time = [NIMBaseUtil GetServerTime]/1000;
    int32_t type = GROUP_OFFLINE_CHAT_KICK_USER;
    std::vector<flatbuffers::Offset<commonpack::USER_BASE_INFO> > user_info_list;
    for (int i=0; i<1; i++) {
        VcardEntity *cardEntity = [VcardEntity instancetypeFindUserid:opUserid];
        NSString *nickName = [cardEntity defaultName];
        auto nick = fbbuilder.CreateString([nickName UTF8String]);
        flatbuffers::Offset<USER_BASE_INFO> baseinfo = CreateUSER_BASE_INFO(fbbuilder,opUserid,nick);
        user_info_list.push_back(baseinfo);
    }
    auto list = fbbuilder.CreateVector(user_info_list);
    
    T_OPERATE_GROUP_MSGBuilder operateMsg = T_OPERATE_GROUP_MSGBuilder(fbbuilder);
    operateMsg.add_operate_user_name(operate_name);
    operateMsg.add_msg_time(msg_time);
    operateMsg.add_user_info_list(list);
    flatbuffers::Offset<T_OPERATE_GROUP_MSG> operate_group_msg = operateMsg.Finish();
    
    T_OFFLINE_GROUP_MSGBuilder msg = T_OFFLINE_GROUP_MSGBuilder(fbbuilder);
    msg.add_user_id(OWNERID);
    msg.add_big_msg_type(type);
    msg.add_message_id([NIMBaseUtil GetServerTime]);
    msg.add_operate_group_msg(operate_group_msg);
    
    flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG> offline_group_msg = msg.Finish();
    
    T_GROUP_LEADER_CHANGE_RQBuilder builder= T_GROUP_LEADER_CHANGE_RQBuilder(fbbuilder);
    builder.add_group_id(groupid);
    builder.add_offline_group_msg(offline_group_msg);
    builder.add_s_rq_head(&s_rq);
    fbbuilder.Finish(builder.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_LEADER_CHANGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_LEADER_CHANGE_RQ buffer:buf buf_len:len packID:packetID msgId:0];

}


-(void)recvLeaderChangeRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_LEADER_CHANGE_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_LEADER_CHANGE_RS *leader = (T_GROUP_LEADER_CHANGE_RS *)GetT_GROUP_LEADER_CHANGE_RS(trans_param.buffer.bytes);
    
    if(!leader)
    {
        return;
    }
    //检查头
    if(![super checkHead:leader->s_rs_head()])
    {
        return;
    }
    int pack_id = leader->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    int64_t groupid = leader->group_id();
    
    T_OFFLINE_GROUP_MSG *msg = (grouppack::T_OFFLINE_GROUP_MSG *)leader->offline_group_msg();
    int64_t opUserid = msg->user_id();
    int32_t bigType = msg->big_msg_type();
    int64_t msgId = msg->message_id();
    
    QBGroupOfflinePacket *modify = [[QBGroupOfflinePacket alloc] init];
    modify.group_id = groupid;
    modify.user_id = opUserid;
    modify.big_msg_type = bigType;
    modify.message_id = msgId;

    
    T_OPERATE_GROUP_MSG *opMsg = (T_OPERATE_GROUP_MSG *)msg->operate_group_msg();
    QBGroupOperatePacket *op = [[QBGroupOperatePacket alloc] init];
    
    op.user_info_list = [NSMutableArray arrayWithCapacity:10];
    
    for (flatbuffers::uoffset_t i = 0; i < opMsg->user_info_list()->size(); i++) {
        
        USER_BASE_INFO *info = (USER_BASE_INFO *)opMsg->user_info_list()->Get(i);
        QBUserBaseInfo *user = [[QBUserBaseInfo alloc] init];
        
        NSString *name= [NSString stringWithCString:info->user_nick_name()->c_str() encoding:NSUTF8StringEncoding];
        
        int16_t index = info->user_group_index();
        
        user.user_id = info->user_id();
        user.user_nick_name = name;
        user.user_group_index = index;
        
        [op.user_info_list addObject:user];
    }
    op.msg_time = opMsg->msg_time();
    op.operate_user_name = [NSString stringWithCString:opMsg->operate_user_name()->c_str() encoding:NSUTF8StringEncoding];
    modify.groupOperate = op;
    [[NIMGroupOperationBox sharedInstance] recvGroupModifyChangeRQWithResponse:modify];
    
}


/*+++++++++++++++++++++++++获取群公告详情+++++++++++++++++++++++++*/

-(void)fetchGroupRemarkDetail:(int64_t)groupid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    T_GROUP_REMARK_DETAIL_RQBuilder detail = T_GROUP_REMARK_DETAIL_RQBuilder(fbbuilder);
    detail.add_s_rq_head(&s_rq);
    detail.add_group_id(groupid);
    fbbuilder.Finish(detail.Finish());
    
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_REMARK_DETAIL_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_REMARK_DETAIL_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvGroupRemarkDetail:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_REMARK_DETAIL_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_REMARK_DETAIL_RS *detail = (T_GROUP_REMARK_DETAIL_RS *)GetT_GROUP_REMARK_DETAIL_RS(trans_param.buffer.bytes);
    
    if(!detail)
    {
        return;
    }
    //检查头
    if(![super checkHead:detail->s_rs_head()])
    {
        return;
    }
    int pack_id = detail->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    int64_t ct = detail->op_ct();
    int64_t userid = detail->op_user_id();
    NSString *reamrk = nil;
    if (detail->op_remark()) {
        reamrk = [NSString stringWithCString:detail->op_remark()->c_str() encoding:NSUTF8StringEncoding];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_REMARK_DETAIL object:@{@"userid":@(userid),@"ct":@(ct*1000),@"reamrk":reamrk}];
}


/*+++++++++++++++++++++++++群消息状态+++++++++++++++++++++++++*/
-(void)sendGroupMessageStatue:(int64_t)groupid status:(GROUP_MESSAGE_STATUS)status
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_GROUP_MESSAGE_STATUS_RQBuilder msgStatus = T_GROUP_MESSAGE_STATUS_RQBuilder(fbbuilder);
    msgStatus.add_s_rq_head(&s_rq);
    msgStatus.add_group_id(groupid);
    msgStatus.add_message_status(status);
    
    fbbuilder.Finish(msgStatus.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_MESSAGE_STATUS_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_MESSAGE_STATUS_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}


-(void)recvGroupMessageStatue:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_MESSAGE_STATUS_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_MESSAGE_STATUS_RS *msgStatus = (T_GROUP_MESSAGE_STATUS_RS *)GetT_GROUP_MESSAGE_STATUS_RS(trans_param.buffer.bytes);
    
    if(!msgStatus)
    {
        return;
    }
    //检查头
    if(![super checkHead:msgStatus->s_rs_head()])
    {
        return;
    }
    int pack_id = msgStatus->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    int64_t groupid = msgStatus->group_id();
    GROUP_MESSAGE_STATUS status = (GROUP_MESSAGE_STATUS)msgStatus->message_status();
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_MESSAGE_STATUS object:@{@"groupid":@(groupid),@"status":@(status)}];
}


/*+++++++++++++++++++++++++群类型+++++++++++++++++++++++++*/
-(void)sendGroupTypeListRQ
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_GROUP_TYPE_LIST_RQBuilder type = T_GROUP_TYPE_LIST_RQBuilder(fbbuilder);
    type.add_s_rq_head(&s_rq);
    
    fbbuilder.Finish(type.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_TYPE_LIST_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_TYPE_LIST_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvGroupTypeListRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_MESSAGE_STATUS_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_TYPE_LIST_RS *typeList = (T_GROUP_TYPE_LIST_RS *)GetT_GROUP_TYPE_LIST_RS(trans_param.buffer.bytes);
    
    if(!typeList)
    {
        return;
    }
    //检查头
    if(![super checkHead:typeList->s_rs_head()])
    {
        return;
    }
    int pack_id = typeList->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];

    
    if (!typeList->list_group_type_info()) {
        return;
    }
    
    NIMGroupTypeInfo *typeInfo = [[NIMGroupTypeInfo alloc] init];
    
    for (flatbuffers::uoffset_t i = 0; i < typeList->list_group_type_info()->size(); i++) {
        T_GROUP_TYPE_INFO *info = (T_GROUP_TYPE_INFO*)typeList->list_group_type_info()->Get(i);
                
        typeInfo.group_max_count = info->group_max_count();
        typeInfo.group_add_max_count = info->group_add_max_count();
        typeInfo.group_type = info->group_type();
        typeInfo.group_is_show = info->group_is_show();
        
        [[NIMSysManager sharedInstance].typeDict setObject:typeInfo forKey:@(info->group_type())];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_TYPE_LIST object:typeInfo];
}

-(void)sendMemberNameRQ:(int64_t)groupid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_GROUP_GET_USER_REMARK_NAME_RQBuilder getName = T_GROUP_GET_USER_REMARK_NAME_RQBuilder(fbbuilder);
    getName.add_s_rq_head(&s_rq);
    getName.add_group_id(groupid);
    fbbuilder.Finish(getName.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_GET_USER_REMARK_NAME_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_GET_USER_REMARK_NAME_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}


-(void)recvMemberNameRS:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_GET_USER_REMARK_NAME_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_GET_USER_REMARK_NAME_RS *getName = (T_GROUP_GET_USER_REMARK_NAME_RS *)GetT_GROUP_GET_USER_REMARK_NAME_RS(trans_param.buffer.bytes);
    
    if(!getName)
    {
        return;
    }
    //检查头
    if(![super checkHead:getName->s_rs_head()])
    {
        return;
    }
    int pack_id = getName->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    int64_t groupid = getName->group_id();
    NSString *memberName = [NSString stringWithUTF8String:getName->user_remark_name()->c_str()];
    NSLog(@"%lld%@",groupid,memberName);
    GroupList *groupList = [GroupList instancetypeFindGroupId:groupid];
    if (groupList&&![groupList.selfcard isEqualToString:memberName]) {
        groupList.selfcard = memberName;
        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    }

}


/*+++++++++++++++++++++++++保存到通讯录状态+++++++++++++++++++++++++*/
-(void)sendGroupSave:(int64_t)groupid status:(NIM_GROUP_SAVE_TYPE)status
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_GROUP_SAVE_CHANGE_RQBuilder msgStatus = T_GROUP_SAVE_CHANGE_RQBuilder(fbbuilder);
    msgStatus.add_s_rq_head(&s_rq);
    msgStatus.add_group_id(groupid);
    msgStatus.add_save_type(status);
    fbbuilder.Finish(msgStatus.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_SAVE_CHANGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_SAVE_CHANGE_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}


-(void)recvGroupSaveStatus:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_MESSAGE_STATUS_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_SAVE_CHANGE_RS *msgStatus = (T_GROUP_SAVE_CHANGE_RS *)GetT_GROUP_SAVE_CHANGE_RS(trans_param.buffer.bytes);
    
    if(!msgStatus)
    {
        return;
    }
    //检查头
    if(![super checkHead:msgStatus->s_rs_head()])
    {
        return;
    }
    int pack_id = msgStatus->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    int64_t groupid = msgStatus->group_id();
    NIM_GROUP_SAVE_TYPE status = (NIM_GROUP_SAVE_TYPE)msgStatus->save_type();
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_SAVE_STATUS object:@{@"groupid":@(groupid),@"status":@(status)}];
}

/*+++++++++++++++++++++++++扫描二维码获取群信息+++++++++++++++++++++++++*/
-(void)sendGroupScan:(int64_t)groupid shareid:(int64_t)shareid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    T_GROUP_SCAN_RQBuilder msgStatus = T_GROUP_SCAN_RQBuilder(fbbuilder);
    msgStatus.add_s_rq_head(&s_rq);
    msgStatus.add_group_id(groupid);
    msgStatus.add_user_id_share(shareid);
    fbbuilder.Finish(msgStatus.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_SCAN_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_SCAN_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}


-(void)recvGroupScan:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = grouppack::VerifyT_GROUP_SCAN_RSBuffer(verifier);
    if (!is_fbs) {
        NSLog(@"服务器回包错误");
        return;
    }
    T_GROUP_SCAN_RS *scan_rs = (T_GROUP_SCAN_RS *)GetT_GROUP_SCAN_RS(trans_param.buffer.bytes);
    
    if(!scan_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:scan_rs->s_rs_head()])
    {
        return;
    }
    int pack_id = scan_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    BOOL isMember  = scan_rs->isMember();
    T_GROUP_BASE_INFO *baseInfo = (T_GROUP_BASE_INFO *)scan_rs->group_info();
    QBGroupInfoPacket *groupInfo = [[QBGroupInfoPacket alloc] init];
    groupInfo.group_id = baseInfo->group_id();
    groupInfo.group_count = baseInfo->group_count();
    groupInfo.group_add_is_agree = baseInfo->group_add_is_agree();
    groupInfo.group_manager_user_id = baseInfo->group_manager_user_id();
    groupInfo.group_ct = baseInfo->group_ct();
    groupInfo.message_status = baseInfo->message_status();
    groupInfo.group_max_count = baseInfo->group_max_count();
    groupInfo.group_add_max_count = baseInfo->group_add_max_count();
    if (baseInfo->group_img_url()) {
        groupInfo.group_img_url = [NSString stringWithUTF8String:baseInfo->group_img_url()->c_str()];
    }
    if (baseInfo->group_name()) {
        groupInfo.group_name = [NSString stringWithUTF8String:baseInfo->group_name()->c_str()];
    }
    [[NIMGroupOperationBox sharedInstance] recvGroupDetailInfo:@[groupInfo] isMember:isMember];
    NSDictionary *dict = @{@"content":groupInfo,@"isMember":@(isMember)};
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_INFO object:dict];
}


@end
