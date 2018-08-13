//
//  NIMOfflineMessageProcessor.m
//  qbim
//
//  Created by 秦雨 on 17/2/7.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMOfflineMessageProcessor.h"
#import "NIMCallBackManager.h"

#import "fb_client_get_offline_message_rq_generated.h"
#import "fb_client_get_offline_message_rs_generated.h"
#import "fb_offline_msg_generated.h"
//#import "fb_friend_server_add_confirm_rq_generated.h"
//#import "fb_friend_server_add_rq_generated.h"
#import "fb_server_send_message_rq_generated.h"

#import "fb_group_get_offline_msg_rq_generated.h"
#import "fb_group_get_offline_msg_rs_generated.h"
#import "fb_group_offline_msg_generated.h"
#import "fb_group_base_request_generated.h"
#import "fb_offcial_offline_msg_generated.h"
#import "fb_fans_offline_msg_generated.h"

#import "fb_client_offcial_get_offline_msg_rq_generated.h"
#import "fb_client_offcial_get_offline_msg_rs_generated.h"
#import "fb_client_fans_get_offline_msg_rq_generated.h"
#import "fb_client_fans_get_offline_msg_rs_generated.h"
#import "fb_client_fans_get_sys_msg_rq_generated.h"
#import "fb_client_fans_get_sys_msg_rs_generated.h"

@implementation NIMOfflineMessageProcessor
using namespace commonpack;
using namespace scpack;
using namespace grouppack;
//using namespace friendpack;
using namespace offcialpack;

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
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CHAT_GET_OFFLINE_MESSAGE_RS class_name:self func_name:@"recvSingleOfflineMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_GET_OFFLINE_MESSAGE_RS class_name:self func_name:@"recvGroupOfflineMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_FANS_GET_OFFLINE_MESSAGE_RS class_name:self func_name:@"recvOffcialOfflineMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_FANS_GET_SYS_MESSAGE_RS class_name:self func_name:@"recvSysOfflineMessage:"];

    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_OFFCIAL_GET_OFFLINE_MESSAGE_RS class_name:self func_name:@"recvFansOfflineMessageRS:"];

    
}


/*+++++++++++++++++++++++++单聊离线消息+++++++++++++++++++++++++*/
-(void)sendSingleOfflineMessageRQ:(QBSingleOffline *)offline
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    const commonpack::S_RQ_HEAD s_rq(offline.user_id,offline.session_id,PLATFORM_APP);
    T_CHAT_GET_OFFLINE_MESSAGE_RQBuilder offlineMsg = T_CHAT_GET_OFFLINE_MESSAGE_RQBuilder(fbbuilder);
    offlineMsg.add_s_rq_head(&s_rq);
    offlineMsg.add_next_message_id(offline.next_message_id);
    
    fbbuilder.Finish(offlineMsg.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CHAT_GET_OFFLINE_MESSAGE_RQ buffer:buf buf_len:len];

}

-(void)recvSingleOfflineMessageRS:(QBTransParam *)trans_param
{
    DBLog(@"NIMOfflineMessageProcessor recv single");
    T_CHAT_GET_OFFLINE_MESSAGE_RS *t_offline_message_rs = (scpack::T_CHAT_GET_OFFLINE_MESSAGE_RS*)GetT_CHAT_GET_OFFLINE_MESSAGE_RS(trans_param.buffer.bytes);
    if(!t_offline_message_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:t_offline_message_rs->s_rs_head()])
    {
        return;
    }
    uint64 next_message_id = 0;
    BOOL isempty = YES;
    
    next_message_id = t_offline_message_rs->next_message_id();
    
    //离线消息列表
    const flatbuffers::Vector<flatbuffers::Offset<scpack::T_OFFLINE_MSG>> *s_offline_msg_list = t_offline_message_rs->s_offline_msg_list();
    
    if(!s_offline_msg_list)
    {
        return;
    }
    NSMutableArray *scList = [NSMutableArray arrayWithCapacity:10];
    for (flatbuffers::uoffset_t i = 0; i < s_offline_msg_list->size(); i++)
    {
        isempty = NO;
        //离线消息
        T_OFFLINE_MSG *offline_msg =  (T_OFFLINE_MSG *)s_offline_msg_list->Get(i);
        const commonpack:: S_MSG* s_msg = offline_msg->s_msg();
        
        QBSingleChatPacket *packet = [[QBSingleChatPacket alloc] init];
        packet.user_id = t_offline_message_rs->s_rs_head()->user_id();
        packet.op_user_id = offline_msg->op_user_id();
        packet.msg_content = [NSString stringWithCString:s_msg->msg_content()->c_str() encoding:NSUTF8StringEncoding];
        packet.chat_type = s_msg->chat_type();;
        packet.m_type = s_msg->m_type();
        packet.s_type = s_msg->s_type();
        packet.ext_type = s_msg->ext_type();
        packet.message_id = offline_msg->message_id();
        packet.msg_time = s_msg->msg_time();
        packet.send_user_name = [NSString stringWithCString:s_msg->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
        packet.b_id = offline_msg->b_id();
        packet.w_id = offline_msg->w_id();
        packet.c_id = offline_msg->c_id();
        NSDictionary *dict = [packet compositeWithAttributes];
//        BOOL isSF = [getObjectFromUserDefault(KEY_Single_Offline) boolValue];
//        BOOL isGF = [getObjectFromUserDefault(KEY_Group_Offline) boolValue];
//        BOOL isOfflineFinish = isSF && isGF;
        [scList addObject:dict];
        [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:offline_msg->op_user_id() chat_type:s_msg->chat_type() unread_count:1];
        DBLog(@"单聊离线信息：%@",dict);
    }
    BOOL isSF = [getObjectFromUserDefault(KEY_Single_Offline) boolValue];
    BOOL isGF = [getObjectFromUserDefault(KEY_Group_Offline) boolValue];
    BOOL isOfflineFinish = isSF && isGF;
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:scList isRemind:isOfflineFinish];

    if (0xFFFFFFFFFFFFFFFF != next_message_id || !isempty)
    {
        QBSingleOffline *offline = [[QBSingleOffline alloc] init];
        offline.user_id = OWNERID;
        offline.session_id = [NIMBaseUtil getPacketSessionID];
        offline.next_message_id = next_message_id;
        [self sendSingleOfflineMessageRQ:offline];
    }else{
        //离线获取完毕
        BOOL isFinish = [getObjectFromUserDefault(KEY_Single_Offline) boolValue];
        if (!isFinish) {
            setObjectToUserDefault(KEY_Single_Offline, @(YES));
        }
    }
    
}


/*+++++++++++++++++++++++++群组离线消息+++++++++++++++++++++++++*/
-(void)sendGroupOfflineMessageRQ:(QBGroupOffline *)offline
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    std::vector< flatbuffers::Offset<grouppack::T_GROUP_BASE_REQUEST> > vector_group_base_rq;
    for (flatbuffers::uoffset_t i = 0; i < offline.groupOfflines.count; i++)
    {
        T_GROUP_BASE_REQUESTBuilder groupbaserequest = grouppack::T_GROUP_BASE_REQUESTBuilder(fbbuilder);
        QBGroupOfflineBody *body = offline.groupOfflines[i];
        groupbaserequest.add_group_id(body.group_id);
        groupbaserequest.add_next_message_id(body.next_message_id);
        vector_group_base_rq.push_back(groupbaserequest.Finish());
    }
    
    auto vec_vector_group_base_a = fbbuilder.CreateVector(vector_group_base_rq);
    
    const commonpack::S_RQ_HEAD s_rq(offline.user_id,offline.session_id,PLATFORM_APP);
    T_GROUP_GET_OFFLINE_MESSAGE_RQBuilder offlineMsg = T_GROUP_GET_OFFLINE_MESSAGE_RQBuilder(fbbuilder);
    offlineMsg.add_s_rq_head(&s_rq);
    offlineMsg.add_list_group_offline_msg_request(vec_vector_group_base_a);
    
    fbbuilder.Finish(offlineMsg.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_GET_OFFLINE_MESSAGE_RQ buffer:buf buf_len:len];
}

-(void)recvGroupOfflineMessageRS:(QBTransParam *)trans_param
{
    DBLog(@"NIMOfflineMessageProcessor recv group");
    T_GROUP_GET_OFFLINE_MESSAGE_RS *t_offline_message_rs = (grouppack::T_GROUP_GET_OFFLINE_MESSAGE_RS*)GetT_GROUP_GET_OFFLINE_MESSAGE_RS(trans_param.buffer.bytes);
    if(!t_offline_message_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:t_offline_message_rs->s_rs_head()])
    {
        return;
    }
    
    BOOL isempty = YES;
    uint64 next_message_id = 0;
    
    const flatbuffers::Vector<flatbuffers::Offset<grouppack::T_GROUP_ALL_OFFLINE_MSG>> * s_group_all_msg
    =  t_offline_message_rs->list_group_offline_msg_response();
    
    QBGroupChatPacket *packet = [[QBGroupChatPacket alloc] init];
    QBGroupOffline *offline = [[QBGroupOffline alloc] init];
    offline.groupOfflines = [NSMutableArray arrayWithCapacity:10];
    for (flatbuffers::uoffset_t i = 0; i < s_group_all_msg->size(); i++)
    {
        grouppack::T_GROUP_ALL_OFFLINE_MSG *t_group_all_msg = (grouppack::T_GROUP_ALL_OFFLINE_MSG *)s_group_all_msg->Get(i);
        int64_t groupid = t_group_all_msg->group_id();
        
        packet.group_id = groupid;
        
        GROUP_OFFLINE_MSG_IS_FINISH isFinish = (GROUP_OFFLINE_MSG_IS_FINISH)t_group_all_msg->is_finish();
        const flatbuffers::Vector<flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG>> * s_group_msg_list
        =  t_group_all_msg->s_offline_msg_list();
        if (s_group_msg_list == nil) {
            return;
        }
        NSMutableArray *gcList = [NSMutableArray arrayWithCapacity:10];
        
        for (flatbuffers::uoffset_t j = 0; j < s_group_msg_list->size(); j++)
        {
            
            T_OFFLINE_GROUP_MSG * t_offline_group_msg = (T_OFFLINE_GROUP_MSG *)
            s_group_msg_list->Get(j);
            
            int32_t big_type = t_offline_group_msg->big_msg_type();
            uint64 message_id = t_offline_group_msg->message_id();
            next_message_id = message_id;
            int64_t op_user_id = t_offline_group_msg->user_id();
            int64_t oldMsgId = t_offline_group_msg->message_old_id();
            NSString *content=nil;
            int32_t m_type = 1;
            int32_t s_type = 0;
            int32_t ext_type = 0;
            int64_t msg_time = 0;
            
            BOOL isRecv = YES;
            NSString *mbd = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid];
            id recvObj = [[NIMSysManager sharedInstance].recvDict objectForKey:mbd];
            if (recvObj) {
                isRecv = [recvObj boolValue];
            }
            if (big_type == GROUP_OFFLINE_CHAT_KICK_USER) {
                const T_OPERATE_GROUP_MSG *opMsg = t_offline_group_msg->operate_group_msg();
                for (flatbuffers::uoffset_t k = 0; k < opMsg->user_info_list()->size(); k++) {
                    
                    USER_BASE_INFO *info = (USER_BASE_INFO *)opMsg->user_info_list()->Get(k);
                    if (info->user_id() == OWNERID) {
                        [[NIMSysManager sharedInstance].recvDict setObject:@NO forKey:mbd];
                        break;
                    }
                }
            }else if (big_type == GROUP_OFFLINE_CHAT_ADD_USER ||
                      big_type == GROUP_OFFLINE_CHAT_SCAN_ADD_USER) {
                const T_OPERATE_GROUP_MSG *opMsg = t_offline_group_msg->operate_group_msg();
                for (flatbuffers::uoffset_t k = 0; k < opMsg->user_info_list()->size(); k++) {
                    
                    USER_BASE_INFO *info = (USER_BASE_INFO *)opMsg->user_info_list()->Get(k);
                    if (info->user_id() == OWNERID) {
                        [[NIMSysManager sharedInstance].recvDict setObject:@YES forKey:mbd];
                        break;
                    }
                }

            }else if (big_type == GROUP_OFFLINE_CHAT_NORMAL && !isRecv){
                continue;
            }
            
            
            
            setObjectToUserDefault(_IM_FormatStr(@"%@_lateid",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]), @(message_id));

            if (big_type==GROUP_OFFLINE_CHAT_NORMAL) {
                
                const commonpack::S_MSG* s_msg = t_offline_group_msg->s_msg();
                content = [NSString stringWithCString:s_msg->msg_content()->c_str() encoding:NSUTF8StringEncoding];
                msg_time = s_msg->msg_time();
                packet.send_user_name = [NSString stringWithCString:s_msg->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
                m_type = s_msg->m_type();
                s_type = s_msg->s_type();
                ext_type = s_msg->ext_type();
                packet.user_id = OWNERID;
                packet.op_user_id = op_user_id;
                packet.msg_content = content;
                packet.chat_type = GROUP;
                packet.m_type = m_type;
                packet.s_type = s_type;
                packet.ext_type = ext_type;
                packet.message_id = message_id;
                packet.msg_time = msg_time;
                packet.isSender = op_user_id==OWNERID?YES:NO;
                NSDictionary *dict = [packet compositeWithAttributes];
//                BOOL isSF = [getObjectFromUserDefault(KEY_Single_Offline) boolValue];
//                BOOL isGF = [getObjectFromUserDefault(KEY_Group_Offline) boolValue];
//                BOOL isOfflineFinish = isSF && isGF;
                if (op_user_id != OWNERID) {
                    [gcList addObject:dict];
                }
            }else{
                
                T_GROUP_BASE_INFO *groupInfo = (T_GROUP_BASE_INFO *)t_offline_group_msg->group_info();
                
                if (groupInfo==nil) {
                    continue;
                }
                if (big_type == GROUP_OFFLINE_CHAT_ADD_USER_AGREE&&
                    groupInfo->group_manager_user_id()!=OWNERID) {
                    continue;
                }
                QBGroupOfflinePacket *modify = [[QBGroupOfflinePacket alloc] init];
                int32_t group_count = groupInfo->group_count();
                modify.group_id = groupid;
                modify.user_id = op_user_id;
                modify.big_msg_type = big_type;
                modify.message_id = message_id;
                modify.group_manager_user_id = groupInfo->group_manager_user_id();
                modify.message_old_id = oldMsgId;
                modify.group_add_max_count = groupInfo->group_add_max_count();
                modify.group_max_count = groupInfo->group_max_count();
                
                if (groupInfo->group_name()) {
                    modify.group_name = [NSString stringWithUTF8String:groupInfo->group_name()->c_str()];
                }
                
                const T_OPERATE_GROUP_MSG *opMsg = t_offline_group_msg->operate_group_msg();
                QBGroupOperatePacket *op = [[QBGroupOperatePacket alloc] init];
                op.msg_time = opMsg->msg_time();
                if (opMsg->group_modify_content()) {
                    op.group_modify_content = [NSString stringWithUTF8String:opMsg->group_modify_content()->c_str()];
                }
                if (opMsg->user_info_list()) {
                    op.user_info_list = [NSMutableArray arrayWithCapacity:10];
                    for (flatbuffers::uoffset_t k = 0; k < opMsg->user_info_list()->size(); k++) {
                        
                        USER_BASE_INFO *info = (USER_BASE_INFO *)opMsg->user_info_list()->Get(k);
                        QBUserBaseInfo *user = [[QBUserBaseInfo alloc] init];
                        
                        NSString *name= [NSString stringWithCString:info->user_nick_name()->c_str() encoding:NSUTF8StringEncoding];
                        
                        int16_t index = info->user_group_index();
                        
                        user.user_id = info->user_id();
                        user.user_nick_name = name;
                        user.user_group_index = index;
                        
                        [op.user_info_list addObject:user];
                    }
                }
                if (opMsg->operate_user_name()) {
                    op.operate_user_name = [NSString stringWithCString:opMsg->operate_user_name()->c_str() encoding:NSUTF8StringEncoding];
                }
                if (big_type==GROUP_OFFLINE_CHAT_ENTER_AGREE) {
                    modify.group_add_is_agree = GROUP_ENTER_AGREE_USER;
                }
                if (big_type==GROUP_OFFLINE_CHAT_ENTER_DEFAULT) {
                    modify.group_add_is_agree = GROUP_ENTER_AGREE_DEFAULT;
                }
                modify.groupOperate = op;
                modify.group_count = group_count;
                
                DBLog(@"群操作离线：%d,%d,%d,%lld",group_count,groupInfo->group_max_count(),groupInfo->group_add_max_count(),groupInfo->group_manager_user_id());
                //[gcList addObject:modify];
                [[NIMGroupOperationBox sharedInstance] recvGroupModifyChangeRQWithResponse:modify];
                
            }
        }
        BOOL isSF = [getObjectFromUserDefault(KEY_Single_Offline) boolValue];
        BOOL isGF = [getObjectFromUserDefault(KEY_Group_Offline) boolValue];
        BOOL isOfflineFinish = isSF && isGF;
        [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:groupid chat_type:GROUP unread_count:gcList.count];

        [[NIMOperationBox sharedInstance] operateChatJsonMessages:gcList isRemind:isOfflineFinish];

        if (isFinish == GROUP_OFFLINE_MSG_NO_FINISH) {
            [[NIMGroupOperationBox sharedInstance] fetchGroupOffline:[NIMSysManager sharedInstance].offlinesArr];

            isempty = NO;
//            QBGroupOfflineBody *body = [[QBGroupOfflineBody alloc] initWithNextMsgId:next_message_id+1 groupid:groupid];
//            [offline.groupOfflines addObject:body];
        }else{
            if ([[NIMSysManager sharedInstance].offlinesArr containsObject:@(groupid)]) {
                [[NIMSysManager sharedInstance].offlinesArr removeObject:@(groupid)];
            }
        }
    }
    

    if (isempty)
    {
        if ([NIMSysManager sharedInstance].offlinesArr.count>0) {
            [[NIMGroupOperationBox sharedInstance] fetchGroupOffline:[NIMSysManager sharedInstance].offlinesArr];
        }else{
            //离线获取完毕
            BOOL isFinish = [getObjectFromUserDefault(KEY_Group_Offline) boolValue];
            if (!isFinish) {
                setObjectToUserDefault(KEY_Group_Offline, @(YES));
            }
            [[GroupManager sharedInstance] Clear];
        }
    }

}

/*+++++++++++++++++++++++++客户端公众号离线消息+++++++++++++++++++++++++*/
-(void)sendOffcialOfflineMessageRQ:(QBOffcialOffline *)offline
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    std::vector< flatbuffers::Offset<offcialpack::T_OFFCIAL_BASE_REQUEST> > vector_offcial_base_rq;
    for (flatbuffers::uoffset_t i = 0; i < offline.offcialOfflines.count; i++)
    {
        T_OFFCIAL_BASE_REQUESTBuilder offcialbaserequest = offcialpack::T_OFFCIAL_BASE_REQUESTBuilder(fbbuilder);
        QBOffcialOfflineBody *body = offline.offcialOfflines[i];
        offcialbaserequest.add_offcial_id(body.offcial_id);
        offcialbaserequest.add_next_message_id(body.next_message_id);
        vector_offcial_base_rq.push_back(offcialbaserequest.Finish());
    }
    
    auto vec_vector_offcial_base_a = fbbuilder.CreateVector(vector_offcial_base_rq);
    
    const commonpack::S_RQ_HEAD s_rq(offline.user_id,offline.session_id,PLATFORM_APP);
    T_CLIENT_FANS_GET_OFFLINE_MESSAGE_RQBuilder offlineMsg = T_CLIENT_FANS_GET_OFFLINE_MESSAGE_RQBuilder(fbbuilder);
    offlineMsg.add_s_rq_head(&s_rq);
    offlineMsg.add_list_offcial_offline_msg_request(vec_vector_offcial_base_a);
    fbbuilder.Finish(offlineMsg.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_FANS_GET_OFFLINE_MESSAGE_RQ buffer:buf buf_len:len];
}

-(void)recvOffcialOfflineMessageRS:(QBTransParam *)trans_param
{
    T_CLIENT_FANS_GET_OFFLINE_MESSAGE_RS *t_offline_message_rs = (offcialpack::T_CLIENT_FANS_GET_OFFLINE_MESSAGE_RS*)GetT_CLIENT_FANS_GET_OFFLINE_MESSAGE_RS(trans_param.buffer.bytes);
    if(!t_offline_message_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:t_offline_message_rs->s_rs_head()])
    {
        return;
    }

    uint64_t next_message_id = 0;
    
    const flatbuffers::Vector<flatbuffers::Offset<offcialpack::T_OFFCIAL_OFFLINE_MESSAGE>> * s_offcial_all_msg
    =  t_offline_message_rs->list_offcial_offline_msg_response();
    
    
    const flatbuffers::Vector<flatbuffers::Offset<offcialpack::T_OFFCIAL_MESSAGE>> * list_private_msg
    =  t_offline_message_rs->list_private_msg_response();
    
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    QBOffcialOffline *offline = [[QBOffcialOffline alloc] init];
    offline.offcialOfflines = [NSMutableArray arrayWithCapacity:10];
    
    if (s_offcial_all_msg == NULL) {
        return;
    }
    for (flatbuffers::uoffset_t i = 0; i < s_offcial_all_msg->size(); i++)
    {
        T_OFFCIAL_OFFLINE_MESSAGE *t_offcial_all_msg = (offcialpack::T_OFFCIAL_OFFLINE_MESSAGE *)s_offcial_all_msg->Get(i);
        int64_t offcialid = t_offcial_all_msg->offcial_id();
        
        packet.offcialid = offcialid;
        
        GROUP_OFFLINE_MSG_IS_FINISH isFinish = (GROUP_OFFLINE_MSG_IS_FINISH)t_offcial_all_msg->is_finish();
        
        const flatbuffers::Vector<flatbuffers::Offset<T_OFFLINE_MESSAGE>> * s_offcial_msg_list
        =  t_offcial_all_msg->s_msg();
        NSMutableArray *pcList = [NSMutableArray arrayWithCapacity:10];

        for (flatbuffers::uoffset_t j = 0; j < s_offcial_msg_list->size(); j++)
        {
            T_OFFLINE_MESSAGE * offline_msg = (T_OFFLINE_MESSAGE *)s_offcial_msg_list->Get(j);
            NSString *content=nil;
            int32_t m_type = 1;
            int32_t s_type = 0;
            int32_t ext_type = 0;
            int64_t msg_time = 0;
            int64_t message_id = offline_msg->message_id();
            
            setObjectToUserDefault(_IM_FormatStr(@"%@_lateid",[NIMStringComponents createMsgBodyIdWithType:PUBLIC toId:offcialid]), @(message_id));
            
            const commonpack::S_MSG* s_msg = offline_msg->s_msg();
            if(s_msg->msg_content()){
                content = [NSString stringWithCString:s_msg->msg_content()->c_str() encoding:NSUTF8StringEncoding];
            }
            msg_time = s_msg->msg_time();
            if (s_msg->send_user_name()) {
                packet.send_user_name = [NSString stringWithCString:s_msg->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
            }
            m_type = s_msg->m_type();
            s_type = s_msg->s_type();
            ext_type = s_msg->ext_type();
            packet.user_id = OWNERID;
            packet.msg_content = content;
            packet.chat_type = s_msg->chat_type();
            packet.m_type = m_type;
            packet.s_type = s_type;
            packet.ext_type = ext_type;
            packet.message_id = message_id;
            packet.msg_time = msg_time;
            packet.b_id = t_offcial_all_msg->b_id();
            packet.w_id = t_offcial_all_msg->w_id();
            packet.c_id = t_offcial_all_msg->c_id();
            NSDictionary *dict = [packet compositeWithAttributes];
            DBLog(@"公众号离线：%@",dict);
            [pcList addObject:dict];
        }
        [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:offcialid chat_type:PUBLIC unread_count:pcList.count];
        [[NIMOperationBox sharedInstance] operateChatJsonMessages:pcList isRemind:NO];

        if (isFinish == GROUP_OFFLINE_MSG_NO_FINISH) {
            QBOffcialOfflineBody *body = [[QBOffcialOfflineBody alloc] initWithNextMsgId:next_message_id offcialid:offcialid];
            [offline.offcialOfflines addObject:body];
        }
    }
    NSMutableArray *pcsList = [NSMutableArray arrayWithCapacity:10];

    for (flatbuffers::uoffset_t i = 0; i < list_private_msg->size(); i++)
    {
        T_OFFCIAL_MESSAGE *t_offline_msg = (offcialpack::T_OFFCIAL_MESSAGE *)list_private_msg->Get(i);
        
        int64_t offcialid = t_offline_msg->offcial_id();
        
        packet.offcialid = offcialid;
        
        int64_t message_id = t_offline_msg->message_id();
        
        const commonpack::S_MSG* s_msg = t_offline_msg->s_msg();
        
        NSString *content=nil;
        int32_t m_type = 1;
        int32_t s_type = 0;
        int32_t ext_type = 0;
        int64_t msg_time = 0;
        
        if(s_msg->msg_content()){
            content = [NSString stringWithCString:s_msg->msg_content()->c_str() encoding:NSUTF8StringEncoding];
        }
        msg_time = s_msg->msg_time();
        if (s_msg->send_user_name()) {
            packet.send_user_name = [NSString stringWithCString:s_msg->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
        }
        m_type = s_msg->m_type();
        s_type = s_msg->s_type();
        ext_type = s_msg->ext_type();
        packet.user_id = OWNERID;
        packet.msg_content = content;
        packet.chat_type = s_msg->chat_type();
        packet.m_type = m_type;
        packet.s_type = s_type;
        packet.ext_type = ext_type;
        packet.message_id = message_id;
        packet.msg_time = msg_time;
        packet.b_id = t_offline_msg->b_id();
        packet.w_id = t_offline_msg->w_id();
        packet.c_id = t_offline_msg->c_id();
        NSDictionary *dict = [packet compositeWithAttributes];
        DBLog(@"公众号单发离线：%@",dict);
        [pcsList addObject:dict];
        [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:offcialid chat_type:s_msg->chat_type() unread_count:1];

    }
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:pcsList isRemind:NO];

    
    GROUP_OFFLINE_MSG_IS_FINISH isAllFinish = (GROUP_OFFLINE_MSG_IS_FINISH)t_offline_message_rs->is_finish();
    if (isAllFinish == GROUP_OFFLINE_MSG_NO_FINISH) {
        offline.user_id = OWNERID;
        offline.session_id = [NIMBaseUtil getPacketSessionID];
        [self sendOffcialOfflineMessageRQ:offline];
    }
}


-(void)fetchSysOfflineMessage
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    const commonpack::S_RQ_HEAD s_rq(OWNERID,[NIMBaseUtil getPacketSessionID],PLATFORM_APP);
    T_CLIENT_FANS_GET_SYS_MSG_RQBuilder offlineMsg = T_CLIENT_FANS_GET_SYS_MSG_RQBuilder(fbbuilder);
    offlineMsg.add_s_rq_head(&s_rq);
    
    int64_t msgid = [getObjectFromUserDefault(_IM_FormatStr(@"%lld_sys_lateid",OWNERID)) longLongValue];
    offlineMsg.add_message_id(msgid);
    fbbuilder.Finish(offlineMsg.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_FANS_GET_SYS_MESSAGE_RQ buffer:buf buf_len:len];
}

-(void)recvSysOfflineMessage:(QBTransParam *)trans_param
{ 
    T_CLIENT_FANS_GET_SYS_MSG_RS *t_offline_message_rs = (offcialpack::T_CLIENT_FANS_GET_SYS_MSG_RS*)GetT_CLIENT_FANS_GET_SYS_MSG_RS(trans_param.buffer.bytes);
    if(!t_offline_message_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:t_offline_message_rs->s_rs_head()])
    {
        return;
    }

    
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];

    const flatbuffers::Vector<flatbuffers::Offset<offcialpack::T_OFFCIAL_MESSAGE>> * s_offcial_all_msg
    =  t_offline_message_rs->list_sys_msg_response();
    
    
    const flatbuffers::Vector<flatbuffers::Offset<offcialpack::T_OFFCIAL_MESSAGE>> * s_offcial_private_msg
    =  t_offline_message_rs->list_private_msg_response();
    
    NSMutableArray *spcList = [NSMutableArray arrayWithCapacity:10];
    for (flatbuffers::uoffset_t i = 0; i < s_offcial_all_msg->size(); i++)
    {
        T_OFFCIAL_MESSAGE *t_offline_msg = (offcialpack::T_OFFCIAL_MESSAGE *)s_offcial_all_msg->Get(i);
        int64_t offcialid = t_offline_msg->offcial_id();
        
        packet.offcialid = offcialid;
        
        int64_t message_id = t_offline_msg->message_id();
        
        setObjectToUserDefault(_IM_FormatStr(@"%lld_sys_lateid",OWNERID), @(message_id));
        
        const commonpack::S_MSG* s_msg = t_offline_msg->s_msg();
        
        NSString *content=nil;
        int32_t m_type = 1;
        int32_t s_type = 0;
        int32_t ext_type = 0;
        int64_t msg_time = 0;
        
        if(s_msg->msg_content()){
            content = [NSString stringWithCString:s_msg->msg_content()->c_str() encoding:NSUTF8StringEncoding];
        }
        msg_time = s_msg->msg_time();
        if (s_msg->send_user_name()) {
            packet.send_user_name = [NSString stringWithCString:s_msg->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
        }
        m_type = s_msg->m_type();
        s_type = s_msg->s_type();
        ext_type = s_msg->ext_type();
        packet.user_id = OWNERID;
        packet.msg_content = content;
        packet.chat_type = s_msg->chat_type();
        packet.m_type = m_type;
        packet.s_type = s_type;
        packet.ext_type = ext_type;
        packet.message_id = message_id;
        packet.msg_time = msg_time;
        packet.offcialid = kSystemID;
        packet.b_id = t_offline_msg->b_id();
        packet.w_id = t_offline_msg->w_id();
        packet.c_id = t_offline_msg->c_id();

        NSDictionary *dict = [packet compositeWithAttributes];
        DBLog(@"系统公众号离线：%@",dict);
        [spcList addObject:dict];
    }
    [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:kSystemID chat_type:PUBLIC unread_count:spcList.count];
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:spcList isRemind:NO];

    NSMutableArray *sspc = [NSMutableArray arrayWithCapacity:10];
    for (flatbuffers::uoffset_t i = 0; i < s_offcial_private_msg->size(); i++)
    {
        T_OFFCIAL_MESSAGE *t_offline_msg = (offcialpack::T_OFFCIAL_MESSAGE *)s_offcial_private_msg->Get(i);
        int64_t offcialid = t_offline_msg->offcial_id();
        
        packet.offcialid = offcialid;
        
        int64_t message_id = t_offline_msg->message_id();
        
        const commonpack::S_MSG* s_msg = t_offline_msg->s_msg();
        
        NSString *content=nil;
        int32_t m_type = 1;
        int32_t s_type = 0;
        int32_t ext_type = 0;
        int64_t msg_time = 0;
        
        if(s_msg->msg_content()){
            content = [NSString stringWithCString:s_msg->msg_content()->c_str() encoding:NSUTF8StringEncoding];
        }
        msg_time = s_msg->msg_time();
        if (s_msg->send_user_name()) {
            packet.send_user_name = [NSString stringWithCString:s_msg->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
        }
        m_type = s_msg->m_type();
        s_type = s_msg->s_type();
        ext_type = s_msg->ext_type();
        packet.user_id = OWNERID;
        packet.msg_content = content;
        packet.chat_type = s_msg->chat_type();
        packet.m_type = m_type;
        packet.s_type = s_type;
        packet.ext_type = ext_type;
        packet.message_id = message_id;
        packet.msg_time = msg_time;
        packet.offcialid = kSystemID;
        packet.b_id = t_offline_msg->b_id();
        packet.w_id = t_offline_msg->w_id();
        packet.c_id = t_offline_msg->c_id();

        NSDictionary *dict = [packet compositeWithAttributes];
        DBLog(@"系统公众号单发离线：%@",dict);
        [sspc addObject:dict];
        [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:offcialid chat_type:s_msg->chat_type() unread_count:1];
    }
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:sspc isRemind:NO];

    GROUP_OFFLINE_MSG_IS_FINISH isAllFinish = (GROUP_OFFLINE_MSG_IS_FINISH)t_offline_message_rs->is_finish();
    
    if (isAllFinish == GROUP_OFFLINE_MSG_NO_FINISH) {
        [self fetchSysOfflineMessage];
    }
    

    
}


/*+++++++++++++++++++++++++web端公众号离线消息+++++++++++++++++++++++++*/


-(void)sendFansOfflineMessageRQ
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    const commonpack::S_RQ_HEAD s_rq(OWNERID,[NIMBaseUtil getPacketSessionID],PLATFORM_APP);
    T_CLIENT_OFFCIAL_GET_OFFLINE_MESSAGE_RQBuilder offlineMsg = T_CLIENT_OFFCIAL_GET_OFFLINE_MESSAGE_RQBuilder(fbbuilder);
    offlineMsg.add_s_rq_head(&s_rq);
    offlineMsg.add_message_id(0);
    offlineMsg.add_offcial_id(OWNERID);
    fbbuilder.Finish(offlineMsg.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_OFFCIAL_GET_OFFLINE_MESSAGE_RQ buffer:buf buf_len:len];
}


-(void)recvFansOfflineMessageRS:(QBTransParam *)trans_param
{
    DBLog(@"NIMOfflineMessageProcessor recv offcial");
    T_CLIENT_OFFCIAL_GET_OFFLINE_MESSAGE_RS *t_offline_message_rs = (offcialpack::T_CLIENT_OFFCIAL_GET_OFFLINE_MESSAGE_RS*)GetT_CLIENT_OFFCIAL_GET_OFFLINE_MESSAGE_RS(trans_param.buffer.bytes);
    if(!t_offline_message_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:t_offline_message_rs->s_rs_head()])
    {
        return;
    }
    
    const flatbuffers::Vector<flatbuffers::Offset<offcialpack::T_FANS_OFFLINE_MESSAGE>> * s_offcial_all_msg
    =  t_offline_message_rs->list_group_offline_msg_response();
    
    DBLog(@"公众号收到离线：%d",s_offcial_all_msg->size());
    
    
    for (flatbuffers::uoffset_t i = 0; i < s_offcial_all_msg->size(); i++)
    {
        T_FANS_OFFLINE_MESSAGE * fans_msg = (T_FANS_OFFLINE_MESSAGE *)s_offcial_all_msg->Get(i);
        
        int64_t userid = fans_msg->user_id();
        int64_t msgid = fans_msg->message_id();
        int64_t offcialid = fans_msg->b_id();
        const commonpack::S_MSG *msg = fans_msg->s_msg();
        NSString *content;
        if(msg->msg_content()){
            content = [NSString stringWithCString:msg->msg_content()->c_str() encoding:NSUTF8StringEncoding];
        }
        DBLog(@"公众号收到离线%d,%lld,%@,%lld",msg->chat_type(),offcialid,content,userid);
    }
}

@end
