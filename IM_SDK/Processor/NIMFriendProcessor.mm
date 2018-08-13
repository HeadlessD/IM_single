//
//  NIMFriendProcessor.m
//  qbim
//
//  Created by 豆凯强 on 17/3/23.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMFriendProcessor.h"
#import "NIMCallBackManager.h"

#import "NIMGlobalProcessor.h"

#import "fb_friend_client_add_confirm_rq_generated.h"
#import "fb_friend_client_add_confirm_rs_generated.h"
#import "fb_friend_client_add_rq_generated.h"
#import "fb_friend_client_add_rs_generated.h"

#import "fb_friend_del_rq_generated.h"
#import "fb_friend_del_rs_generated.h"
#import "fb_friend_info_generated.h"

#import "fb_friend_list_rq_generated.h"
#import "fb_friend_list_rs_generated.h"
#import "fb_friend_remark_rq_generated.h"
#import "fb_friend_remark_rs_generated.h"
#import "fb_friend_server_add_confirm_rq_generated.h"
#import "fb_friend_server_add_confirm_rs_generated.h"
#import "fb_friend_server_add_rq_generated.h"
#import "fb_friend_server_add_rs_generated.h"
#import "fb_friend_server_del_rq_generated.h"
#import "fb_friend_server_del_rs_generated.h"

#import "fb_friend_update_rq_generated.h"
#import "fb_friend_update_rs_generated.h"
#import "fb_friend_client_blacklist_rq_generated.h"
#import "fb_friend_client_blacklist_rs_generated.h"
#import "fb_friend_server_blacklist_rq_generated.h"


#import "fb_friend_server_restor_rq_generated.h"

@implementation NIMFriendProcessor

using namespace friendpack;

- (id)init
{
    self = [super init];
    [self initCallBack];
    _fdListMaxcnt = 10;
    _fdListOffset = 0;
    return self;
}

- (void)dealloc
{
    
}

-(void)initCallBack
{
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_FRIEND_ADD_RS class_name:self func_name:@"recvFriendAddRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SERVER_FRIEND_ADD_RQ class_name:self func_name:@"recvServerAddRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_FRIEND_DEL_RS class_name:self func_name:@"recvFriendDelRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SERVER_FRIEND_DEL_RQ class_name:self func_name:@"recvServerDelRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_FRIEND_LIST_RS class_name:self func_name:@"recvFriendListRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_FRIEND_REMARK_RS class_name:self func_name:@"recvFriendRemarkRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLINET_FRIEND_CONFIRM_RS class_name:self func_name:@"recvFriendConRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SERVER_FRIEND_CONFIRM_RQ class_name:self func_name:@"recvServerAddConRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_CLIENT_FRIEND_BLACKLIST_RS class_name:self func_name:@"recvBlackListRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SERVER_FRIEND_BLACKLIST_RQ class_name:self func_name:@"recvServerBlackRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_FRIEND_UPDATE_RS class_name:self func_name:@"recvDelUpdateFriendRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_FRIEND_RESTORE_RQ class_name:self func_name:@"recvServerRestorRQ:"];
}

#pragma mark 发送好友请求
-(void)sendFriendAddRQ:(int64)peer_id opMsg:(NSString *)opMsg sourceType:(int64)sourceType
{
    VcardEntity * ownVcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userid=%lld",OWNERID]];
    
    NSString * ownstring = nil;
    if (!IsStrEmpty(ownVcard.nickName)) {
        ownstring = ownVcard.nickName;
    }else if (!IsStrEmpty(ownVcard.userName)) {
        ownstring = ownVcard.userName;
    }else{
        ownstring =[NSString stringWithFormat:@"%lld",ownVcard.userid];
    }
    
    NSString * addMessage = nil;
    if (opMsg.length <= 0) {
        addMessage = [NSString stringWithFormat:@"%@请求添加你为好友",ownstring];
    }else if ([opMsg isEqualToString:@"我是"]){
        addMessage = [NSString stringWithFormat:@"我是%@",ownstring];
    }else{
        addMessage = opMsg;
    }
    
    flatbuffers::FlatBufferBuilder faBuilder;
    auto op_msg = faBuilder.CreateString([addMessage UTF8String]);
    auto nickName = faBuilder.CreateString([ownstring UTF8String]);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    friendpack::T_FRIEND_CLIENT_ADD_RQBuilder friendAdd_rq = T_FRIEND_CLIENT_ADD_RQBuilder(faBuilder);
    
    friendAdd_rq.add_s_rq_head(&s_rq);
    friendAdd_rq.add_op_msg(op_msg);
    friendAdd_rq.add_peer_user_id(peer_id);
    friendAdd_rq.add_source_type(sourceType);
    friendAdd_rq.add_own_nickname(nickName);
    flatbuffers::Offset<T_FRIEND_CLIENT_ADD_RQ> offset_rq = friendAdd_rq.Finish();
    faBuilder.Finish(offset_rq);
    BYTE*	buf = faBuilder.GetBufferPointer();
    WORD	len = (WORD)faBuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_FRIEND_ADD_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_FRIEND_ADD_RQ buffer:buf buf_len:len packID:packetID msgId:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}

-(void)recvFriendAddRS:(QBTransParam *)trans_param{
    
    T_FRIEND_CLIENT_ADD_RS *t_add_rs = (friendpack::T_FRIEND_CLIENT_ADD_RS*)GetT_FRIEND_CLIENT_ADD_RS(trans_param.buffer.bytes);
    
    if((int64)(t_add_rs->s_rs_head()->result()) == 603979789){
        DBLog(@"恢复被删除好友");
    }else if(!t_add_rs || ![super checkHead:t_add_rs->s_rs_head()]){
        return;
    }
    //todo 删除pack_session_id
    int pack_id = t_add_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];

    NIMFriendPacket * fdPack = [[NIMFriendPacket alloc]init];
    
    if((int64)(t_add_rs->s_rs_head()->result()) == 603979789){
        fdPack.isComeBackFriend = YES;
    }
    fdPack.peer_user_id = t_add_rs->peer_user_id();
    fdPack.op_msg = [NSString stringWithCString:t_add_rs->op_msg()->c_str() encoding:NSUTF8StringEncoding];

    fdPack.addToken = [NSString stringWithFormat:@"%llu",t_add_rs->token()];
    [[NIMFriendManager sharedInstance] recvFriendAddRS:fdPack];
}

#pragma mark 收到好友请求
-(void)recvServerAddRQ:(QBTransParam *)trans_param{
    const T_FRIEND_SERVER_ADD_RQ * t_friendAdd_rq = GetT_FRIEND_SERVER_ADD_RQ(trans_param.buffer.bytes);
    
    NIMFriendPacket * sAdd = [[NIMFriendPacket alloc]init];
//    t_friendAdd_rq->s_rq_he
    sAdd.peer_user_id = t_friendAdd_rq->peer_user_id();
    sAdd.sourcetype = t_friendAdd_rq->source_type();
    sAdd.addToken = [NSString stringWithFormat:@"%lld",t_friendAdd_rq->token()];
    sAdd.op_msg = [NSString stringWithCString:t_friendAdd_rq->op_msg()->c_str() encoding:NSUTF8StringEncoding];
    sAdd.peer_user_name = [NSString stringWithCString:t_friendAdd_rq->peer_user_name()->c_str() encoding:NSUTF8StringEncoding];
    
    [[NIMFriendManager sharedInstance] recvServerAddRQ:sAdd];
}

#pragma mark 删除好友
-(void)sendFriendDelRQ:(int64)user_id
{
    VcardEntity * ownVcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userid=%lld",OWNERID]];
    flatbuffers::FlatBufferBuilder fdBuilder;
    
    auto nickName = fdBuilder.CreateString([ownVcard.nickName UTF8String]);
    friendpack::T_FRIEND_DEL_RQBuilder friendDel_rq = T_FRIEND_DEL_RQBuilder(fdBuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    friendDel_rq.add_s_rq_head(&s_rq);
    friendDel_rq.add_peer_user_id(user_id);
    friendDel_rq.add_own_nickname(nickName);
    flatbuffers::Offset<T_FRIEND_DEL_RQ> offset_rq = friendDel_rq.Finish();
    fdBuilder.Finish(offset_rq);
    BYTE*	buf = fdBuilder.GetBufferPointer();
    WORD	len = (WORD)fdBuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_FRIEND_DEL_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_FRIEND_DEL_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}
-(void)recvFriendDelRS:(QBTransParam *)trans_param
{
    T_FRIEND_DEL_RS * t_del_rs = (friendpack::T_FRIEND_DEL_RS*) GetT_FRIEND_DEL_RS(trans_param.buffer.bytes);
    
    //检查头
    if(!t_del_rs || ![super checkHead:t_del_rs->s_rs_head()]){
        return;
    }
    
      //todo 删除pack_session_id
    int pack_id = t_del_rs->s_rs_head()->pack_session_id();
    
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    NIMFriendPacket * fdPack = [[NIMFriendPacket alloc]init];
    fdPack.peer_user_id =  t_del_rs->peer_user_id();
    fdPack.addToken = [NSString stringWithFormat:@"%llu",t_del_rs->token()];
    [[NIMFriendManager sharedInstance] recvFriendDelRS:fdPack];
}
#pragma mark 收到删除好友
-(void)recvServerDelRQ:(QBTransParam *)trans_param{
    
    const T_FRIEND_SERVER_DEL_RQ * t_friendAdd_rq = GetT_FRIEND_SERVER_DEL_RQ(trans_param.buffer.bytes);
    
    NIMFriendPacket * fdPack = [[NIMFriendPacket alloc]init];
    fdPack.peer_user_id = t_friendAdd_rq->peer_user_id();
    fdPack.addToken = [NSString stringWithFormat:@"%llu",t_friendAdd_rq->token()];
    fdPack.peer_nick_name = [NSString stringWithCString:t_friendAdd_rq->peer_nickname()->c_str() encoding:NSUTF8StringEncoding];

    [[NIMFriendManager sharedInstance] recvServerDelRQ:fdPack];
}

#pragma mark 好友列表获取
-(void)sendFriendListRQ:(int64)user_id withToken:(int64)userToken{
    
    flatbuffers::FlatBufferBuilder flBuilder;
    T_FRIEND_LIST_RQBuilder friend_rq = T_FRIEND_LIST_RQBuilder(flBuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(user_id,packetID,PLATFORM_APP);
    friend_rq.add_s_rq_head(&s_rq);
    friend_rq.add_offset(_fdListOffset);
    friend_rq.add_token(userToken);
    flatbuffers::Offset<T_FRIEND_LIST_RQ> offset_rq = friend_rq.Finish();
    flBuilder.Finish(offset_rq);
    BYTE*	buf = flBuilder.GetBufferPointer();
    WORD	len = (WORD)flBuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_FRIEND_LIST_RQ buffer:buf buf_len:len];
   
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_FRIEND_LIST_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvFriendListRS:(QBTransParam *)trans_param{
    
    T_FRIEND_LIST_RS *t_friendList_rs = (friendpack::T_FRIEND_LIST_RS*)GetT_FRIEND_LIST_RS(trans_param.buffer.bytes);
    
    //检查头
    if (!t_friendList_rs || ![super checkHead:t_friendList_rs->s_rs_head()]) {
        return;
    }
    DBLog(@"list_token%llu",t_friendList_rs->token());
   
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//
//    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:t_friendList_rs->token()];
//    NSString *datestr2 = [formatter stringFromDate:date2];
//    DBLog(@"%@",datestr2);

    //删除pack_session_id
    int pack_id = t_friendList_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    const flatbuffers::Vector<flatbuffers::Offset<friendpack::T_FREIND_INFO>> *friend_list = t_friendList_rs->friend_list();
    NIMFriendPacket * fdPack = [[NIMFriendPacket alloc]init];
    fdPack.user_id = OWNERID;
    fdPack.addToken = [NSString stringWithFormat:@"%lld",t_friendList_rs->token()];
    if (t_friendList_rs->msg_source() == 0) {
        fdPack.msgsource = 2;
    }else{
        fdPack.msgsource = 1;
    }

    fdPack.friendInfoArr = [NSMutableArray array];
    
    for (flatbuffers::uoffset_t i = 0; i < friend_list->size(); i++){
        T_FREIND_INFO * t_friendInfo = (T_FREIND_INFO* )friend_list->Get(i);
        QBFriendInfoPacket * fdInfoPack = [[QBFriendInfoPacket alloc]init];
        fdInfoPack.user_id = t_friendInfo->user_id();
        fdInfoPack.sourcetype = t_friendInfo->source_type();
        DBLog(@"optime————%lld",t_friendInfo->op_time());
        NSString * remarkStr = [NSString stringWithCString:t_friendInfo->remark_name()->c_str() encoding:NSUTF8StringEncoding];
        
        if (!IsStrEmpty(remarkStr)) {
            if (remarkStr.length > 0 ) {
                fdInfoPack.remark_name = [NSString stringWithCString:t_friendInfo->remark_name()->c_str() encoding:NSUTF8StringEncoding];
            }
        }
        fdInfoPack.opttype = t_friendInfo->opt_type();
        fdInfoPack.blacktype = t_friendInfo->black_type();
        fdInfoPack.optime = t_friendInfo->op_time();
        if (t_friendList_rs->msg_source() == 0) {
            fdInfoPack.msgsource = 2;
        }else{
            fdInfoPack.msgsource = 1;
        }
        if (t_friendInfo->op_msg()) {
            fdInfoPack.op_msg = [NSString stringWithCString:t_friendInfo->op_msg()->c_str() encoding:NSUTF8StringEncoding];
        }
        
        DBLog(@"token：%lld",t_friendList_rs->token());

        if (t_friendList_rs->token()) {
            fdInfoPack.fdOPToken = [NSString stringWithFormat:@"%lld",t_friendList_rs->token()];
            DBLog(@"token：%@",fdInfoPack.fdOPToken);
        }
        DBLog(@"好友ID：%lld 好友type:%d",fdInfoPack.user_id,t_friendInfo->opt_type());
        [fdPack.friendInfoArr addObject:fdInfoPack];
    }
    NSLog(@"%lld返回_token:%@",OWNERID,fdPack.addToken);

    if ((friend_list->size() == 0)) {
        DBLog(@"该用户没有好友了！");
        QBSingleOffline *singleOffline = [[QBSingleOffline alloc] init];
        singleOffline.user_id = OWNERID;
        singleOffline.session_id = [NIMBaseUtil getPacketSessionID];
        singleOffline.next_message_id = 0;
        [[NIMGlobalProcessor sharedInstance].offline_msg_processor sendSingleOfflineMessageRQ:singleOffline];
    }else{
        [[NIMGlobalProcessor sharedInstance].user_processor sendUserInfoListRQ:fdPack.friendInfoArr phone:nil];
        if (friend_list->size() == 50) {
            _fdListOffset += 50;
            NSLog(@"%lld拉取好友_token:%@",OWNERID,fdPack.addToken);
            [[NIMGlobalProcessor sharedInstance].NIMFriendProcessor sendFriendListRQ:OWNERID withToken:[fdPack.addToken integerValue]];
        } else {
            DBLog(@"该用户没有好友了！");
            QBSingleOffline *singleOffline = [[QBSingleOffline alloc] init];
            singleOffline.user_id = OWNERID;
            singleOffline.session_id = [NIMBaseUtil getPacketSessionID];
            singleOffline.next_message_id = 0;
            [[NIMGlobalProcessor sharedInstance].offline_msg_processor sendSingleOfflineMessageRQ:singleOffline];
        }
        [[NIMFriendManager sharedInstance] recvFriendListRS:fdPack];
    }
    //存储本地token
    NSLog(@"%lld存储_token:%@",OWNERID,fdPack.addToken);
    [[NSUserDefaults standardUserDefaults] setObject:fdPack.addToken forKey:[NSString stringWithFormat:@"IM_FDListToken_%lld",OWNERID]];
}

#pragma mark 好友备注
-(void)sendFriendRemarkRQ:(int64)user_id remarkName:(NSString *)remarkName{
    
    flatbuffers::FlatBufferBuilder frBuilder;
    auto reName = frBuilder.CreateSharedString([remarkName UTF8String]);
    T_FRIEND_REMARK_RQBuilder friend_rq = T_FRIEND_REMARK_RQBuilder(frBuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    friend_rq.add_s_rq_head(&s_rq);
    friend_rq.add_peer_remark_name(reName);
    friend_rq.add_peer_user_id(user_id);
    flatbuffers::Offset<T_FRIEND_REMARK_RQ> offset_fr = friend_rq.Finish();
    frBuilder.Finish(offset_fr);
    BYTE*	buf = frBuilder.GetBufferPointer();
    WORD	len = (WORD)frBuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_FRIEND_REMARK_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_FRIEND_REMARK_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvFriendRemarkRS:(QBTransParam *)trans_param
{
    T_FRIEND_REMARK_RS *t_friendRemark_rs = (friendpack::T_FRIEND_REMARK_RS *)GetT_FRIEND_REMARK_RS(trans_param.buffer.bytes);
    //检查头
    if ((!t_friendRemark_rs || ![super checkHead:t_friendRemark_rs->s_rs_head()])) {
        return;
    }
    //删除pack_session_id
    int pack_id = t_friendRemark_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    NIMFriendPacket * fdPack = [[NIMFriendPacket alloc]init];
    fdPack.peer_user_id = t_friendRemark_rs->peer_user_id();
    fdPack.addToken = [NSString stringWithFormat:@"%llu",t_friendRemark_rs->token()];

    fdPack.peer_remark_name = [NSString stringWithCString:t_friendRemark_rs->peer_remark_name()->c_str() encoding:NSUTF8StringEncoding];
    [[NIMFriendManager sharedInstance] recvFriendRemarkRS:fdPack];
}

#pragma mark 发送好友请求确认结果
-(void)sendFriendConRQ:(int64)peer_id result:(int)result
{
    VcardEntity * ownVcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userid=%lld",OWNERID]];
    FDListEntity * fdlist = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld ",OWNERID,peer_id]];
    
    flatbuffers::FlatBufferBuilder faBuilder;
    auto ownNickName = faBuilder.CreateString([ownVcard.nickName UTF8String]);
    auto peerRemark = faBuilder.CreateString([@"" UTF8String]);
    auto peerAddToken = [fdlist.addToken intValue];
    friendpack::T_FRIEND_CLIENT_CONFIRM_RQBuilder friendAdd_rq = T_FRIEND_CLIENT_CONFIRM_RQBuilder(faBuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    friendAdd_rq.add_s_rq_head(&s_rq);
    friendAdd_rq.add_peer_user_id(peer_id);
    friendAdd_rq.add_peer_remark(peerRemark);
    friendAdd_rq.add_source_type(4);
    friendAdd_rq.add_result(result);
    friendAdd_rq.add_own_nickname(ownNickName);
    friendAdd_rq.add_token(peerAddToken);
    flatbuffers::Offset<T_FRIEND_CLIENT_CONFIRM_RQ> offset_rq = friendAdd_rq.Finish();
    faBuilder.Finish(offset_rq);
    BYTE*	buf = faBuilder.GetBufferPointer();
    WORD	len = (WORD)faBuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_FRIEND_CONFIRM_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_FRIEND_CONFIRM_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvFriendConRS:(QBTransParam *)trans_param
{
    T_FRIEND_CLIENT_CONFIRM_RS * t_add_rs = (friendpack::T_FRIEND_CLIENT_CONFIRM_RS*)GetT_FRIEND_CLIENT_CONFIRM_RS(trans_param.buffer.bytes);
    //检查头
    
    if((int64)(t_add_rs->s_rs_head()->result()) == 603979782){
        DBLog(@"已经超时了");
        [super checkHead:t_add_rs->s_rs_head()];
    }else if(!t_add_rs || ![super checkHead:t_add_rs->s_rs_head()]){
        return;
    }
    
    DBLog(@"返回token%llu",t_add_rs->token());

    //todo 删除pack_session_id
    int pack_id = t_add_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    NIMFriendPacket * fdPack = [[NIMFriendPacket alloc]init];
    
    //请求已经过期了
    if((int64)(t_add_rs->s_rs_head()->result()) == 603979782){
        fdPack.opttype = FD_OUTLAST;
    }
    fdPack.peer_user_id = t_add_rs->peer_user_id();
    fdPack.addToken = [NSString stringWithFormat:@"%llu",t_add_rs->token()];
    [[NIMFriendManager sharedInstance] recvFriendConRS:fdPack];
}

#pragma mark 收到好友确认结果
-(void)recvServerAddConRQ:(QBTransParam *)trans_param{
    const T_FRIEND_SERVER_CONFIRM_RQ * t_friendAddCon_rq = GetT_FRIEND_SERVER_CONFIRM_RQ(trans_param.buffer.bytes);
    
    NIMFriendPacket * sAddCon = [[NIMFriendPacket alloc]init];
    sAddCon.peer_user_id = t_friendAddCon_rq->peer_user_id();
    sAddCon.result =  t_friendAddCon_rq->result();
    sAddCon.peer_nick_name = [NSString stringWithCString:t_friendAddCon_rq->peer_nickname()->c_str() encoding:NSUTF8StringEncoding];
    sAddCon.addToken = [NSString stringWithFormat:@"%llu",t_friendAddCon_rq->token()];
//    t_friendAddCon_rq->token()
    [[NIMFriendManager sharedInstance] recvServerAddConRQ:sAddCon];
}

#pragma mark 发送黑名单操作
-(void)addBlackListRQ:(int64)peerUser_id blackType:(NIMFDBlackShipType)blackType
{
    int blackInt = blackType;
    flatbuffers::FlatBufferBuilder faBuilder;
    friendpack::T_CLIENT_FRIEND_BLACKLIST_RQBuilder friendAdd_rq = T_CLIENT_FRIEND_BLACKLIST_RQBuilder(faBuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    friendAdd_rq.add_s_rq_head(&s_rq);
    friendAdd_rq.add_peer_user_id(peerUser_id);
    friendAdd_rq.add_type(blackInt);
    faBuilder.Finish(friendAdd_rq.Finish());
    BYTE*	buf = faBuilder.GetBufferPointer();
    WORD	len = (WORD)faBuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_CLIENT_FRIEND_BLACKLIST_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_CLIENT_FRIEND_BLACKLIST_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvBlackListRS:(QBTransParam *)trans_param
{
    T_CLINET_FRIEND_BLACKLIST_RS * t_add_rs = (friendpack::T_CLINET_FRIEND_BLACKLIST_RS*)GetT_CLINET_FRIEND_BLACKLIST_RS(trans_param.buffer.bytes);
    //检查头
    if(!t_add_rs || ![super checkHead:t_add_rs->s_rs_head()]){
        return;
    }
    //todo 删除pack_session_id
    int pack_id = t_add_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    NIMFriendPacket * fdPack = [[NIMFriendPacket alloc]init];
    fdPack.peer_user_id = t_add_rs->peer_user_id();
    fdPack.addToken = [NSString stringWithFormat:@"%llu",t_add_rs->token()];
    fdPack.blacktype = t_add_rs->type();
    [[NIMFriendManager sharedInstance] recvBlackListRQ:fdPack];
}

#pragma mark 收到黑名单操作通知

-(void)recvServerBlackRQ:(QBTransParam *)trans_param{
    const T_SERVER_FRIEND_BLACKLIST_RQ * t_friendAdd_rq = GetT_SERVER_FRIEND_BLACKLIST_RQ(trans_param.buffer.bytes);
    
    NIMFriendPacket * sAdd = [[NIMFriendPacket alloc]init];
    sAdd.peer_user_id = t_friendAdd_rq->peer_user_id();
    sAdd.blacktype = t_friendAdd_rq->type();
    sAdd.addToken = [NSString stringWithFormat:@"%lld",t_friendAdd_rq->token()];
    [[NIMFriendManager sharedInstance] recvServerBlackRQ:sAdd];
}


#pragma mark 删除新的朋友通知消息
-(void)sendDelUpdateFriendRQ:(int64)peer_id{
    flatbuffers::FlatBufferBuilder faBuilder;
    
    friendpack::T_FRIEND_UPDATE_RQBuilder friendAdd_rq = T_FRIEND_UPDATE_RQBuilder(faBuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    friendAdd_rq.add_s_rq_head(&s_rq);
    friendAdd_rq.add_peer_user_id(peer_id);
    
    faBuilder.Finish(friendAdd_rq.Finish());
    //    flatbuffers::Offset<T_FRIEND_BLACKLIST_RQ> offset_rq = friendAdd_rq.Finish();
    //    faBuilder.Finish(offset_rq);
    BYTE*	buf = faBuilder.GetBufferPointer();
    WORD	len = (WORD)faBuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_FRIEND_UPDATE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_FRIEND_UPDATE_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvDelUpdateFriendRS:(QBTransParam *)trans_param
{
    T_FRIEND_UPDATE_RS * t_add_rs = (friendpack::T_FRIEND_UPDATE_RS*)GetT_FRIEND_UPDATE_RS(trans_param.buffer.bytes);
    //检查头
    if(!t_add_rs || ![super checkHead:t_add_rs->s_rs_head()]){
        return;
    }
    //todo 删除pack_session_id
    int pack_id = t_add_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];

    NIMFriendPacket * fdPack = [[NIMFriendPacket alloc]init];
    fdPack.peer_user_id = t_add_rs->peer_user_id();
    fdPack.addToken = [NSString stringWithFormat:@"%llu",t_add_rs->token()];
    [[NIMFriendManager sharedInstance] recvDelUpdateFriendRQ:fdPack];
}



#pragma mark 收到恢复好友
-(void)recvServerRestorRQ:(QBTransParam *)trans_param{
    const T_FRIEND_SERVER_RECOVER_RQ * t_friendAdd_rq = GetT_FRIEND_SERVER_RECOVER_RQ(trans_param.buffer.bytes);
    
    NIMFriendPacket * sAdd = [[NIMFriendPacket alloc]init];
    sAdd.peer_nick_name = [NSString stringWithCString:t_friendAdd_rq->peer_nickname()->c_str() encoding:NSUTF8StringEncoding];
    sAdd.peer_user_id = t_friendAdd_rq->peer_user_id();
    sAdd.addToken = [NSString stringWithFormat:@"%lld",t_friendAdd_rq->token()];
    
    [[NIMFriendManager sharedInstance] recvServerRestorRQ:sAdd];
}

@end
