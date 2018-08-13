//
//  NIMGroupOperationBox.h
//  qbim
//
//  Created by 秦雨 on 17/2/17.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMGroupOperationBox : NSObject
SingletonInterface(NIMGroupOperationBox)

//TODO:获取群ID列表
-(void)recvGroupidList:(NSArray *)groupids;
//TODO:获取群列表
-(void)recvGroupList:(NSArray *)groupArr complete:(CompleteBlock)complete;
//TODO:获取群离线
-(void)fetchGroupOffline:(NSArray *)groupOfflines;
//TODO:获取群成员
-(void)sendGroupMemberRQ:(int64_t)groupid complete:(CompleteBlock)complete;
- (void)recvGroupMember:(QBGroupListPacket *)group iconBlock:(CompleteBlock)iconBlock completeBlock:(CompleteBlock)completeBlock;
//TODO:获取群详情
-(void)sendGroupScan:(int64_t)groupid shareid:(int64_t)shareid;
-(void)sendBatchGroupInfoRQ:(NSArray *)groupids;

- (void)recvGroupDetailInfo:(NSArray *)groupInfos isMember:(BOOL)isMember;
//TODO:创建群组 friends:由userid构成的array
- (void)createGroupWithContacts:(NSArray *)friendids withNames:(NSArray *)userNames;
-(void)recvCreateGroupWithResponse:(QBGroupCreatePacket *)group;
//TODO:群操作
-(void)sendGroupKickUsers:(NSArray *)users groupid:(int64_t)groupid;
-(void)sendGroupAddUserinfos:(NSArray *)userInfos groupid:(int64_t)groupid opUserid:(int64_t)opUserid oldMsgid:(int64_t)oldMsgid reason:(id)reason;
-(void)sendInviteAgreeWithType:(int32_t)type groupid:(int64_t)groupid;
-(void)changeGroupInfo:(int64_t)groupid content:(NSString *)content type:(GROUP_CHAT_OFFLINE_TYPE)type;
-(void)recvGroupModifyChangeRQWithResponse:(QBGroupOfflinePacket *)group;
//TODO:主动退群
-(void)exitGroup:(int64_t)groupid;
//群主转让
-(void)sendLeaderChangeUserid:(int64_t)opUserid groupid:(int64_t)groupid;
//置顶
- (void)swithTop:(BOOL)top withGroupMsgBodyId:(NSString *)msgBodyId;
//消息免打扰
- (void)swithMsgNotify:(BOOL)msgNoitfy withGroupMsgBodyId:(NSString *)msgBodyId;
//获取群公告详情
-(void)fetchGroupRemarkDetail:(int64_t)groupid;
//群消息状态
-(void)sendGroupMessageStatue:(int64_t)groupid status:(GROUP_MESSAGE_STATUS)status;
//群类型
-(void)sendGroupTypeList;
//获取我在群里昵称
-(void)sendMemberNameRQ:(int64_t)groupid;
//群保存状态
-(void)sendGroupSave:(int64_t)groupid status:(NIM_GROUP_SAVE_TYPE)status;
//公众号离线
-(void)fetchOffcialOffline:(NSArray *)Offcialids;
//获取粉丝
-(void)fetchFansOffline;
-(void)fetchSysOffline;
@end
