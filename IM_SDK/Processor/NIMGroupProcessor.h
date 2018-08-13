//
//  NIMGroupProcessor.h
//  qbim
//
//  Created by 秦雨 on 17/2/13.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMBaseProcessor.h"
#import "NetCenter.h"
#import "NIMGroupStruct.h"

@interface NIMGroupProcessor : NIMBaseProcessor

//获取群ID列表
-(void)sendGroupidListRQWithIndex:(int32_t)index;

//获取群列表
-(void)sendGroupListRQWithindex:(int32_t)index;

//获取群群成员
-(void)sendGroupMemberRQ:(int64_t)groupid index:(int32_t)index complete:(CompleteBlock)complete;
//获取群详情
-(void)sendGroupScan:(int64_t)groupid shareid:(int64_t)shareid;
-(void)sendBatchGroupInfoRQ:(NSArray *)groupids;
//建群
-(void)sendGroupCreateRQ:(QBCreateGroup *)group;

//群操作
-(void)sendGroupKickUsers:(NSArray *)userInfos groupid:(int64_t)groupid;
-(void)sendGroupAddUserinfos:(NSArray *)userInfos groupid:(int64_t)groupid opUserid:(int64_t)opUserid oldMsgid:(int64_t)oldMsgid reason:(id)reason;
-(void)sendInviteAgreeWithType:(int32_t)type groupid:(int64_t)groupid;

-(void)sendLeaderChangeUserid:(int64_t)opUserid groupid:(int64_t)groupid;;

-(void)changeGroupInfo:(int64_t)groupid content:(NSString *)content type:(GROUP_CHAT_OFFLINE_TYPE)type;
//获取群公告详情
-(void)fetchGroupRemarkDetail:(int64_t)groupid;
//群消息状态
-(void)sendGroupMessageStatue:(int64_t)groupid status:(GROUP_MESSAGE_STATUS)status;
//群类型
-(void)sendGroupTypeListRQ;
//获取我在群里昵称
-(void)sendMemberNameRQ:(int64_t)groupid;
//群保存状态
-(void)sendGroupSave:(int64_t)groupid status:(NIM_GROUP_SAVE_TYPE)status;

@end
