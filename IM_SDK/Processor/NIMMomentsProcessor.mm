//
//  NIMMomentsProcessor.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/4.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMMomentsProcessor.h"
#import "NetCenter.h"
#import "NIMMomentsManager.h"

#import "DFTextImageLineItem.h"
#import "DFVideoLineItem.h"
#import "DFLineCommentItem.h"
#import "DFLineLikeItem.h"

#import "t_moments_article_add_rq_generated.h"
#import "t_moments_article_add_rs_generated.h"
#import "t_moments_article_delete_rq_generated.h"
#import "t_moments_article_delete_rs_generated.h"
#import "t_moments_article_add_notify_generated.h"
#import "t_moments_article_delete_notify_generated.h"

#import "t_moments_timeline_query_rq_generated.h"
#import "t_moments_timeline_query_rs_generated.h"
#import "t_moments_query_by_ids_rq_generated.h"
#import "t_moments_query_by_ids_rs_generated.h"
#import "t_moments_common_generated.h"

#import "t_moments_comment_add_rq_generated.h"
#import "t_moments_comment_add_rs_generated.h"
#import "t_moments_comment_add_notify_generated.h"
#import "t_moments_comment_delete_rq_generated.h"
#import "t_moments_comment_delete_rs_generated.h"
#import "t_moments_comment_delete_notify_generated.h"

#import "t_moments_query_by_user_rq_generated.h"
#import "t_moments_query_by_user_rs_generated.h"

#import "t_moments_setting_query_rq_generated.h"
#import "t_moments_setting_query_rs_generated.h"
#import "t_moments_setting_modify_rq_generated.h"
#import "t_moments_setting_modify_rs_generated.h"
#import "t_moments_setting_modify_notify_generated.h"
#import "t_moments_setting_blacknotcarelist_modify_rq_generated.h"
#import "t_moments_setting_blacknotcarelist_modify_rs_generated.h"
#import "t_moments_setting_blacknotcarelist_modify_notify_generated.h"

#import "t_moments_pic_article_query_rq_generated.h"
#import "t_moments_pic_article_query_rs_generated.h"


@implementation NIMMomentsProcessor
{
    BOOL isTop;
}
using namespace momentspack;
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
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_ADDARTICLE_RQ class_name:self func_name:@"sendMomentsArticleRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_ADDARTICLE_RS class_name:self func_name:@"recvMomentsArticleRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_DELARTICLE_RQ class_name:self func_name:@"deleteMomentsArticleRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_DELARTICLE_RS class_name:self func_name:@"deleteMomentsArticleRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_ADDARTICLE_NOTIFY class_name:self func_name:@"sendMomentsArticleAddNotify:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_DELARTICLE_NOTIFY class_name:self func_name:@"sendMomentsArticleDeleteNotify:"];

    
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYTIMELIME_RQ class_name:self func_name:@"sendMomentsTimelineQueryRQ:startTime:endTime:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYTIMELIME_RS class_name:self func_name:@"recvMomentsTimelineQueryRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYBYIDS_RQ class_name:self func_name:@"sendMomentsIdsQueryRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYBYIDS_RS class_name:self func_name:@"recvMomentsIdsQueryRS:"];
    
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_ADDCOMMENT_RQ class_name:self func_name:@"sendMomentsCommentAddRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_ADDCOMMENT_RS class_name:self func_name:@"recvMomentsCommentAddRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_ADDCOMMENT_NOTIFY class_name:self func_name:@"commentAddNotify:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_DELCOMMENT_RQ class_name:self func_name:@"deleteMomentsCommentRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_DELCOMMENT_RS class_name:self func_name:@"deleteMomentsCommentRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_DELCOMMENT_NOTIFY class_name:self func_name:@"commentDeleteNotify:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYBYUSER_RQ class_name:self func_name:@"sendQueryMomentsRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYBYUSER_RS class_name:self func_name:@"recvQueryMomentsRS:"];

    
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_UPDBLACKNOTCARELIST_RQ class_name:self func_name:@"settingBlacknotcarelistModifyRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_UPDBLACKNOTCARELIST_RS class_name:self func_name:@"settingBlacknotcarelistModifyRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_UPDSETTING_RQ class_name:self func_name:@"settingModifyRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_UPDSETTING_RS class_name:self func_name:@"settingModifyRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_UPDATESETTINGLIST_NOTIFY class_name:self func_name:@"recvSettingBlacknotcarelistModifyNotifyRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYSETTING_RQ class_name:self func_name:@"settingQueryRQ:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYSETTING_RS class_name:self func_name:@"settingQueryRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_UPDSETTING_NOTIFY class_name:self func_name:@"settingModifyNotify:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_MOMENTS_QUERYPICARTICLE_RS class_name:self func_name:@"queryPicArticleRS:"];


}

//发布朋友圈
-(void)sendMomentsArticleRQ:(DFBaseLineItem *)item
{
    NSString *name = _IM_FormatStr(@"%@",item.userNick);
    NSString *contentStr = item.content;
    
    NSString *whiteStr = item.whiteList;
    NSString *blackStr = item.blackList;

    if (IsStrEmpty(contentStr)) {
        contentStr = @"";
    }
    if (IsStrEmpty(whiteStr)) {
        whiteStr = @"";
    }
    if (IsStrEmpty(blackStr)) {
        blackStr = @"";
    }
    NSString *titleStr = @"";
    titleStr = _IM_FormatStr(@"%@",item.text);;
    
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    auto nickName = fbbuilder.CreateString([name UTF8String]);
    auto content = fbbuilder.CreateString([contentStr UTF8String]);
    auto title = fbbuilder.CreateString([titleStr UTF8String]);
    
    auto whiteList = fbbuilder.CreateString([whiteStr UTF8String]);
    auto blackList = fbbuilder.CreateString([blackStr UTF8String]);

    
    T_MOMENTS_ARTICLE_ADD_RQBuilder article_rq = T_MOMENTS_ARTICLE_ADD_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    article_rq.add_s_rq_head(&s_rq);
    article_rq.add_article_id(item.itemId);
    article_rq.add_user_id(OWNERID);
    article_rq.add_create_time(item.ts);
    article_rq.add_priv_type(item.priType);
    article_rq.add_content_type(item.contentType);
    article_rq.add_content(content);
    article_rq.add_user_nickname(nickName);
    article_rq.add_title(title);
    article_rq.add_black_list(blackList);
    article_rq.add_white_list(whiteList);
    
    flatbuffers::Offset<T_MOMENTS_ARTICLE_ADD_RQ> offset_rq = article_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_ADDARTICLE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_ADDARTICLE_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvMomentsArticleRS:(QBTransParam *)trans_param
{
    T_MOMENTS_ARTICLE_ADD_RS *article_rs = (T_MOMENTS_ARTICLE_ADD_RS *)GetT_MOMENTS_ARTICLE_ADD_RS(trans_param.buffer.bytes);
    
    if(!article_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:article_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = article_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    int64_t peer_user_id = article_rs->peer_user_id();
    int64_t article_id = article_rs->article_id();

    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SEND_ARTICLE object:@(article_id)];
}

//删除朋友圈
-(void)deleteMomentsArticleRQ:(DFBaseLineItem *)item
{

    flatbuffers::FlatBufferBuilder fbbuilder;
    
    T_MOMENTS_ARTICLE_DELETE_RQBuilder article_rq = T_MOMENTS_ARTICLE_DELETE_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    article_rq.add_s_rq_head(&s_rq);
    article_rq.add_article_id(item.itemId);
    article_rq.add_article_user_id(item.userId);
    flatbuffers::Offset<T_MOMENTS_ARTICLE_DELETE_RQ> offset_rq = article_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_DELARTICLE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_DELARTICLE_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)deleteMomentsArticleRS:(QBTransParam *)trans_param
{
    T_MOMENTS_ARTICLE_DELETE_RS *article_rs = (T_MOMENTS_ARTICLE_DELETE_RS *)GetT_MOMENTS_ARTICLE_DELETE_RS(trans_param.buffer.bytes);
    
    if(!article_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:article_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = article_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
//    int64_t article_user_id = article_rs->article_user_id();
    int64_t article_id = article_rs->article_id();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_DELETE_ARTICLE object:@(article_id)];
}


//服务端推送朋友圈
-(void)sendMomentsArticleAddNotify:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_MOMENTS_ARTICLE_ADD_NOTIFYBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
    }
    T_MOMENTS_ARTICLE_ADD_NOTIFY *add_rs = (T_MOMENTS_ARTICLE_ADD_NOTIFY *)GetT_MOMENTS_ARTICLE_ADD_NOTIFY(trans_param.buffer.bytes);
    if(!add_rs)
    {
        return;
    }
//    int64_t moments_change_at = add_rs->moments_change_at();
    isTop = YES;
    [self sendMomentsTimelineQueryRQ:OWNERID startTime:0 endTime:[NIMBaseUtil GetServerTime]/1000-1];
}


//服务端推送删除朋友圈
-(void)sendMomentsArticleDeleteNotify:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_MOMENTS_ARTICLE_DELETE_NOTIFYBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
    }
    T_MOMENTS_ARTICLE_DELETE_NOTIFY *add_rs = (T_MOMENTS_ARTICLE_DELETE_NOTIFY *)GetT_MOMENTS_ARTICLE_DELETE_NOTIFY(trans_param.buffer.bytes);
    if(!add_rs)
    {
        return;
    }
    int64_t article_id = add_rs->article_id();
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_DELETE_ARTICLE object:@(article_id)];

}


//根据时间获取朋友圈
-(void)sendMomentsTimelineQueryRQ:(int64_t)userid startTime:(int64_t)startTime endTime:(int64_t)endTime
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    T_MOMENTS_TIMELINE_QUERY_RQBuilder time_query_rq = T_MOMENTS_TIMELINE_QUERY_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    time_query_rq.add_s_rq_head(&s_rq);
    time_query_rq.add_user_id(userid);
    time_query_rq.add_start_time(startTime);
    time_query_rq.add_end_time(endTime);
    time_query_rq.add_page_size(10);
    flatbuffers::Offset<T_MOMENTS_TIMELINE_QUERY_RQ> offset_rq = time_query_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_QUERYTIMELIME_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_QUERYTIMELIME_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvMomentsTimelineQueryRS:(QBTransParam *)trans_param
{
    T_MOMENTS_TIMELINE_QUERY_RS *time_query_rs = (T_MOMENTS_TIMELINE_QUERY_RS *)GetT_MOMENTS_TIMELINE_QUERY_RS(trans_param.buffer.bytes);
    
    if(!time_query_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:time_query_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = time_query_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    NSLog(@"查询结束时间：%f",[[NSDate date] timeIntervalSince1970]);
    const flatbuffers::Vector<flatbuffers::Offset<momentspack::T_TIMELINE_DTO>> *timelines = time_query_rs->timelines();
    if(timelines){
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:5];
        for (flatbuffers::uoffset_t i = 0; i < timelines->size(); i++)
        {
            T_TIMELINE_DTO *dto = (T_TIMELINE_DTO *)timelines->Get(i);
            DFModel *model = [DFModel new];
            model.articleId = dto->article_id();
            model.user_id = dto->article_user_id();
            [models addObject:model];
        }
        [self sendMomentsIdsQueryRQ:models];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_ARTICLE object:@(NO)];
    }
}


//根据IDS获取朋友圈详情
-(void)sendMomentsIdsQueryRQ:(NSArray *)timelines
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    std::vector< flatbuffers::Offset<T_TIMELINE_DTO> > vector_dto;

    for (flatbuffers::uoffset_t i = 0; i < timelines.count; i++)
    {
        DFModel *model = timelines[i];
        T_TIMELINE_DTOBuilder dtoBuilder = T_TIMELINE_DTOBuilder(fbbuilder);
        dtoBuilder.add_article_id(model.articleId);
        NSLog(@"朋友圈id :%lld",model.articleId);
        dtoBuilder.add_article_user_id(model.user_id);
        vector_dto.push_back(dtoBuilder.Finish());
    }
    
    auto vec_vector_dto = fbbuilder.CreateVector(vector_dto);
    
    
    T_MOMENTS_QUERY_BY_IDS_RQBuilder ids_query_rq = T_MOMENTS_QUERY_BY_IDS_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    ids_query_rq.add_s_rq_head(&s_rq);
    ids_query_rq.add_user_id(OWNERID);
    ids_query_rq.add_timelines(vec_vector_dto);
    
    flatbuffers::Offset<T_MOMENTS_QUERY_BY_IDS_RQ> offset_rq = ids_query_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_QUERYBYIDS_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_QUERYBYIDS_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvMomentsIdsQueryRS:(QBTransParam *)trans_param
{
    T_MOMENTS_QUERY_BY_IDS_RS *ids_query_rs = (T_MOMENTS_QUERY_BY_IDS_RS *)GetT_MOMENTS_QUERY_BY_IDS_RS(trans_param.buffer.bytes);
    
    if(!ids_query_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:ids_query_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = ids_query_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    for (flatbuffers::uoffset_t i = 0; i < ids_query_rs->full_infos()->size(); i++)
    {
        T_MOMENTS_FULL_INFO_DTO *full_dto = (T_MOMENTS_FULL_INFO_DTO *)ids_query_rs->full_infos()->Get(i);
        T_MOMENTS_ARTICLE_DTO *article_dto = (T_MOMENTS_ARTICLE_DTO *)full_dto->article();
        DFBaseLineItem *textImageItem;
        Moments_Content_Type type = (Moments_Content_Type)article_dto->content_type();
        if (type == Moments_Content_Type_Video) {
            textImageItem = [self createVideoPeerComment:article_dto];
        } else {
            textImageItem = [self createPeerComment:article_dto];
        }
        if(full_dto->comments()){
            for (flatbuffers::uoffset_t j = 0; j < full_dto->comments()->size(); j++)
            {
                T_MOMENTS_COMMENT_DTO *comment_dto = (T_MOMENTS_COMMENT_DTO *)full_dto->comments()->Get(j);
                [self createCommentItem:comment_dto item:textImageItem];
            }
        }
        if ([NIMMomentsManager sharedInstance].isDetail) {
            [NIMMomentsManager sharedInstance].isDetail = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_DETAIL object:textImageItem];
        }else{
            if (isTop) {
                [[NIMMomentsManager sharedInstance] insertTopArticleItem:textImageItem];
            }else{
                [[NIMMomentsManager sharedInstance] insertBottomArticleItem:textImageItem];
            }
        }
    }
    if (isTop) {
        isTop = !isTop;
    }
    NSLog(@"详情结束时间：%f",[[NSDate date] timeIntervalSince1970]);
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_ARTICLE object:@(YES)];
}


//查看好友朋友圈
-(void)sendQueryMomentsRQ:(int64_t)friendid endTime:(int64_t)endTime
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    T_MOMENTS_ARTICLE_QUERY_BY_USER_RQBuilder moments_query = T_MOMENTS_ARTICLE_QUERY_BY_USER_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    moments_query.add_s_rq_head(&s_rq);
    moments_query.add_user_id(OWNERID);
    moments_query.add_friend_id(friendid);
    moments_query.add_start_time(0);
    moments_query.add_end_time(endTime);
    moments_query.add_page_size(10);
//    moments_query.add_page_index(0);
    
    flatbuffers::Offset<T_MOMENTS_ARTICLE_QUERY_BY_USER_RQ> offset_rq = moments_query.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_QUERYBYUSER_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_QUERYBYUSER_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvQueryMomentsRS:(QBTransParam *)trans_param
{
    T_MOMENTS_ARTICLE_QUERY_BY_USER_RS *query_rs = (T_MOMENTS_ARTICLE_QUERY_BY_USER_RS *)GetT_MOMENTS_ARTICLE_QUERY_BY_USER_RS(trans_param.buffer.bytes);
    
    if(!query_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:query_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = query_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    if (query_rs->articles()) {
        for (flatbuffers::uoffset_t i = 0; i < query_rs->articles()->size(); i++)
        {
            T_MOMENTS_ARTICLE_DTO *article_dto = (T_MOMENTS_ARTICLE_DTO *)query_rs->articles()->Get(i);
            DFBaseUserLineItem *userItem = [[DFBaseUserLineItem alloc] init];
            Moments_Content_Type type = (Moments_Content_Type)article_dto->content_type();
            if (type == Moments_Content_Type_Video) {
                userItem = [self createUserVideoLineItem:article_dto];
            } else {
                userItem = [self createUserLineItem:article_dto];
            }
//            DFTextImageUserLineItem *textImageItem = [self createUserLineItem:article_dto];
            [[NIMMomentsManager sharedInstance] insertUserItem:userItem];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_USER_QUERY object:@YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_USER_QUERY object:@NO];
    }
    
}


/*********************************************这是评论/点赞分割线*********************************************/



//发表评论/点赞
-(void)sendMomentsCommentAddRQ:(DFLineCommentItem *)commentItem
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    NSString *nick = IsStrEmpty(commentItem.userNick)?@"":commentItem.userNick;
    NSString *reNick = IsStrEmpty(commentItem.replyUserNick)?@"":commentItem.replyUserNick;
    NSString *contentStr = IsStrEmpty(commentItem.content)?@"":commentItem.content;

    auto userNick = fbbuilder.CreateString([nick UTF8String]);
    auto reUserNick = fbbuilder.CreateString([reNick UTF8String]);
    auto content = fbbuilder.CreateString([contentStr UTF8String]);

    
    T_MOMENTS_COMMENT_DTOBuilder comment_dto = T_MOMENTS_COMMENT_DTOBuilder(fbbuilder);
    comment_dto.add_user_id(commentItem.userId);
    comment_dto.add_user_nickname(userNick);
    
    comment_dto.add_article_id(commentItem.articleId);
    comment_dto.add_article_user_id(commentItem.articleUserId);
    
    comment_dto.add_comment_id(commentItem.commentId);
    comment_dto.add_comment_type(commentItem.commentType);
    comment_dto.add_create_time(commentItem.createTime);
    
    comment_dto.add_commented_user_id(commentItem.replyUserId);
    comment_dto.add_commented_user_nickname(reUserNick);
    comment_dto.add_content(content);
    
    flatbuffers::Offset<T_MOMENTS_COMMENT_DTO> comment_dto_offset = comment_dto.Finish();

    T_MOMENTS_COMMENT_ADD_RQBuilder comment_add_rq = T_MOMENTS_COMMENT_ADD_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    comment_add_rq.add_s_rq_head(&s_rq);
    comment_add_rq.add_comment(comment_dto_offset);
    
    flatbuffers::Offset<T_MOMENTS_COMMENT_ADD_RQ> offset_rq = comment_add_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_ADDCOMMENT_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_ADDCOMMENT_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvMomentsCommentAddRS:(QBTransParam *)trans_param
{
     T_MOMENTS_COMMENT_ADD_RS *com_add_rs = (T_MOMENTS_COMMENT_ADD_RS *)GetT_MOMENTS_COMMENT_ADD_RS(trans_param.buffer.bytes);
    
    if(!com_add_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:com_add_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = com_add_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    T_MOMENTS_COMMENT_DTO *dto = (T_MOMENTS_COMMENT_DTO *)com_add_rs->comment();
    
    DFLineCommentItem *commentItem  = [[DFLineCommentItem alloc] init];
    commentItem.commentId = dto->comment_id();
    commentItem.commentType = (Comment_Type)dto->comment_type();
    commentItem.createTime = dto->create_time();
    commentItem.articleId = dto->article_id();
    commentItem.articleUserId = dto->article_user_id();
    commentItem.content = [NSString stringWithUTF8String:dto->content()->c_str()];
    commentItem.userId = dto->user_id();
    commentItem.userNick = [NSString stringWithUTF8String:dto->user_nickname()->c_str()];
    commentItem.replyUserId = dto->commented_user_id();
    commentItem.replyUserNick = [NSString stringWithUTF8String:dto->commented_user_nickname()->c_str()];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SEND_COMMENT object:commentItem];
}

//推送评论
-(void)commentAddNotify:(QBTransParam *)trans_param
{
    const T_MOMENTS_COMMENT_ADD_NOTIFY *notify = GetT_MOMENTS_COMMENT_ADD_NOTIFY(trans_param.buffer.bytes);
    T_MOMENTS_COMMENT_DTO *dto = (T_MOMENTS_COMMENT_DTO *)notify->comment();
    DFLineCommentItem *commentItem  = [[DFLineCommentItem alloc] init];
    commentItem.commentId = dto->comment_id();
    commentItem.commentType = (Comment_Type)dto->comment_type();
    commentItem.createTime = dto->create_time();
    commentItem.articleId = dto->article_id();
    commentItem.articleUserId = dto->article_user_id();
    commentItem.content = [NSString stringWithUTF8String:dto->content()->c_str()];
    commentItem.userId = dto->user_id();
    commentItem.userNick = [NSString stringWithUTF8String:dto->user_nickname()->c_str()];
    commentItem.replyUserId = dto->commented_user_id();
    if (dto->commented_user_nickname()) {
        commentItem.replyUserNick = [NSString stringWithUTF8String:dto->commented_user_nickname()->c_str()];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SEND_COMMENT object:commentItem];
}


//删除评论
-(void)deleteMomentsCommentRQ:(DFLineCommentItem *)commentItem
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    T_MOMENTS_COMMENT_DELETE_RQBuilder comment_delete = T_MOMENTS_COMMENT_DELETE_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    comment_delete.add_s_rq_head(&s_rq);
    comment_delete.add_user_id(commentItem.userId);
    comment_delete.add_article_id(commentItem.articleId);
    comment_delete.add_article_user_id(commentItem.articleUserId);
    comment_delete.add_comment_id(commentItem.commentId);
    
    flatbuffers::Offset<T_MOMENTS_COMMENT_DELETE_RQ> offset_rq = comment_delete.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_DELCOMMENT_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_DELCOMMENT_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)deleteMomentsCommentRS:(QBTransParam *)trans_param
{
    T_MOMENTS_COMMENT_DELETE_RS *com_del_rs = (T_MOMENTS_COMMENT_DELETE_RS *)GetT_MOMENTS_COMMENT_DELETE_RS(trans_param.buffer.bytes);
    
    if(!com_del_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:com_del_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = com_del_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    int64_t comment_id = com_del_rs->comment_id();
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_DELETE_COMMENT_DETAIL object:@(comment_id)];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_DELETE_COMMENT object:@(comment_id)];
}


//推送删除评论
-(void)commentDeleteNotify:(QBTransParam *)trans_param
{
    const T_MOMENTS_COMMENT_DELETE_NOTIFY *notify = GetT_MOMENTS_COMMENT_DELETE_NOTIFY(trans_param.buffer.bytes);
    int64_t comment_id = notify->comment_id();
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_DELETE_COMMENT object:@(comment_id)];
}



/*********************************************这是设置分割线*********************************************/






//更新朋友圈黑名单,不关注名单设置
-(void)settingBlacknotcarelistModifyRQ:(List_Type)type list:(NSString *)list
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    auto listS = fbbuilder.CreateString([list UTF8String]);
    
    T_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_RQBuilder setting_rq = T_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    setting_rq.add_s_rq_head(&s_rq);
    setting_rq.add_user_id(OWNERID);
    setting_rq.add_list_type(type);
    setting_rq.add_list(listS);
    
    flatbuffers::Offset<T_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_RQ> offset_rq = setting_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_UPDBLACKNOTCARELIST_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_UPDBLACKNOTCARELIST_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)settingBlacknotcarelistModifyRS:(QBTransParam *)trans_param
{
    T_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_RS *setting_rs = (T_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_RS *)GetT_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_RS(trans_param.buffer.bytes);
    
    if(!setting_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:setting_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = setting_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SET_BLACK_LIST object:@YES];

}


-(void)recvSettingBlacknotcarelistModifyNotifyRQ:(QBTransParam *)trans_param
{
    
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_NOTIFYBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
    }
    const T_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_NOTIFY *notify = GetT_MOMENTS_SETTING_BLACKNOTCARELIST_MODIFY_NOTIFY(trans_param.buffer.bytes);
    
    if(!notify)
    {
        return;
    }
    
}

//更新朋友圈设置
-(void)settingModifyRQ:(DFSettingItem *)item
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    T_MOMENTS_SETTING_DTOBuilder dto_rq = T_MOMENTS_SETTING_DTOBuilder(fbbuilder);
    dto_rq.add_user_id(OWNERID);
    dto_rq.add_update_time([NIMBaseUtil GetServerTime]/1000);
    dto_rq.add_moments_enable(item.momentsEnable);
    dto_rq.add_moments_scope(item.momentsScope);
    dto_rq.add_moments_notice(item.momentsNotice);
    dto_rq.add_list_10_pic_free(item.listPicFree);
    
    flatbuffers::Offset<T_MOMENTS_SETTING_DTO> offset_dto = dto_rq.Finish();

    T_MOMENTS_SETTING_MODIFY_RQBuilder setting_rq = T_MOMENTS_SETTING_MODIFY_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    setting_rq.add_s_rq_head(&s_rq);
    setting_rq.add_setting(offset_dto);
    flatbuffers::Offset<T_MOMENTS_SETTING_MODIFY_RQ> offset_rq = setting_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_UPDSETTING_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_UPDSETTING_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)settingModifyRS:(QBTransParam *)trans_param
{
    T_MOMENTS_SETTING_MODIFY_RS *setting_rs = (T_MOMENTS_SETTING_MODIFY_RS *)GetT_MOMENTS_SETTING_MODIFY_RS(trans_param.buffer.bytes);
    
    if(!setting_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:setting_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = setting_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    T_MOMENTS_SETTING_DTO *dto = (T_MOMENTS_SETTING_DTO *)setting_rs->setting();
    [NIMMomentsManager sharedInstance].setItem.userId = dto->user_id();
    [NIMMomentsManager sharedInstance].setItem.listPicFree = dto->list_10_pic_free();
    [NIMMomentsManager sharedInstance].setItem.momentsScope = (Moments_Scope)dto->moments_scope();
    [NIMMomentsManager sharedInstance].setItem.momentsEnable = dto->moments_enable();
    [NIMMomentsManager sharedInstance].setItem.momentsNotice = dto->moments_notice();
    [NIMMomentsManager sharedInstance].setItem.updateTime = dto->update_time();
}

//查询朋友圈设置
-(void)settingQueryRQ:(int64_t)userid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    T_MOMENTS_SETTING_QUERY_RQBuilder setting_rq = T_MOMENTS_SETTING_QUERY_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    setting_rq.add_s_rq_head(&s_rq);
    setting_rq.add_user_id(userid);
    
    flatbuffers::Offset<T_MOMENTS_SETTING_QUERY_RQ> offset_rq = setting_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_QUERYSETTING_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_QUERYSETTING_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)settingQueryRS:(QBTransParam *)trans_param
{
    T_MOMENTS_SETTING_QUERY_RS *setting_rs = (T_MOMENTS_SETTING_QUERY_RS *)GetT_MOMENTS_SETTING_QUERY_RS(trans_param.buffer.bytes);
    
    if(!setting_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:setting_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = setting_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    T_MOMENTS_SETTING_DTO *dto = (T_MOMENTS_SETTING_DTO *)setting_rs->setting();
    DFSettingItem *item = [[DFSettingItem alloc] init];
    item.userId = dto->user_id();
    item.listPicFree = dto->list_10_pic_free();
    item.momentsScope = (Moments_Scope)dto->moments_scope();
    item.momentsEnable = dto->moments_enable();
    item.momentsNotice = dto->moments_notice();
    item.updateTime = dto->update_time();
    if (dto->black_list()) {
        item.blackList = [NSString stringWithUTF8String:dto->black_list()->c_str()];
    }
    if (dto->not_care_list()) {
        item.notCareList = [NSString stringWithUTF8String:dto->not_care_list()->c_str()];
    }
    [NIMMomentsManager sharedInstance].setItem = item;
    [[NIMMomentsManager sharedInstance] deleteMomentsInNotCare:item.notCareList];
}

-(void)settingModifyNotify:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((const uint8_t *)trans_param.buffer.bytes, trans_param.buf_len);
    bool is_fbs = VerifyT_MOMENTS_SETTING_MODIFY_NOTIFYBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"%s%d行不是FBS包",__func__, __LINE__);
    }
    const T_MOMENTS_SETTING_MODIFY_NOTIFY *notify = GetT_MOMENTS_SETTING_MODIFY_NOTIFY(trans_param.buffer.bytes);
    
    if(!notify)
    {
        return;
    }
    
    
}

-(void)queryPicArticle:(int64_t)userid
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    T_MOMENTS_PIC_ARTICLE_QUERY_RQBuilder article_rq = T_MOMENTS_PIC_ARTICLE_QUERY_RQBuilder(fbbuilder);
    int packetID = [NIMBaseUtil getPacketSessionID];
    const commonpack::S_RQ_HEAD s_rq(OWNERID,packetID,PLATFORM_APP);
    article_rq.add_s_rq_head(&s_rq);
    article_rq.add_user_id(userid);
    article_rq.add_page_size(3);
    flatbuffers::Offset<T_MOMENTS_PIC_ARTICLE_QUERY_RQ> offset_rq = article_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_MOMENTS_QUERYPICARTICLE_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_MOMENTS_QUERYPICARTICLE_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}


-(void)queryPicArticleRS:(QBTransParam *)trans_param
{
    T_MOMENTS_PIC_ARTICLE_QUERY_RS *query_rs = (T_MOMENTS_PIC_ARTICLE_QUERY_RS *)GetT_MOMENTS_PIC_ARTICLE_QUERY_RS(trans_param.buffer.bytes);
    
    if(!query_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:query_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = query_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:5];
    if (query_rs->articles()) {
        for (flatbuffers::uoffset_t i = 0; i < query_rs->articles()->size(); i++) {
            T_MOMENTS_ARTICLE_DTO *article_dto = (T_MOMENTS_ARTICLE_DTO *)query_rs->articles()->Get(i);
            DFTextImageLineItem *textImageItem = [self createPeerComment:article_dto];
            if (textImageItem.srcImages.count>0) {
                [images addObject:textImageItem.srcImages.firstObject];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_PIC_QUERY object:images];
}





-(DFTextImageLineItem *)createPeerComment:(T_MOMENTS_ARTICLE_DTO *)article_dto

{
    int64_t user_id = article_dto->user_id();
    VcardEntity * ownVcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userid=%lld",user_id]];
    NSString *name = [ownVcard defaultName];
    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
    textImageItem.itemId = article_dto->article_id(); //随便设置一个 待服务器生成
    textImageItem.userId = article_dto->user_id();
    textImageItem.userAvatar = USER_ICON_URL(user_id);
    textImageItem.userNick = name;
    textImageItem.contentType = (Moments_Content_Type)article_dto->content_type();
    if (article_dto->title()) {
        textImageItem.text = [NSString stringWithUTF8String:article_dto->title()->c_str()];
    }
    
    Moments_Content_Type type = (Moments_Content_Type)article_dto->content_type();
    if (type == Moments_Content_Type_TextImg) {
        NSString *content = @"";
        if (article_dto->content()) {
            content = [NSString stringWithUTF8String:article_dto->content()->c_str()];
            textImageItem.content = content;
        }
        NSArray *srcImages = [content componentsSeparatedByString:@"#"];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:5];
        for (NSString *src in srcImages) {
            if (IsStrEmpty(src)) {
                continue;
            }
            NSString *imageSrc = src;
            if (![imageSrc containsString:@"http"]&&![imageSrc containsString:@"https"]) {
                imageSrc = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,src);
            }
            NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:imageSrc]];
            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:imageSrc];
            [images addObject:imageSrc];
        }
        textImageItem.srcImages = [NSMutableArray arrayWithArray:images]; //大图 可以是本地路径 也可以是网络地址 会自动判断
        textImageItem.thumbImages = [NSMutableArray arrayWithArray:images]; //小图 可以是本地路径 也可以是网络地址 会自动判断
    }
    textImageItem.ts = article_dto->create_time();
    //    textImageItem.location = @"金色洗脚城";
    return textImageItem;
}

-(DFVideoLineItem *)createVideoPeerComment:(T_MOMENTS_ARTICLE_DTO *)article_dto

{
    int64_t user_id = article_dto->user_id();
    VcardEntity * ownVcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userid=%lld",user_id]];
    NSString *name = [ownVcard defaultName];
    DFVideoLineItem *textVideoItem = [[DFVideoLineItem alloc] init];
    textVideoItem.itemId = article_dto->article_id(); //随便设置一个 待服务器生成
    textVideoItem.userId = article_dto->user_id();
    textVideoItem.userAvatar = USER_ICON_URL(user_id);
    textVideoItem.userNick = name;
    textVideoItem.contentType = (Moments_Content_Type)article_dto->content_type();
    if (article_dto->title()) {
        textVideoItem.text = [NSString stringWithUTF8String:article_dto->title()->c_str()];
    }
    Moments_Content_Type type = (Moments_Content_Type)article_dto->content_type();
    if (type == Moments_Content_Type_Video) {
        NSString *content = @"";
        if (article_dto->content()) {
            content = [NSString stringWithUTF8String:article_dto->content()->c_str()];
            NSArray *arr = [content componentsSeparatedByString:@"#"];
            for (NSString *urlStr in arr) {
                if (IsStrEmpty(urlStr)) {
                    continue;
                }
                NSString *imageSrc = urlStr;
                if (![imageSrc containsString:@"http"]&&![imageSrc containsString:@"https"]) {
                    imageSrc = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,urlStr);
                }
                NSString *extension = [urlStr pathExtension];
                NSString *realExtension = @"";
                if ([extension isEqualToString:@"vo"]) {
                    realExtension = @"mov";
                    textVideoItem.videoUrl = imageSrc;
                } else {
                    realExtension = @"jpg";
                    textVideoItem.thumbUrl = imageSrc;
                    NSString *filePath = [NSString stringWithFormat:@"%@%@.%@",DF_CACHEPATH, [DFToolUtil md5:imageSrc],realExtension];
                    [[DFFileManager sharedInstance] saveFileToLocal:filePath url:imageSrc];
                }
            }
        }
    }
    textVideoItem.ts = article_dto->create_time();
    //    textImageItem.location = @"金色洗脚城";
    return textVideoItem;
}

//创建评论和点赞
-(void)createCommentItem:(T_MOMENTS_COMMENT_DTO *)comment_dto item:(DFBaseLineItem *)item
{
    Comment_Type type = (Comment_Type)comment_dto->comment_type();
    
    DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
    commentItem.commentId = comment_dto->comment_id();
    commentItem.userId = comment_dto->user_id();
    commentItem.userNick = [NSString stringWithUTF8String:comment_dto->user_nickname()->c_str()];
    commentItem.content = [NSString stringWithUTF8String:comment_dto->content()->c_str()];
    commentItem.userId = comment_dto->user_id();
    commentItem.userNick = [NSString stringWithUTF8String:comment_dto->user_nickname()->c_str()];
    commentItem.commentType = type;
    commentItem.articleUserId = item.userId;
    commentItem.articleId = item.itemId;
    commentItem.createTime = comment_dto->create_time();
    
    if(type==Comment_Type_Comment){
        int64_t commentedUserId = comment_dto->commented_user_id();
        if(commentedUserId>0){
            commentItem.replyUserId = commentedUserId;
            if (commentedUserId == OWNERID) {
                commentItem.replyUserNick = @"我";
            } else {
                if(comment_dto->commented_user_nickname()){
                    commentItem.replyUserNick = [NSString stringWithUTF8String:comment_dto->commented_user_nickname()->c_str()];
                } else {
                    commentItem.replyUserNick = [NSString stringWithFormat:@"%lld",commentedUserId];
                }
            }
        }
        [item.comments addObject:commentItem];
        [[NIMMomentsManager sharedInstance] genCommentAttrString:item];
        [[NIMMomentsManager sharedInstance] insertCommentItem:commentItem];
    }else if(type==Comment_Type_Like){
        [item.likes addObject:commentItem];
        [[NIMMomentsManager sharedInstance] genLikeAttrString:item];
        [[NIMMomentsManager sharedInstance] insertLikeItem:commentItem];
        [[NIMMomentsManager sharedInstance] insertCommentItem:commentItem];
    }
}

//创建用户朋友圈
-(DFTextImageUserLineItem *)createUserLineItem:(T_MOMENTS_ARTICLE_DTO *)article_dto

{
    static NSUInteger _currentYear;
    static NSUInteger _currentMonth;
    static NSUInteger _currentDay;
    
    DFTextImageUserLineItem *item = [[DFTextImageUserLineItem alloc] init];
    item.itemId = article_dto->article_id();
    item.ts = article_dto->create_time();
    if (article_dto->title()) {
        item.text = [NSString stringWithUTF8String:article_dto->title()->c_str()];
    }
    Moments_Content_Type type = (Moments_Content_Type)article_dto->content_type();
    if (type == Moments_Content_Type_TextImg) {
        NSString *content = @"";
        if (article_dto->content()) {
            content = [NSString stringWithUTF8String:article_dto->content()->c_str()];
        }
        NSArray *srcImages = [content componentsSeparatedByString:@"#"];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:5];
        for (NSString *src in srcImages) {
            if (IsStrEmpty(src)) {
                continue;
            }
            NSString *imageSrc = src;
            if (![imageSrc containsString:@"http"]&&![imageSrc containsString:@"https"]) {
                imageSrc = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,src);
            }
            [images addObject:imageSrc];
        }
        if (images.count>0) {
            item.cover = images.firstObject;
        }
        item.photoCount = images.count;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(item.ts/1000)];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
    item.year = year;
    item.month = month;
    item.day = day;
    
    if (year == _currentYear && month == _currentMonth && day == _currentDay) {
        item.bShowTime = NO;
    }else{
        item.bShowTime = YES;
    }
    _currentDay = day;
    _currentMonth = month;
    _currentYear = year;
    return item;
}

-(DFTextVideoUserLineItem *)createUserVideoLineItem:(T_MOMENTS_ARTICLE_DTO *)article_dto

{
    static NSUInteger _currentYear;
    static NSUInteger _currentMonth;
    static NSUInteger _currentDay;
    
    DFTextVideoUserLineItem *item = [[DFTextVideoUserLineItem alloc] init];
    item.itemId = article_dto->article_id();
    item.ts = article_dto->create_time();
    if (article_dto->title()) {
        item.text = [NSString stringWithUTF8String:article_dto->title()->c_str()];
    }
    Moments_Content_Type type = (Moments_Content_Type)article_dto->content_type();
    if (type == Moments_Content_Type_Video) {
        NSString *content = @"";
        if (article_dto->content()) {
            content = [NSString stringWithUTF8String:article_dto->content()->c_str()];
        }
        NSArray *srcImages = [content componentsSeparatedByString:@"#"];
        for (NSString *src in srcImages) {
            if (IsStrEmpty(src)) {
                continue;
            }
            NSString *imageSrc = src;
            if (![imageSrc containsString:@"http"]&&![imageSrc containsString:@"https"]) {
                imageSrc = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,src);
            }
            NSString *extension = [imageSrc pathExtension];
            NSString *realExtension = @"";
            if (![extension isEqualToString:@"vo"]) {
                realExtension = @"jpg";
                item.cover = imageSrc;
                NSString *filePath = [NSString stringWithFormat:@"%@%@.%@",DF_CACHEPATH, [DFToolUtil md5:imageSrc],realExtension];
                [[DFFileManager sharedInstance] saveFileToLocal:filePath url:imageSrc];
            } else {
                realExtension = @"mov";
            }
        }
        if (IsStrEmpty(item.cover)) {
            item.cover = content;
        }
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(item.ts/1000)];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
    item.year = year;
    item.month = month;
    item.day = day;
    
    if (year == _currentYear && month == _currentMonth && day == _currentDay) {
        item.bShowTime = NO;
    }else{
        item.bShowTime = YES;
    }
    _currentDay = day;
    _currentMonth = month;
    _currentYear = year;
    return item;
}

@end
