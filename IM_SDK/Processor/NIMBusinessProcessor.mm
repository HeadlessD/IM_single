//
//  NIMBusinessProcessor.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/6/21.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMBusinessProcessor.h"
#import "NIMCallBackManager.h"
#import "NetCenter.h"

#import "fb_ec_getfreewaiter_rq_generated.h"
#import "fb_ec_getfreewaiter_rs_generated.h"
#import "fb_ec_setbusiness_rq_generated.h"
#import "fb_ec_setbusiness_rs_generated.h"
#import "fb_ec_getbusiness_rq_generated.h"
#import "fb_ec_getbusiness_rs_generated.h"
@implementation NIMBusinessProcessor

using namespace commonpack;
using namespace ecpack;


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
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_BUSINESS_GETFREEWAITER_RS class_name:self func_name:@"recvGetFreeWaiterRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_BUSINESS_SETINFO_RS class_name:self func_name:@"recvSetBusinessInfo:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_BUSINESS_GETINFO_RS class_name:self func_name:@"recvGetBusinessInfo:"];

    
}


-(void)getFreeWaiter:(int64_t)bid wid_list:(NSArray *)wid_list
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    std::vector<uint64_t> widlist;
    
    for (int i=0; i<wid_list.count; i++) {
        int64_t wid = [wid_list[i] longLongValue];
        widlist.push_back(wid);
    }
    
    auto list = fbbuilder.CreateVector(widlist);
    
    
    T_EC_GETFREEWAITER_RQBuilder waiter = T_EC_GETFREEWAITER_RQBuilder(fbbuilder);
    
    waiter.add_s_rq_head(&s_rq);
    waiter.add_b_id(bid);
    waiter.add_w_id_list(list);
    
    flatbuffers::Offset<T_EC_GETFREEWAITER_RQ> offset_rq = waiter.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_BUSINESS_GETFREEWAITER_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_BUSINESS_GETFREEWAITER_RQ buffer:buf buf_len:len packID:packetID msgId:0];
    
    
}


-(void)recvGetFreeWaiterRS:(QBTransParam *)trans_param
{
    T_EC_GETFREEWAITER_RS *waiter_rs = (T_EC_GETFREEWAITER_RS *)GetT_EC_GETFREEWAITER_RS(trans_param.buffer.bytes);
    
    if(!waiter_rs)
    {
        return;
    }
    DBLog(@"%d",waiter_rs->s_rs_head()->result());
    //检查头
    if(![super checkHead:waiter_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = waiter_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    int64_t bid = waiter_rs->b_id();
    int64_t wid = waiter_rs->w_id();
    int32_t sessionid = waiter_rs->session_id();
        
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_FREE_WAITER object:@{@"bid":@(bid),@"wid":@(wid),@"sid":@(sessionid)}];
}

-(void)setBusinessInfo:(SSIMBusinessModel *)info
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    

    T_EC_SETBUSINESS_RQBuilder business = T_EC_SETBUSINESS_RQBuilder(fbbuilder);
    
    business.add_s_rq_head(&s_rq);
    business.add_sellerId(info.bid);
    business.add_sellerType(info.bType);
    if (!IsStrEmpty(info.url)) {
        business.add_sellerUrl(fbbuilder.CreateString([info.url UTF8String]));
    }
    
    if (!IsStrEmpty(info.name)) {
        business.add_sellerName(fbbuilder.CreateString([info.name UTF8String]));
    }
    
    if (!IsStrEmpty(info.avatar)) {
        business.add_sellerAvatar(fbbuilder.CreateString([info.avatar UTF8String]));
    }
    
    flatbuffers::Offset<T_EC_SETBUSINESS_RQ> offset_rq = business.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_BUSINESS_SETINFO_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_BUSINESS_SETINFO_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvSetBusinessInfo:(QBTransParam *)trans_param
{
    T_EC_SETBUSINESS_RS *setBusiness_rs = (T_EC_SETBUSINESS_RS *)GetT_EC_SETBUSINESS_RS(trans_param.buffer.bytes);
    
    if(!setBusiness_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:setBusiness_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = setBusiness_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
}

-(void)getBusinessInfo:(int64_t)sellerid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    int packetID = [NIMBaseUtil getPacketSessionID];
    S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    
    
    T_EC_GETBUSINESS_RQBuilder business = T_EC_GETBUSINESS_RQBuilder(fbbuilder);
    
    business.add_sellerId(sellerid);
    
    flatbuffers::Offset<T_EC_GETBUSINESS_RQ> offset_rq = business.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_BUSINESS_GETINFO_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_BUSINESS_GETINFO_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvGetBusinessInfo:(QBTransParam *)trans_param
{
    T_EC_GETBUSINESS_RS *getBusiness_rs = (T_EC_GETBUSINESS_RS *)GetT_EC_GETBUSINESS_RS(trans_param.buffer.bytes);
    
    if(!getBusiness_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:getBusiness_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = getBusiness_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    int64_t bid = getBusiness_rs->sellerId();
    int type = getBusiness_rs->sellerType();
    NSString *name = [NSString stringWithCString:getBusiness_rs->sellerName()->c_str() encoding:NSUTF8StringEncoding];
    NSString *avatar = [NSString stringWithCString:getBusiness_rs->sellerAvatar()->c_str() encoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithCString:getBusiness_rs->sellerUrl()->c_str() encoding:NSUTF8StringEncoding];
    
}

@end
