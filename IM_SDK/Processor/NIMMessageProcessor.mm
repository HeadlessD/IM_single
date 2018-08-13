//
//  NIMMessageProcessor.m
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMMessageProcessor.h"
#import "NIMCallBackManager.h"

#import "fb_client_send_message_rq_generated.h"
#import "fb_client_send_message_rs_generated.h"
#import "fb_group_client_send_message_rq_generated.h"
#import "fb_group_client_send_message_rs_generated.h"
//#import "fb_group_server_send_message_rq_generated.h"
#import "fb_server_send_message_rq_generated.h"
#import "fb_server_send_message_rs_generated.h"


#import "fb_client_fans_send_message_rq_generated.h"
#import "fb_client_fans_send_message_rs_generated.h"
#import "fb_server_offcial_message_rq_generated.h"
#import "fb_server_offcial_private_message_rq_generated.h"
#import "fb_server_offcial_private_message_rs_generated.h"


#import "fb_client_offcial_send_message_rq_generated.h"
#import "fb_client_offcial_send_message_rs_generated.h"
#import "fb_client_offcial_send_one_msg_rq_generated.h"
#import "fb_client_offcial_send_one_msg_rs_generated.h"
#import "fb_client_offcial_send_some_msg_rq_generated.h"
#import "fb_client_offcial_send_some_msg_rs_generated.h"
#import "fb_client_offcial_send_sys_msg_rq_generated.h"
#import "fb_client_offcial_send_sys_msg_rs_generated.h"
#import "fb_client_offcial_send_one_sys_msg_rq_generated.h"
#import "fb_client_offcial_send_one_sys_msg_rs_generated.h"
#import "fb_client_offcial_send_some_sys_msg_rq_generated.h"
#import "fb_client_offcial_send_some_sys_msg_rs_generated.h"

#import "fb_offcial_msg_generated.h"
#import "fb_server_fans_message_rq_generated.h"
#import "fb_server_fans_message_rs_generated.h"


#import "fb_group_chat_notify_rq_generated.h"
#import "NIMManager.h"
@implementation NIMMessageProcessor
using namespace commonpack;
using namespace scpack;
using namespace offcialpack;
using namespace grouppack;
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
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CHAT_CLIENT_SEND_MESSAGE_RS class_name:self func_name:@"recvSingleMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_CLIENT_SEND_MESSAGE_RS class_name:self func_name:@"recvGroupMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CHAT_SERVER_SEND_MESSAGE_RQ class_name:self func_name:@"recvServerSendSingleMessageRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_FANS_SEND_MESSAGE_RS class_name:self func_name:@"recvFansMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SERVER_OFFCIAL_MESSAGE_ID class_name:self func_name:@"recvOffcialMessageRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_GROUP_CHAT_NOTIFY_SIMPLE_RQ class_name:self func_name:@"recvGroupMessageNotify:"];
    
    
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_OFFCIAL_SEND_MESSAGE_RS class_name:self func_name:@"recvOffcialMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SERVER_FANS_MESSAGE_RQ class_name:self func_name:@"recvFansMessageRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_OFFCIAL_SEND_ONE_MESSAGE_RS class_name:self func_name:@"recvOffcialOneMessageRS:"];

    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_OFFCIAL_SEND_SOME_MESSAGE_RS class_name:self func_name:@"recvOffcialSOmeMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_OFFCIAL_SEND_SYS_MESSAGE_RS class_name:self func_name:@"recvSysMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_OFFCIAL_SEND_ONE_SYS_MESSAGE_RS class_name:self func_name:@"recvSysOneMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_OFFCIAL_SEND_SOME_SYS_MESSAGE_RS class_name:self func_name:@"recvSysSomeMessageRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SERVER_OFFCIAL_PRIVATE_MESSAGE_RQ class_name:self func_name:@"recvOffcialPrivateMessageRQ:"];

}


/*+++++++++++++++++++++++++单聊+++++++++++++++++++++++++*/
-(void)sendSingleMessageRQ:(ChatEntity *)single
{
    flatbuffers::FlatBufferBuilder builder_data;
    auto msg_content = builder_data.CreateString([single.msgContent UTF8String]);
    auto username = builder_data.CreateString([single.sendUserName UTF8String]);

    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(single.chatType);
    msg.add_m_type(single.mtype);
    msg.add_s_type(single.stype);
    msg.add_ext_type(single.ext);
    msg.add_msg_time(single.ct);
    msg.add_send_user_name(username);
    msg.add_app_id(APP_ID);
    msg.add_session_id(single.sid);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_CHAT_CLIENT_SEND_MESSAGE_RQBuilder client = T_CHAT_CLIENT_SEND_MESSAGE_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(single.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    client.add_message_id(single.messageId);
    
    client.add_s_msg(msgOffset);
    
    client.add_op_user_id(single.opUserId);
    
    client.add_b_id(single.bId);
    
    client.add_w_id(single.wId);
    
    client.add_c_id(single.cId);
    
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CHAT_CLIENT_SEND_MESSAGE_RQ buffer:buf buf_len:len];
    DBLog(@"时间：%f",[[NSDate date] timeIntervalSince1970]);
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CHAT_CLIENT_SEND_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",single.messageId]];
}

-(void)recvSingleMessageRS:(QBTransParam *)trans_param
{
    DBLog(@"时间：%f",[[NSDate date] timeIntervalSince1970]);
    T_CHAT_CLIENT_SEND_MESSAGE_RS *chat = (scpack::T_CHAT_CLIENT_SEND_MESSAGE_RS*)GetT_CHAT_CLIENT_SEND_MESSAGE_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    DBLog(@"%d",chat->s_rs_head()->result());
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    NSString *uuid = [NSString stringWithFormat:@"%lld",chat->message_id()];
    
    //发送消息状态改变通知
    [self changeMessageStatus:uuid];
    //装入模型->生成字典
    QBSingleChatPacket *packet = [[QBSingleChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.op_user_id = chat->op_user_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.isSender = YES;
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    packet.w_id = chat->w_id();
    packet.b_id = chat->b_id();
    packet.c_id = chat->c_id();
    packet.session_id = chat->s_msg()->session_id();
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"单聊信息：%@",dict);
    SSIMMessage *message = [[NIMMessageErrorManager sharedInstance] transChatEntity:chat->message_id()];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_MESSAGE object:message];
}


//服务器主动推包
-(void)recvServerSendSingleMessageRQ:(QBTransParam *)trans_param
{
    const T_CHAT_SERVER_SEND_MESSAGE_RQ *chat = GetT_CHAT_SERVER_SEND_MESSAGE_RQ(trans_param.buffer.bytes);
    //装入模型->生成字典
    QBSingleChatPacket *packet = [[QBSingleChatPacket alloc] init];
    packet.user_id = chat->s_rq_head()->user_id();
    packet.pack_id = chat->s_rq_head()->pack_session_id();
    packet.op_user_id = chat->op_user_id();
    
    FDListEntity *fdListEntity = [FDListEntity instancetypeFindFriendId:chat->op_user_id()];
    if (fdListEntity == nil && chat->b_id() == 0) {
        return;
    }
    
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.isSender = NO;
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    packet.w_id = chat->w_id();
    packet.b_id = chat->b_id();
    packet.c_id = chat->c_id();
    packet.session_id = chat->s_msg()->session_id();
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"服务器推单聊信息：%@",dict);
    [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:chat->op_user_id() chat_type:chat->s_msg()->chat_type() unread_count:1];
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:@[dict] isRemind:YES];
    [self sendServerSingleMessgeRS:chat];
}

//收到服务器的消息包进行回包
-(void)sendServerSingleMessgeRS:(const T_CHAT_SERVER_SEND_MESSAGE_RQ *)packet
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    const commonpack::S_MSG *s_msg = packet->s_msg();
    
    auto msg_content = builder_data.CreateString(s_msg->msg_content());
    auto app_id = s_msg->app_id();
    auto session_id = s_msg->session_id();
    auto chat_type = s_msg->chat_type();
    auto m_type = s_msg->m_type();
    auto s_type = s_msg->s_type();
    auto ext_type = s_msg->ext_type();
    auto msg_time = s_msg->msg_time();
    S_MSGBuilder s1 = S_MSGBuilder(builder_data);
    s1.add_msg_content(msg_content);
    s1.add_app_id(app_id);
    s1.add_session_id(session_id);
    s1.add_m_type(m_type);
    s1.add_s_type(s_type);
    s1.add_ext_type(ext_type);
    s1.add_chat_type(chat_type);
    s1.add_msg_time(msg_time);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = s1.Finish();
    
    T_CHAT_SERVER_SEND_MESSAGE_RSBuilder server = T_CHAT_SERVER_SEND_MESSAGE_RSBuilder(builder_data);
    
    const commonpack::S_RS_HEAD s_rs(packet->s_rq_head()->user_id(),packet->s_rq_head()->pack_session_id(),0,PLATFORM_APP);
    
    server.add_s_rs_head(&s_rs);
    
    server.add_message_id(packet->message_id());
    
    server.add_s_msg(msgOffset);
    
    server.add_op_user_id(packet->op_user_id());
    
    server.add_b_id(packet->b_id());
    
    server.add_w_id(packet->w_id());
    
    server.add_c_id(packet->c_id());
    
    
    builder_data.Finish(server.Finish());
    
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CHAT_SERVER_SEND_MESSAGE_RS buffer:buf buf_len:len];

}


/*+++++++++++++++++++++++++群聊+++++++++++++++++++++++++*/

-(void)sendGroupMessageRQ:(ChatEntity *)group
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    GroupList *groupList = [GroupList instancetypeFindGroupId:group.groupId];
    auto msg_content = builder_data.CreateString([group.msgContent UTF8String]);
    auto username = builder_data.CreateString([group.sendUserName UTF8String]);
    auto group_name = builder_data.CreateString([groupList.name UTF8String]);

    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(group.chatType);
    msg.add_m_type(group.mtype);
    msg.add_s_type(group.stype);
    msg.add_ext_type(group.ext);
    msg.add_msg_time(group.ct);
    msg.add_send_user_name(username);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_GROUP_CLIENT_SEND_MESSAGE_RQBuilder client = T_GROUP_CLIENT_SEND_MESSAGE_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(group.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    client.add_message_id(group.messageId);
    
    client.add_s_msg(msgOffset);
    
    client.add_group_id(group.groupId);
    
    client.add_group_name(group_name);
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_GROUP_CLIENT_SEND_MESSAGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_GROUP_CLIENT_SEND_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",group.messageId]];
}

-(void)recvGroupMessageRS:(QBTransParam *)trans_param
{
    T_GROUP_CLIENT_SEND_MESSAGE_RS *chat = (grouppack::T_GROUP_CLIENT_SEND_MESSAGE_RS*)GetT_GROUP_CLIENT_SEND_MESSAGE_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
     //发送消息状态改变通知
    NSString *uuid = [NSString stringWithFormat:@"%lld",chat->message_id()];
    [self changeMessageStatus:uuid];
    
    //装入模型->生成字典
    QBGroupChatPacket *packet = [[QBGroupChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.op_user_id = chat->s_rs_head()->user_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.group_id = chat->group_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];

    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"群聊信息：%@",dict);
    SSIMMessage *message = [[NIMMessageErrorManager sharedInstance] transChatEntity:chat->message_id()];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_MESSAGE object:message];
}

-(void)recvGroupMessageNotify:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_GROUP_CHAT_NOTIFY_RQBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
    }
    const T_GROUP_CHAT_NOTIFY_RQ *chat = GetT_GROUP_CHAT_NOTIFY_RQ(trans_param.buffer.bytes);

    int64_t groupid = chat->group_id();
    
    if (groupid==0) {
        return;
    }    
    [[NIMGroupOperationBox sharedInstance] fetchGroupOffline:@[@(groupid)]];
    
}



//服务器主动推包
/*
-(void)recvServerSendGroupMessageRQ:(QBTransParam *)trans_param
{
    
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_GROUP_SERVER_SEND_MESSAGE_RQBuffer(verifier);
    if (!is_fbs) {
        //DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
    }
    const T_GROUP_SERVER_SEND_MESSAGE_RQ *chat = GetT_GROUP_SERVER_SEND_MESSAGE_RQ(trans_param.buffer.bytes);
    //装入模型->生成字典
    QBGroupChatPacket *packet = [[QBGroupChatPacket alloc] init];
    packet.user_id = chat->s_rq_head()->user_id();
    packet.pack_id = chat->s_rq_head()->pack_session_id();
    packet.op_user_id = chat->op_user_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.group_id = chat->group_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];

    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"服务器推群聊信息：%@",dict);
    [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:chat->group_id() chat_type:chat->s_msg()->chat_type() unread_count:1];
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:@[dict] isRemind:YES];
}
*/

/*+++++++++++++++++++++++++公众号聊天+++++++++++++++++++++++++*/

-(void)sendFansMessageRQ:(ChatEntity *)offcial
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    auto msg_content = builder_data.CreateString([offcial.msgContent UTF8String]);
    auto username = builder_data.CreateString([offcial.sendUserName UTF8String]);
    
    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(offcial.chatType);
    msg.add_m_type(offcial.mtype);
    msg.add_s_type(offcial.stype);
    msg.add_ext_type(offcial.ext);
    msg.add_msg_time(offcial.ct);
    msg.add_send_user_name(username);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_CLIENT_FANS_SEND_MESSAGE_RQBuilder client = T_CLIENT_FANS_SEND_MESSAGE_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(offcial.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    client.add_message_id(offcial.messageId);
    
    client.add_s_msg(msgOffset);
    
    client.add_offcial_id(offcial.opUserId);
    
    client.add_b_id(offcial.bId);
    
    client.add_c_id(offcial.cId);
    
    client.add_w_id(offcial.wId);
    
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_FANS_SEND_MESSAGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_FANS_SEND_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",offcial.messageId]];
}

-(void)recvFansMessageRS:(QBTransParam *)trans_param
{
    T_CLIENT_FANS_SEND_MESSAGE_RS *chat = (offcialpack::T_CLIENT_FANS_SEND_MESSAGE_RS*)GetT_CLIENT_FANS_SEND_MESSAGE_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //发送消息状态改变通知
    NSString *uuid = [NSString stringWithFormat:@"%lld",chat->message_id()];
    [self changeMessageStatus:uuid];
    
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.offcialid = chat->offcial_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    packet.b_id = chat->b_id();
    packet.c_id = chat->c_id();
    packet.w_id = chat->w_id();

    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"公众号信息：%@",dict);
}


//接收公众号消息
-(void)recvOffcialMessageRQ:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_SERVER_OFFCIAL_MESSAGE_RQBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
        return;
    }
    const T_SERVER_OFFCIAL_MESSAGE_RQ *chat = GetT_SERVER_OFFCIAL_MESSAGE_RQ(trans_param.buffer.bytes);
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rq_head()->user_id();
    packet.pack_id = chat->s_rq_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.offcialid = chat->offcial_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    packet.b_id = chat->b_id();
    packet.c_id = chat->c_id();
    packet.w_id = chat->w_id();
    setObjectToUserDefault(_IM_FormatStr(@"%@_lateid",[NIMStringComponents createMsgBodyIdWithType:PUBLIC toId:chat->offcial_id()]), @(chat->message_id()));

    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"收到公众号信息：%@",dict);
    [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:chat->offcial_id() chat_type:chat->s_msg()->chat_type() unread_count:1];
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:@[dict] isRemind:NO];
}


//接收公众号单发消息
-(void)recvOffcialPrivateMessageRQ:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_SERVER_OFFCIAL_PRIVATE_MESSAGE_RQBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
        return;
    }
    const T_SERVER_OFFCIAL_PRIVATE_MESSAGE_RQ *chat = GetT_SERVER_OFFCIAL_PRIVATE_MESSAGE_RQ(trans_param.buffer.bytes);
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rq_head()->user_id();
    packet.pack_id = chat->s_rq_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.offcialid = chat->offcial_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    packet.b_id = chat->b_id();
    packet.c_id = chat->c_id();
    packet.w_id = chat->w_id();
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"收到公众号单发信息：%@",dict);
    [self sendOffcialPrivateMessageRS:chat];
    [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:chat->offcial_id() chat_type:chat->s_msg()->chat_type() unread_count:1];
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:@[dict] isRemind:NO];
}

//收到公众号单发消息后回执
-(void)sendOffcialPrivateMessageRS:(const T_SERVER_OFFCIAL_PRIVATE_MESSAGE_RQ *)chat
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    const commonpack::S_MSG *s_msg = chat->s_msg();
    
    auto msg_content = builder_data.CreateString(s_msg->msg_content());
    auto app_id = s_msg->app_id();
    auto session_id = s_msg->session_id();
    auto chat_type = s_msg->chat_type();
    auto m_type = s_msg->m_type();
    auto s_type = s_msg->s_type();
    auto ext_type = s_msg->ext_type();
    auto msg_time = s_msg->msg_time();
    S_MSGBuilder s1 = S_MSGBuilder(builder_data);
    s1.add_msg_content(msg_content);
    s1.add_app_id(app_id);
    s1.add_session_id(session_id);
    s1.add_m_type(m_type);
    s1.add_s_type(s_type);
    s1.add_ext_type(ext_type);
    s1.add_chat_type(chat_type);
    s1.add_msg_time(msg_time);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = s1.Finish();
    
    T_SERVER_OFFCIAL_PRIVATE_MESSAGE_RSBuilder server = T_SERVER_OFFCIAL_PRIVATE_MESSAGE_RSBuilder(builder_data);
    
    const commonpack::S_RS_HEAD s_rs(chat->s_rq_head()->user_id(),chat->s_rq_head()->pack_session_id(),0,PLATFORM_APP);
    
    server.add_s_rs_head(&s_rs);
    
    server.add_message_id(chat->message_id());
    
    server.add_s_msg(msgOffset);
    
    server.add_offcial_id(chat->offcial_id());
    
    server.add_w_id(chat->w_id());
    
    server.add_b_id(chat->b_id());

    server.add_c_id(chat->c_id());

    builder_data.Finish(server.Finish());
    
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_SERVER_OFFCIAL_PRIVATE_MESSAGE_RS buffer:buf buf_len:len];
}




/*+++++++++++++++++++++++++公众号聊天web端+++++++++++++++++++++++++*/

-(void)offcialSendMessageRQ:(ChatEntity *)offcial
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    auto msg_content = builder_data.CreateString([offcial.msgContent UTF8String]);
    auto username = builder_data.CreateString([offcial.sendUserName UTF8String]);
    
    std::vector<uint64_t> fansid_list;
    for (int i=0; i<1; i++) {
        fansid_list.push_back(5522532);
        fansid_list.push_back(5435124);
        fansid_list.push_back(5504157);
    }
    auto list = builder_data.CreateVector(fansid_list);
    
    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(offcial.chatType);
    msg.add_m_type(offcial.mtype);
    msg.add_s_type(offcial.stype);
    msg.add_ext_type(offcial.ext);
    msg.add_msg_time(offcial.ct);
    msg.add_send_user_name(username);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_CLIENT_OFFCIAL_SEND_MESSAGE_RQBuilder client = T_CLIENT_OFFCIAL_SEND_MESSAGE_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(offcial.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    client.add_message_id(0);
    
    client.add_s_msg(msgOffset);
    
    client.add_offcial_id(5504128);
    
    client.add_to_user_lst(list);
    
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_OFFCIAL_SEND_MESSAGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_OFFCIAL_SEND_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",offcial.messageId]];
}

-(void)recvOffcialMessageRS:(QBTransParam *)trans_param
{
    T_CLIENT_OFFCIAL_SEND_MESSAGE_RS *chat = (offcialpack::T_CLIENT_OFFCIAL_SEND_MESSAGE_RS*)GetT_CLIENT_OFFCIAL_SEND_MESSAGE_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //发送消息状态改变通知
    NSString *uuid = [NSString stringWithFormat:@"%lld",chat->message_id()];
    [self changeMessageStatus:uuid];
    
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.offcialid = chat->offcial_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"公众号主动信息：%@",dict);
}






-(void)offcialSendOneMessageRQ:(ChatEntity *)offcial
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    auto msg_content = builder_data.CreateString([offcial.msgContent UTF8String]);
    auto username = builder_data.CreateString([offcial.sendUserName UTF8String]);
    
    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(offcial.chatType);
    msg.add_m_type(offcial.mtype);
    msg.add_s_type(offcial.stype);
    msg.add_ext_type(offcial.ext);
    msg.add_msg_time(offcial.ct);
    msg.add_send_user_name(username);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_CLIENT_OFFCIAL_SEND_ONE_MSG_RQBuilder client = T_CLIENT_OFFCIAL_SEND_ONE_MSG_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(offcial.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    client.add_message_id(0);
    
    client.add_s_msg(msgOffset);
    
    client.add_offcial_id(5504128);
    
    client.add_fans_id(5504157);
    
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_OFFCIAL_SEND_ONE_MESSAGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_OFFCIAL_SEND_ONE_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",offcial.messageId]];
}

-(void)recvOffcialOneMessageRS:(QBTransParam *)trans_param
{
    T_CLIENT_OFFCIAL_SEND_ONE_MSG_RS *chat = (offcialpack::T_CLIENT_OFFCIAL_SEND_ONE_MSG_RS*)GetT_CLIENT_OFFCIAL_SEND_ONE_MSG_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //发送消息状态改变通知
    NSString *uuid = [NSString stringWithFormat:@"%lld",chat->message_id()];
    [self changeMessageStatus:uuid];
    
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.offcialid = chat->offcial_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"公众号单发信息：%@",dict);
}


-(void)offcialSendSomeMessageRQ:(ChatEntity *)offcial
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    auto msg_content = builder_data.CreateString([offcial.msgContent UTF8String]);
    auto username = builder_data.CreateString([offcial.sendUserName UTF8String]);
    std::vector<uint64_t> fansid_list;
    for (int i=0; i<1; i++) {
        fansid_list.push_back(5522532);
        fansid_list.push_back(5504157);
    }
    auto list = builder_data.CreateVector(fansid_list);
    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(offcial.chatType);
    msg.add_m_type(offcial.mtype);
    msg.add_s_type(offcial.stype);
    msg.add_ext_type(offcial.ext);
    msg.add_msg_time(offcial.ct);
    msg.add_send_user_name(username);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_CLIENT_OFFCIAL_SEND_SOME_MSG_RQBuilder client = T_CLIENT_OFFCIAL_SEND_SOME_MSG_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(offcial.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    client.add_message_id(0);
    
    client.add_s_msg(msgOffset);
    
    client.add_offcial_id(5504128);
    
    client.add_to_fans_lst(list);
    
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_OFFCIAL_SEND_SOME_MESSAGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_OFFCIAL_SEND_SOME_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",offcial.messageId]];
}


-(void)recvOffcialSOmeMessageRS:(QBTransParam *)trans_param
{
    T_CLIENT_OFFCIAL_SEND_SOME_MSG_RS *chat = (offcialpack::T_CLIENT_OFFCIAL_SEND_SOME_MSG_RS*)GetT_CLIENT_OFFCIAL_SEND_SOME_MSG_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //发送消息状态改变通知
    NSString *uuid = [NSString stringWithFormat:@"%lld",chat->message_id()];
    [self changeMessageStatus:uuid];
    
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.offcialid = chat->offcial_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"公众号群发信息：%@",dict);
}

//接收粉丝消息
-(void)recvFansMessageRQ:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_SERVER_FANS_MESSAGE_RQBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
        return;
    }
    const T_SERVER_FANS_MESSAGE_RQ *chat = GetT_SERVER_FANS_MESSAGE_RQ(trans_param.buffer.bytes);
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rq_head()->user_id();
    packet.pack_id = chat->s_rq_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.offcialid = chat->fans_id();
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"收到粉丝信息：%@",dict);
    [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:chat->offcial_id() chat_type:chat->s_msg()->chat_type() unread_count:1];
    [[NIMOperationBox sharedInstance] operateChatJsonMessages:@[dict] isRemind:NO];
}



/*+++++++++++++++++++++++++系统公众号聊天web端+++++++++++++++++++++++++*/
-(void)sysSendMessageRQ:(ChatEntity *)offcial
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    auto msg_content = builder_data.CreateString([offcial.msgContent UTF8String]);
    auto username = builder_data.CreateString([offcial.sendUserName UTF8String]);
    
    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(offcial.chatType);
    msg.add_m_type(offcial.mtype);
    msg.add_s_type(offcial.stype);
    msg.add_ext_type(offcial.ext);
    msg.add_msg_time(offcial.ct);
    msg.add_send_user_name(username);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_CLIENT_OFFCIAL_SEND_SYS_MSG_RQBuilder client = T_CLIENT_OFFCIAL_SEND_SYS_MSG_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(offcial.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    
    client.add_s_msg(msgOffset);
    
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_OFFCIAL_SEND_SYS_MESSAGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_OFFCIAL_SEND_SYS_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",offcial.messageId]];
}

-(void)recvSysMessageRS:(QBTransParam *)trans_param
{
    T_CLIENT_OFFCIAL_SEND_SYS_MSG_RS *chat = (offcialpack::T_CLIENT_OFFCIAL_SEND_SYS_MSG_RS*)GetT_CLIENT_OFFCIAL_SEND_SYS_MSG_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = [NIMBaseUtil GetServerTime];
    packet.offcialid = 1000;
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"系统公众号主动信息：%@",dict);
}



-(void)sysSendOneMessageRQ:(ChatEntity *)offcial
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    auto msg_content = builder_data.CreateString([offcial.msgContent UTF8String]);
    auto username = builder_data.CreateString([offcial.sendUserName UTF8String]);
    
    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(offcial.chatType);
    msg.add_m_type(offcial.mtype);
    msg.add_s_type(offcial.stype);
    msg.add_ext_type(offcial.ext);
    msg.add_msg_time(offcial.ct);
    msg.add_send_user_name(username);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_CLIENT_OFFCIAL_SEND_ONE_SYS_MSG_RQBuilder client = T_CLIENT_OFFCIAL_SEND_ONE_SYS_MSG_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(offcial.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    client.add_s_msg(msgOffset);
    
    client.add_fans_id(5504157);
    
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_OFFCIAL_SEND_ONE_SYS_MESSAGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_OFFCIAL_SEND_ONE_SYS_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",offcial.messageId]];
}

-(void)recvSysOneMessageRS:(QBTransParam *)trans_param
{
    T_CLIENT_OFFCIAL_SEND_ONE_SYS_MSG_RS *chat = (offcialpack::T_CLIENT_OFFCIAL_SEND_ONE_SYS_MSG_RS*)GetT_CLIENT_OFFCIAL_SEND_ONE_SYS_MSG_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = [NIMBaseUtil GetServerTime];
    packet.offcialid = kSystemID;
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"系统公众号单发信息：%@",dict);
}


-(void)sysSendSomeMessageRQ:(ChatEntity *)offcial
{
    flatbuffers::FlatBufferBuilder builder_data;
    
    auto msg_content = builder_data.CreateString([offcial.msgContent UTF8String]);
    auto username = builder_data.CreateString([offcial.sendUserName UTF8String]);
    std::vector<uint64_t> fansid_list;
    for (int i=0; i<1; i++) {
        fansid_list.push_back(5522532);
        fansid_list.push_back(5435124);
        fansid_list.push_back(5435133);
        fansid_list.push_back(5504157);
    }
    auto list = builder_data.CreateVector(fansid_list);
    S_MSGBuilder msg = S_MSGBuilder(builder_data);
    msg.add_msg_content(msg_content);
    msg.add_chat_type(offcial.chatType);
    msg.add_m_type(offcial.mtype);
    msg.add_s_type(offcial.stype);
    msg.add_ext_type(offcial.ext);
    msg.add_msg_time(offcial.ct);
    msg.add_send_user_name(username);
    flatbuffers::Offset<commonpack::S_MSG> msgOffset = msg.Finish();
    
    
    T_CLIENT_OFFCIAL_SEND_SOME_SYS_MSG_RQBuilder client = T_CLIENT_OFFCIAL_SEND_SOME_SYS_MSG_RQBuilder(builder_data);
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    S_RQ_HEAD s_rq(offcial.userId,packetID,PLATFORM_APP);
    
    client.add_s_rq_head(&s_rq);
    
    client.add_message_id(0);
    
    client.add_s_msg(msgOffset);
    
    client.add_to_fans_lst(list);
    
    builder_data.Finish(client.Finish());
    BYTE*	buf = builder_data.GetBufferPointer();
    WORD	len = (WORD)builder_data.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_OFFCIAL_SEND_SOME_SYS_MESSAGE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_OFFCIAL_SEND_SOME_SYS_MESSAGE_RQ buffer:buf buf_len:len packID:packetID msgId:[NSString stringWithFormat:@"%lld",offcial.messageId]];
}


-(void)recvSysSomeMessageRS:(QBTransParam *)trans_param
{
    T_CLIENT_OFFCIAL_SEND_SOME_SYS_MSG_RS *chat = (offcialpack::T_CLIENT_OFFCIAL_SEND_SOME_SYS_MSG_RS*)GetT_CLIENT_OFFCIAL_SEND_SOME_SYS_MSG_RS(trans_param.buffer.bytes);
    if(!chat)
    {
        return;
    }
    //检查头
    if(![super checkHead:chat->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = chat->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    //发送消息状态改变通知
    NSString *uuid = [NSString stringWithFormat:@"%lld",chat->message_id()];
    [self changeMessageStatus:uuid];
    
    //装入模型->生成字典
    QBOffcialChatPacket *packet = [[QBOffcialChatPacket alloc] init];
    packet.user_id = chat->s_rs_head()->user_id();
    packet.pack_id = chat->s_rs_head()->pack_session_id();
    packet.msg_content = [NSString stringWithCString:chat->s_msg()->msg_content()->c_str() encoding:NSUTF8StringEncoding];
    packet.chat_type = chat->s_msg()->chat_type();;
    packet.m_type = chat->s_msg()->m_type();
    packet.s_type = chat->s_msg()->s_type();
    packet.ext_type = chat->s_msg()->ext_type();
    packet.message_id = chat->message_id();
    packet.offcialid = 1000;
    packet.msg_time = chat->s_msg()->msg_time();
    packet.send_user_name = [NSString stringWithCString:chat->s_msg()->send_user_name()->c_str() encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [packet compositeWithAttributes];
    DBLog(@"系统公众号群发信息：%@",dict);
}



//改变消息状态
-(void)changeMessageStatus:(NSString *)msgId
{
    ChatEntity *chatEntity = [ChatEntity findFirstWithMessageId:msgId.longLongValue];
    chatEntity.status = QIMMessageStatuNormal;
    [[NIMMessageManager sharedInstance] updateMessage:chatEntity isPost:YES isChange:NO];
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_MESSAGE_STATUS object:msgId];
}


@end
