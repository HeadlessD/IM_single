//
//  NIMGroupOperationBox.m
//  qbim
//
//  Created by 秦雨 on 17/2/17.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMGroupOperationBox.h"
#import "NIMGlobalProcessor.h"
#import "NIMMessageCenter.h"
#import "NIMGroupUserIcon.h"
#import "GMember+CoreDataClass.h"
#import "RemarkEntity+CoreDataClass.h"
@implementation NIMGroupOperationBox
SingletonImplementation(NIMGroupOperationBox)

-(void)recvGroupidList:(NSArray *)groupids
{
    NSPredicate *pre= [NSPredicate predicateWithFormat:@"memberid == %lld AND type != %d",OWNERID,NIM_INGROUP_STATUS_BANNED];
    NSArray *arr = [GroupList NIM_findAllWithPredicate:pre];
    NSMutableArray *source = [NSMutableArray array];
    for (GroupList *item in arr)
    {
        [source addObject:@(item.groupId)];
    }
    for (NSNumber *groupid in source) {
        if (![groupids containsObject:groupid]) {
            [GroupList NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"groupId=%lld AND memberid=%lld", [groupid longLongValue],OWNERID]];
            NSPredicate*predicate=[NSPredicate predicateWithFormat:@"messageBodyId = %@",[NIMStringComponents createMsgBodyIdWithType:GROUP  toId:[groupid longLongValue]]];
            //删除所有不该存在本机的recordlist消息
            [ChatListEntity NIM_deleteAllMatchingPredicate:predicate];
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}
-(void)recvGroupList:(NSArray *)groupArr complete:(CompleteBlock)complete
{
    NSLog(@"群列表：%@",groupArr);
    NSArray*groupIdArrray=[groupArr valueForKey:@"groupId"];
    
    //将服务器传来的数据不包含群列表,从本地删除
    
    NSMutableArray*threadArray=[NSMutableArray arrayWithCapacity:groupArr.count];
    for (id groupId in groupIdArrray) {
        NSString*thread=[NIMStringComponents createMsgBodyIdWithType:GROUP  toId:[groupId longLongValue]];
        [threadArray addObject:thread];
    }
    
    
    if (threadArray.count==0) {//说明服务端没有群,删掉本地所有的群,然后那个群成员也会被删除
        [GroupList NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"groupId != %d AND memberid=%lld",0,OWNERID]];
        
        NSPredicate*predicate=[NSPredicate predicateWithFormat:@"chatType = %@ AND userId=%lld",@(GROUP),OWNERID];
        //删出所有群的recordlist消息
        [ChatListEntity NIM_deleteAllMatchingPredicate:predicate];
    }
    
    else
    {
        //删除那些不该存在本地的群列表
        [GroupList NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"(NOT(messageBodyId in %@)) AND memberid=%lld",threadArray,OWNERID]];
        
        NSPredicate*predicate=[NSPredicate predicateWithFormat:@"chatType = %d AND (NOT(messageBodyId in %@)) AND userId=%lld",GROUP,threadArray,OWNERID];
        //删除所有不该存在本机的recordlist消息
        [ChatListEntity NIM_deleteAllMatchingPredicate:predicate];
    }
    
    [groupArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *groupDic = obj;
        int64_t groupid = [[groupDic objectForKey:@"groupId"]longLongValue];
        
        GroupList *groupList = [GroupList instancetypeFindGroupId:groupid];
        if (groupList==nil) {
            groupList = [GroupList instancetypeWithJsonDic:groupDic];
        }
        [[NIMSysManager sharedInstance].groupShowDict setObject:@(YES) forKey:@(groupList.groupId)];
        groupList.membercount = [[groupDic objectForKey:@"count"] integerValue];
        groupList.ownerid = [[groupDic objectForKey:@"manager"] longLongValue];
        groupList.remark = [groupDic objectForKey:@"groupRemark"];
        groupList.relation = [[groupDic objectForKey:@"isAgree"] boolValue];
    }];
    
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
    complete(groupArr,nil);
//    //获取群离线
//    NSMutableArray *offlines = [NSMutableArray arrayWithCapacity:10];
//
//    for (int i=0; i<groupIdArrray.count; i++) {
//        int64_t groupid = [groupIdArrray[i] longLongValue];
//        QBGroupOfflineBody *body = [[QBGroupOfflineBody alloc] initWithNextMsgId:0 groupid:groupid];
//        [offlines addObject:body];
//    }
//    [self fetchGroupOffline:offlines];
}

#pragma mark - 修改群成员
-(void)recvGroupMember:(QBGroupListPacket *)group iconBlock:(CompleteBlock)iconBlock completeBlock:(CompleteBlock)completeBlock
{
    if (iconBlock) {
        completeBlock(group,nil);
        return;
    }
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    [privateContext performBlock:^{
        int64_t groupid = group.group_id;
        GroupList *groupList = [GroupList instancetypeFindGroupId:groupid];
        
        NSArray *members = nil;
        if (group.groupList.count) {//members改为items
            members = group.groupList;
        }
        if (members && members.count) {
            if (group.pack_id==0) {
                [groupList removeMembers:groupList.members];
            }
            [members enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *dic = obj;
                
                GMember *memberEntity = [GMember instancetypeWithMemberDic:dic group:groupList];
                if (memberEntity.userid == OWNERID) {
                    groupList.selfcard = memberEntity.showName;
                }
                if (memberEntity.userid == groupList.ownerid) {
                    memberEntity.ct = groupList.ct*1000;
                }
                
                if (![groupList.members containsObject:memberEntity]) {
                    [groupList addMembersObject:memberEntity];
                }
            }];
        }
        //TODO:save
        [privateContext MR_saveToPersistentStoreAndWait];
        completeBlock(group,nil);
    }];
    
}



-(void)fetchGroupOffline:(NSArray *)groupOfflines
{
    //获取离线
    NSArray *tmpArr = @[].copy;
    NSMutableArray *offlines = [NSMutableArray arrayWithCapacity:10];

    if (groupOfflines.count>10) {
        tmpArr = [NIMBaseUtil splitArray:groupOfflines withSubSize:10];
    }else{
        tmpArr = groupOfflines;
    }
    
    for (NSNumber *ngroupid in tmpArr) {
        int64_t groupid = ngroupid.longLongValue;
        int64_t msgid = [getObjectFromUserDefault(_IM_FormatStr(@"%@_lateid",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid])) longLongValue];
        QBGroupOfflineBody *body = [[QBGroupOfflineBody alloc] initWithNextMsgId:msgid==0?0:msgid+1 groupid:groupid];
        [offlines addObject:body];
    }
    if (offlines.count>0) {
        QBGroupOffline *offline = [[QBGroupOffline alloc] init];
        offline.user_id = OWNERID;
        offline.session_id = [NIMBaseUtil getPacketSessionID];
        offline.groupOfflines = [NSMutableArray arrayWithArray:offlines];
        [[NIMGlobalProcessor sharedInstance].offline_msg_processor sendGroupOfflineMessageRQ:offline];
    }
}

-(void)fetchOffcialOffline:(NSArray *)Offcialids
{
    //获取离线
    NSMutableArray *offlines = [NSMutableArray arrayWithCapacity:10];
    

    for (NSNumber *noffcialid in Offcialids) {
        int64_t offcialid = noffcialid.longLongValue;
        int64_t msgid = [getObjectFromUserDefault(_IM_FormatStr(@"%@_lateid",[NIMStringComponents createMsgBodyIdWithType:PUBLIC toId:offcialid])) longLongValue];
        QBOffcialOfflineBody *body = [[QBOffcialOfflineBody alloc] initWithNextMsgId:msgid offcialid:offcialid];
        [offlines addObject:body];
    }
    if (offlines.count>0) {
        QBOffcialOffline *offline = [[QBOffcialOffline alloc] init];
        offline.user_id = OWNERID;
        offline.session_id = [NIMBaseUtil getPacketSessionID];
        offline.offcialOfflines = [NSMutableArray arrayWithArray:offlines];
        [[NIMGlobalProcessor sharedInstance].offline_msg_processor sendOffcialOfflineMessageRQ:offline];
    }
    
}

-(void)fetchFansOffline
{
    [[NIMGlobalProcessor sharedInstance].offline_msg_processor sendFansOfflineMessageRQ];
}

-(void)fetchSysOffline
{
    [[NIMGlobalProcessor sharedInstance].offline_msg_processor fetchSysOfflineMessage];
}


-(void)createGroupWithContacts:(NSArray *)friendids withNames:(NSArray *)userNames
{
    QBCreateGroup *create = [[QBCreateGroup alloc] init];
    NSMutableArray *infoList = [NSMutableArray arrayWithCapacity:5];
    NSMutableString * nameStr = [[NSMutableString alloc] init];
    NSUInteger nameCount = userNames.count<=4?userNames.count:4;
    for (int i=0; i<nameCount; i++) {
        NSString *username = userNames[i];
        [nameStr appendString:username];
        if (i<nameCount-1) {
            [nameStr appendString:@"、"];
        }
    }
    [nameStr appendString:@"的群"];

    for (int i=0; i<friendids.count; i++) {
        QBUserBaseInfo *userInfo = [[QBUserBaseInfo alloc] init];
        userInfo.user_id = [friendids[i] longLongValue];
        userInfo.user_nick_name = userNames[i];
        [infoList addObject:userInfo];
    }
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userNames forKey:@"userNames"];
    [user synchronize];
    if (nameStr.length>30) {
        nameStr = [NSMutableString stringWithFormat:@"%@...",[nameStr substringToIndex:27]];
    }
    create.group_name = nameStr;
    create.user_info_list = infoList;
    create.group_ct = [NIMBaseUtil GetServerTime]/1000;
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupCreateRQ:create];
}


#pragma mark - 修改群成员
-(void)recvCreateGroupWithResponse:(QBGroupCreatePacket *)group
{
    NSArray *items = group.user_id_list;
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    NSMutableSet *newMemberSet = [NSMutableSet set];
    int64_t message_id = group.message_id;
    int64_t groupid      = group.group_id;
    NSString *name      = group.group_name;
    NSString *thread    = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid];
    int64_t ct      = group.group_ct;
    GroupList *groupEntity = [GroupList instancetypeFindGroupId:groupid];
    if (groupEntity) {
        return ;
    }
    __block NSString *selfCard = nil;
    
    VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:OWNERID];
    groupEntity = [GroupList NIM_createEntity];
    groupEntity.messageBodyId = thread;
    groupEntity.groupId = groupid;
    groupEntity.avatar = GROUP_ICON_URL(groupid);
    groupEntity.name = name;
    groupEntity.allFullLitter = [PinYinManager getAllFullPinyinString:name];
    groupEntity.ownerid = OWNERID;
    groupEntity.showname = YES;
    groupEntity.switchnotify = GROUP_MESSAGE_STATUS_NORMAL;
    groupEntity.ct = ct;
    groupEntity.capacity=group.group_max_count;
    [groupEntity addMembers:newMemberSet];
    groupEntity.selfcard=IsStrEmpty(selfCard)?[vcardEntity defaultName]:selfCard;
    groupEntity.savedwitch=NO;
    groupEntity.relation = NO;
    groupEntity.membercount = group.group_count;
    groupEntity.remark = group.group_remark;
    groupEntity.memberid = OWNERID;
    groupEntity.addMax = group.group_add_max_count;
    [[NIMSysManager sharedInstance].groupShowDict setObject:@(YES) forKey:@(groupid)];
    
    NSMutableArray* muarray = @[].mutableCopy;
    NSMutableString * nameStr = [[NSMutableString alloc] init];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = obj;
        int64_t userid = [[dict objectForKey:@"userId"] longLongValue];
        
        IMGroupRoleType type = (IMGroupRoleType)[[dict objectForKey:@"memberType"] integerValue];
        VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:[[obj objectForKey:@"userId"] longLongValue]];
        
        GMember *memberEntity = [GMember instancetypeFindUserid:userid group:groupEntity];
        
        if (!memberEntity) {
            memberEntity = [GMember NIM_createEntity];
            memberEntity.userid = userid;
            memberEntity.group = groupEntity;
        }
        memberEntity.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid];
        memberEntity.userid = userid;
        memberEntity.ct = [NIMBaseUtil GetServerTime];
        memberEntity.role = type;
        memberEntity.vcard = vcardEntity;
        NSString *priorName = nil;
        NSString *nickname = [dict objectForKey:@"memberNickName"];
        
        FDListEntity *fd = [FDListEntity instancetypeFindFriendId:userid];
        if (!IsStrEmpty(fd.fdRemarkName)) {
            priorName = fd.fdRemarkName;
        }else{
            priorName = IsStrEmpty(nickname)?vcardEntity.defaultName:nickname;
        }
        if (![memberEntity.showName isEqualToString:priorName]) {
            memberEntity.showName = priorName;
            memberEntity.fullLitter = [PinYinManager getFullPinyinString:priorName];
            memberEntity.allFullLitter = [PinYinManager getAllFullPinyinString:priorName];
            
        }
        if (![memberEntity.fLitter isEqualToString:[PinYinManager getFirstLetter:priorName]]) {
            memberEntity.fLitter = [PinYinManager getFirstLetter:priorName];
        }
        memberEntity.groupmembernickname = nickname;
        memberEntity.groupIndex = [[dict objectForKey:@"index"] integerValue];
        [newMemberSet addObject:memberEntity];
        
        if (userid!=OWNERID) {
            [nameStr appendString:priorName];
            if (idx<items.count-1) {
                [nameStr appendString:@"、"];
            }
        }else{
            selfCard = priorName;
        }
        if (idx<9) {
            if (memberEntity.userid==groupEntity.ownerid) {
                [muarray insertObject:USER_ICON_URL(memberEntity.userid) atIndex:0];
            }else{
                [muarray addObject:USER_ICON_URL(memberEntity.userid)];
            }
        }
    }];
    NIMGroupUserIcon *icon = [[NIMGroupUserIcon alloc] initWithFrame:CGRectZero];
    [icon setViewDataSource:muarray groupId:groupid];
    
    ChatEntity *recordEntity = [ChatEntity NIM_createEntity];
    [recordEntity setIsSender:YES];
    [recordEntity setGroupId:groupid];
    [recordEntity setMessageBodyId:groupEntity.messageBodyId];
    [recordEntity setMessageId:message_id];
    [recordEntity setChatType:GROUP];
    //        [recordEntity setSender:ownerid;
    //        [recordEntity setReceiver:groupEntity.groupId];
    
    [recordEntity setCt:ct];
    [recordEntity setMtype:JSON];
    [recordEntity setStype:TIP];
    NSString *preTip = [NSString stringWithFormat:@"你邀请了\"%@\"加入群聊",nameStr];
    TextEntity *textEntity = [TextEntity NIM_createEntity];
    [textEntity setText:preTip];
    [recordEntity setTextFile:textEntity];
    NSDictionary *jsonD = @{@"desc":preTip,@"groupid":[NSNumber numberWithDouble:groupid]};
    
    DBLog(@"%@",jsonD);
    NSString *json = [NIMUtility jsonStringWithDictionary:jsonD];
    [recordEntity setMsgContent:json];
    
    [recordEntity setCt:ct];
    [recordEntity setStatus:QIMMessageStatuNormal];
    [recordEntity setUnread:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP object:recordEntity];

    ChatListEntity *recordList = [ChatListEntity findFirstWithMessageBodyId:thread];
    if (recordList == nil) {
        recordList = [ChatListEntity NIM_createEntity];
    }
    [recordList setUserId:OWNERID];
    [recordList setMessageBodyId:groupEntity.messageBodyId];
    [recordList setChatType:recordEntity.chatType];
    [recordList setCt:ct];
    [recordList setPreview:preTip];
    [recordList setBadge:0];
    [recordList setIsflod:0];
    [recordList setMessageBodyIdType:None];
    [recordList setTopAlign:NO];
    [recordList setShowRedPublic:0];
    recordList.actualThread = groupEntity.messageBodyId;
    //TODO:save
    [privateContext MR_saveToPersistentStoreAndWait];
    
    //通知
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_CREATE_GROUP object:groupEntity];
    
    
}



-(void)sendGroupMemberRQ:(int64_t)groupid complete:(CompleteBlock)complete
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupMemberRQ:groupid index:0 complete:complete];
}

-(void)sendGroupScan:(int64_t)groupid shareid:(int64_t)shareid
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupScan:groupid shareid:shareid];
}

-(void)sendBatchGroupInfoRQ:(NSArray *)groupids;
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendBatchGroupInfoRQ:groupids];
}

-(void)recvGroupDetailInfo:(NSArray *)groupInfos isMember:(BOOL)isMember
{
    
    [groupInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QBGroupInfoPacket *groupInfo = obj;
        GroupList *groupList = [GroupList instancetypeFindGroupId:groupInfo.group_id];
        if (groupList==nil) {
            groupList = [GroupList NIM_createEntity];
            groupList.groupId = groupInfo.group_id;
            groupList.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:GROUP  toId:groupInfo.group_id];
            groupList.avatar = GROUP_ICON_URL(groupInfo.group_id);
            groupList.memberid = OWNERID;
            groupList.showname = YES;
        }
        if ([[NIMSysManager sharedInstance].relationDict objectForKey:@(groupInfo.group_id)]) {
            NSDictionary *tmpdict = [[NIMSysManager sharedInstance].relationDict objectForKey:@(groupInfo.group_id)];
            groupList.switchnotify = [[tmpdict objectForKey:@"status"] integerValue];
            groupList.savedwitch = [[tmpdict objectForKey:@"type"] integerValue];
        }
        groupList.ct = groupInfo.group_ct;
        groupList.addMax = groupInfo.group_add_max_count;
        groupList.capacity = groupInfo.group_max_count;
        groupList.membercount = groupInfo.group_count;
        groupList.name = groupInfo.group_name;
        groupList.allFullLitter = [PinYinManager getAllFullPinyinString:groupInfo.group_name];
        groupList.ownerid = groupInfo.group_manager_user_id;
        groupList.relation = groupInfo.group_add_is_agree;
        groupList.remark = groupInfo.group_remark;
        [[NIMSysManager sharedInstance].groupShowDict setObject:@(YES) forKey:@(groupInfo.group_id)];
        
        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    }];

}

-(void)sendGroupKickUsers:(NSArray *)users groupid:(int64_t)groupid{
    
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupKickUsers:users groupid:groupid];
}

-(void)sendGroupAddUserinfos:(NSArray *)userInfos groupid:(int64_t)groupid opUserid:(int64_t)opUserid oldMsgid:(int64_t)oldMsgid reason:(id)reason
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupAddUserinfos:userInfos groupid:groupid opUserid:opUserid oldMsgid:oldMsgid reason:reason];

}

-(void)sendInviteAgreeWithType:(int32_t)type groupid:(int64_t)groupid
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendInviteAgreeWithType:type groupid:groupid];
}

-(void)changeGroupInfo:(int64_t)groupid content:(NSString *)content type:(GROUP_CHAT_OFFLINE_TYPE)type
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor changeGroupInfo:groupid content:content type:type];
}


-(void)recvGroupModifyChangeRQWithResponse:(QBGroupOfflinePacket *)group
{
    
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    ChatEntity* chatEntity = [ChatEntity findFirstWithMessageId:group.message_id];
    if (chatEntity) {
        return ;
    }
    QBGroupOperatePacket *op = group.groupOperate;
    
    int32_t type = group.big_msg_type;
    int64_t groupid = group.group_id;
    int32_t group_count  = group.group_count;
    int64_t msg_time = op.msg_time;
    NSString *msgBodyId = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid];
    E_MSG_M_TYPE mType = JSON;
    E_MSG_S_TYPE sType = TIP;
    NSString *content = nil;
    NSString *reason = nil;
    NSString *sendUserName = nil;
    
    GroupList *groupEntity = [GroupList instancetypeFindGroupId:groupid];
    if (groupEntity==nil) {
        groupEntity = [GroupList NIM_createEntity];
        groupEntity.groupId = groupid;
        groupEntity.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid];
        groupEntity.name = group.group_name;
        groupEntity.allFullLitter = [PinYinManager getAllFullPinyinString:group.group_name];
        groupEntity.ct = msg_time;
        groupEntity.savedwitch = NO;
        groupEntity.showname = YES;
        groupEntity.avatar = GROUP_ICON_URL(groupid);
        groupEntity.memberid = OWNERID;
        groupEntity.capacity = group.group_max_count;
        groupEntity.addMax = group.group_add_max_count;
    }
    if (group_count!=0) {
        groupEntity.membercount = group_count;
    }
    if (group.group_manager_user_id!=0) {
        groupEntity.ownerid = group.group_manager_user_id;
    }
    if (groupEntity.type == NIM_INGROUP_STATUS_BANNED) {
        groupEntity.type = NIM_INGROUP_STATUS_NORMAL;
    }
    [[NIMSysManager sharedInstance].groupShowDict setObject:@(groupEntity.showname) forKey:@(groupid)];
    
    BOOL isFetchMember = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_Member_Fetch(groupid)];
    
    //踢人、主动退群
    if (type == GROUP_OFFLINE_CHAT_KICK_USER) {
        NSArray *users = op.user_info_list;
        if (users.count==0) {
            return ;
        }
        NSSortDescriptor *indexDesc = [NSSortDescriptor sortDescriptorWithKey:@"ct" ascending:YES];
        NSArray *members=[groupEntity.members.allObjects sortedArrayUsingDescriptors:@[indexDesc]];
        __block BOOL isUpdate = NO;
        __block int64_t opdUserid = 0;
        __block BOOL isMe = NO;
        NSMutableString * nameStr = [[NSMutableString alloc] init];
        [users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            QBUserBaseInfo *user = obj;
            opdUserid = user.user_id;
            GMember *member = [GMember instancetypeFindUserid:user.user_id group:groupEntity];
            NSInteger index = [members indexOfObject:member];
            if (index<9) {
                isUpdate = YES;
            }
            if (member) {
                [member NIM_deleteEntity];
                [groupEntity removeMembersObject:member];
            }
            if (user.user_id == OWNERID) {
                opdUserid = OWNERID;
                isMe = YES;
                //主动退群
                if (group.user_id==OWNERID) {
                    [GroupList NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"groupId=%lld AND memberid=%lld", groupid,OWNERID]];
                    NSPredicate*predicate=[NSPredicate predicateWithFormat:@"messageBodyId = %@",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]];
                    //删除所有不该存在本机的recordlist消息
                    [ChatListEntity NIM_deleteAllMatchingPredicate:predicate];
                    [privateContext MR_saveToPersistentStoreAndWait];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_EXIT_GROUP object:@(groupid)];
                    removeObjectFromUserDefault(KEY_Member_Index(groupid));
                }else{
                    //被踢
                    groupEntity.type = NIM_INGROUP_STATUS_BANNED;
                    removeObjectFromUserDefault(KEY_Member_Index(groupid));
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_KICKET_GROUP object:@(groupid)];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
                }
                return;
            }
            
            NSString *username = [self getPriorNameWithGroup:groupEntity userid:user.user_id];
            if (IsStrEmpty(username)) {
                username = user.user_nick_name;
            }
            [nameStr appendString:username];
            if (idx<users.count-1) {
                [nameStr appendString:@"、"];
            }
        }];
        
        //自己退群
        if (isMe && group.user_id == OWNERID) {
            removeObjectFromUserDefault(KEY_Member_Fetch(groupid));
            removeObjectFromUserDefault(_IM_FormatStr(@"%@_lateid",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]));
            return;
        }
        
        NSString *firstName = nil;
        //被踢
        if (isMe) {
            removeObjectFromUserDefault(KEY_Member_Fetch(groupid));
            removeObjectFromUserDefault(_IM_FormatStr(@"%@_lateid",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]));
            firstName = [self getPriorNameWithGroup:groupEntity userid:group.user_id];
            content = [NSString stringWithFormat:@"\"%@\"将你移出了群聊",firstName];
        }else{
            if (group.user_id == OWNERID) {
                content = [NSString stringWithFormat:@"你将\"%@\"移出了群聊",nameStr];
            }
            //                else{
            //                    firstName = [self getPriorNameWithGroup:groupEntity userid:group.user_id];
            //                }
            //                if (group.user_id == opdUserid) {
            //                    //content = [NSString stringWithFormat:@"%@退出群聊",firstName];
            //                }else{
            //                    content = [NSString stringWithFormat:@"%@将%@踢出群",firstName,nameStr];
            //                }
        }
        
        
        msg_time = op.msg_time;
        
        //群主更新群头像
        if (group.group_manager_user_id == OWNERID) {
            if (isFetchMember) {
                NSInteger tmpcount = group_count>9?9:group_count;
                if (tmpcount<9||isUpdate) {
                    [self updateGroupIcon:groupEntity count:tmpcount];
                    
                }
            }else{
                
                [self setupGroupIcon:groupid];
            }
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_MODIFY object:group];
        
    }
    
    
    //邀请进群、扫码进群
    if (type == GROUP_OFFLINE_CHAT_ADD_USER) {
        
        NSArray *users = op.user_info_list;
        if (users.count==0) {
            
            //进群需群主同意
            if (group.message_old_id) {
                ChatEntity* chatEn = [ChatEntity findFirstWithMessageId:group.message_old_id];
                if (chatEn) {
                    chatEn.stype = GROUP_ADD_AGREE;
                    [privateContext MR_saveToPersistentStoreAndWait];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_ENTER_AGREE object:@(group.message_old_id)];
                    
                }
                
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_ADD object:group];
            return ;
        }
        if (group.message_old_id) {
            ChatEntity* chatEn = [ChatEntity findFirstWithMessageId:group.message_old_id];
            if (chatEn) {
                chatEn.stype = GROUP_ADD_AGREE;
                [privateContext MR_saveToPersistentStoreAndWait];
                [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_ENTER_AGREE object:@(group.message_old_id)];
                
            }
        }
        NSMutableString * nameStr = [[NSMutableString alloc] init];
        
        __block BOOL isMe = NO;
        [users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#pragma mark - 修改群成员
            
            QBUserBaseInfo *user = obj;
            
            GMember *memberEntity = [GMember instancetypeFindUserid:user.user_id group:groupEntity];
            
            if (!memberEntity) {
                memberEntity = [GMember NIM_createEntity];
                memberEntity.userid = user.user_id;
                memberEntity.group = groupEntity;
            }
            VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:user.user_id];
            memberEntity.messageBodyId = groupEntity.messageBodyId;
            memberEntity.userid = user.user_id;
            memberEntity.ct = [NIMBaseUtil GetServerTime];
            memberEntity.role = IMGroupRoleTypeNone;
            NSString *priorName = nil;
            NSString *nickname = user.user_nick_name;
            
            FDListEntity *fd = [FDListEntity instancetypeFindFriendId:user.user_id];
            if (!IsStrEmpty(fd.fdRemarkName)) {
                priorName = fd.fdRemarkName;
            }else{
                priorName = IsStrEmpty(nickname)?vcardEntity.defaultName:nickname;
            }
            if (![memberEntity.showName isEqualToString:priorName]) {
                memberEntity.showName = priorName;
                memberEntity.fullLitter = [PinYinManager getFullPinyinString:priorName];
                memberEntity.allFullLitter = [PinYinManager getAllFullPinyinString:priorName];
                
            }
            if (![memberEntity.fLitter isEqualToString:[PinYinManager getFirstLetter:priorName]]) {
                memberEntity.fLitter = [PinYinManager getFirstLetter:priorName];
            }
            memberEntity.groupmembernickname = nickname;
            memberEntity.groupIndex = user.user_group_index;
            memberEntity.vcard = vcardEntity;
            [groupEntity addMembersObject:memberEntity];
            NSString *username = [self getPriorNameWithGroup:groupEntity userid:user.user_id];
            if (IsStrEmpty(username)) {
                username = user.user_nick_name;
            }
            if (user.user_id == OWNERID) {
                isMe = YES;
                if (users.count>1) {
                    [nameStr insertString:@"你、" atIndex:0];
                    
                }else{
                    [nameStr insertString:@"你" atIndex:0];
                }
                
            }else{
                [nameStr appendString:username];
            }
            if (idx<users.count-1) {
                if (user.user_id != OWNERID) {
                    [nameStr appendString:@"、"];
                }
            }
            
            
        }];
        
        //扫码主动进群
        QBUserBaseInfo *userInfo = users[0];
        
        NSString *firstName = [self getPriorNameWithGroup:groupEntity userid:group.user_id];
        
        if (group.user_id==userInfo.user_id) {
            if (IsStrEmpty(firstName)) {
                firstName = userInfo.user_nick_name;
            }
            content = [NSString stringWithFormat:@"\"%@\"通过扫描二维码加入群聊",firstName];
        }else{
            if (group.user_id == OWNERID) {
                firstName = @"你";
            }
            if (IsStrEmpty(firstName)) {
                firstName = [NSString stringWithFormat:@"\"%@\"",group.groupOperate.operate_user_name];
            }
            NSString *secName = isMe?@"你":[NSString stringWithFormat:@"\"%@\"",nameStr];
            content = [NSString stringWithFormat:@"%@邀请%@加入群聊",firstName,secName];
        }
        msg_time = op.msg_time;
        
        //更新群头像
        BOOL isUpdate = group_count-users.count<9;
        if (group.user_id == OWNERID) {
            NSInteger tmpcount = group_count>9?9:group_count;
            if (isFetchMember) {
                if (isUpdate) {
                    
                    [self updateGroupIcon:groupEntity count:tmpcount];
                }
            }else{
                if (isUpdate) {
                    [self setupGroupIcon:groupid];
                }
            }
        }
        
        
        if (group.user_id==OWNERID) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_ADD object:group];
        }
        
    }
    
    if (type == GROUP_OFFLINE_CHAT_SCAN_ADD_USER) {
        
        NSArray *users = op.user_info_list;
        if (users.count==0) {
            return ;
        }
        [users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            QBUserBaseInfo *user = obj;
            
            GMember *memberEntity = [GMember instancetypeFindUserid:user.user_id group:groupEntity];
            
            if (!memberEntity) {
                memberEntity = [GMember NIM_createEntity];
                memberEntity.userid = user.user_id;
                memberEntity.group = groupEntity;
            }
            VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:user.user_id];
            memberEntity.messageBodyId = groupEntity.messageBodyId;
            memberEntity.userid = user.user_id;
            memberEntity.ct = [NIMBaseUtil GetServerTime];;
            memberEntity.role = IMGroupRoleTypeNone;
            NSString *priorName = nil;
            NSString *nickname = user.user_nick_name;
            
            FDListEntity *fd = [FDListEntity instancetypeFindFriendId:user.user_id];
            if (!IsStrEmpty(fd.fdRemarkName)) {
                priorName = fd.fdRemarkName;
            }else{
                priorName = IsStrEmpty(nickname)?vcardEntity.defaultName:nickname;
            }
            if (![memberEntity.showName isEqualToString:priorName]) {
                memberEntity.showName = priorName;
                memberEntity.fullLitter = [PinYinManager getFullPinyinString:priorName];
                memberEntity.allFullLitter = [PinYinManager getAllFullPinyinString:priorName];
                
            }
            if (![memberEntity.fLitter isEqualToString:[PinYinManager getFirstLetter:priorName]]) {
                memberEntity.fLitter = [PinYinManager getFirstLetter:priorName];
            }
            memberEntity.groupmembernickname = nickname;
            memberEntity.groupIndex = user.user_group_index;
            memberEntity.vcard = vcardEntity;
            [groupEntity addMembersObject:memberEntity];
            
        }];
        
        //扫码主动进群
        QBUserBaseInfo *userInfo = users[0];
        
        NSString *opName = [self getPriorNameWithGroup:groupEntity userid:group.user_id];
        NSString *beName = [self getPriorNameWithGroup:groupEntity userid:userInfo.user_id];
        
        if (group.user_id==OWNERID) {
            content = [NSString stringWithFormat:@"\"%@\"通过扫描你分享的二维码加入群聊",beName];
        }else{
            if (userInfo.user_id == OWNERID) {
                content = @"你通过扫描二维码加入群聊";
            }else{
                content = [NSString stringWithFormat:@"\"%@\"通过扫描\"%@\"分享的二维码加入群聊",beName,opName];
            }
        }
        msg_time = op.msg_time;
        
        //更新群头像
        BOOL isUpdate = group_count-users.count<9;
        if (userInfo.user_id == OWNERID) {
            NSInteger tmpcount = group_count>9?9:group_count;
            if (isFetchMember) {
                if (isUpdate) {
                    
                    [self updateGroupIcon:groupEntity count:tmpcount];
                }
            }else{
                if (isUpdate) {
                    [self setupGroupIcon:groupid];
                }
            }
        }
        if (userInfo.user_id==OWNERID) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_ADD object:group];
        }
    }
    
    
    if (type == GROUP_OFFLINE_CHAT_LEADER_CHANGE) {
        NSArray *users = op.user_info_list;
        if (users.count==0) {
            return ;
        }
        QBUserBaseInfo *userInfo = users[0];
        int64_t opdUserid = userInfo.user_id;
        NSString *username = [self getPriorNameWithGroup:groupEntity userid:opdUserid];
        if (IsStrEmpty(username)) {
            username = userInfo.user_nick_name;
        }
        content = [NSString stringWithFormat:@"\"%@\"已成为新群主",opdUserid==OWNERID?@"你":username];
        msg_time = op.msg_time;
        groupEntity.ownerid = opdUserid;
        if (group.user_id==OWNERID) {
            if (isFetchMember) {
                NSInteger tmpcount = groupEntity.membercount;
                tmpcount = tmpcount>9?9:tmpcount;
                [self updateGroupIcon:groupEntity count:tmpcount];
            }else{
                [self setupGroupIcon:groupid];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUPLEADERCHANGE object:@(groupid)];
        
    }
    if (type == GROUP_OFFLINE_CHAT_ENTER_AGREE) {
        QBGroupOperatePacket *op = group.groupOperate;
        content = @"群主已启用 “群聊邀请确认”，群成员需群主确认才能邀请朋友进群";
        msg_time = op.msg_time;
        groupEntity.relation = group.group_add_is_agree;
        
    }
    if (type == GROUP_OFFLINE_CHAT_ENTER_DEFAULT) {
        QBGroupOperatePacket *op = group.groupOperate;
        content = @"群主已恢复默认进群方式。";
        msg_time = op.msg_time;
        groupEntity.relation = group.group_add_is_agree;
        
    }
    if (type == GROUP_OFFLINE_CHAT_ADD_USER_AGREE) {
        
        NSArray *users = op.user_info_list;
        if (users.count==0) {
            return ;
        }
        NSMutableArray *userids = [NSMutableArray arrayWithCapacity:5];
        NSMutableString * nameStr = [[NSMutableString alloc] init];
        for (int i=0; i<users.count; i++) {
            QBUserBaseInfo *user = users[i];
            NSDictionary *dict = @{@"userid":@(user.user_id),@"nick":user.user_nick_name};
            [userids addObject:dict];
            NSString *username = [self getPriorNameWithGroup:groupEntity userid:user.user_id];
            if (IsStrEmpty(username)) {
                username = user.user_nick_name;
            }
            [nameStr appendString:username];
            if (i<users.count-1) {
                [nameStr appendString:@"、"];
            }
            
        }
        NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:userids options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        sendUserName = str;
        VcardEntity *card = [VcardEntity instancetypeFindUserid:group.user_id];
        content = [NSString stringWithFormat:@"\"%@\"想邀请%@进入群聊",[card defaultName],nameStr];
        sType = GROUP_NEED_AGREE;
        groupEntity.relation = group.group_add_is_agree;
        if (!IsStrEmpty(op.group_modify_content)) {
            reason = op.group_modify_content;
        }
    }
    if (type == GROUP_OFFLINE_CHAT_CREATE) {
        
        NSArray *users = op.user_info_list;
        if (users.count==0) {
            return ;
        }
        NSMutableString * nameStr = [[NSMutableString alloc] init];
#pragma mark - 修改群成员
        
        for (int i=0; i<users.count; i++) {
            QBUserBaseInfo *user = users[i];
            
            VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:user.user_id];
            if (vcardEntity==nil) {
                vcardEntity = [VcardEntity NIM_createEntity];
                vcardEntity.userid = user.user_id;
                vcardEntity.userName = user.user_nick_name;
            }
            GMember *memberEntity = [GMember instancetypeFindUserid:user.user_id group:groupEntity];
            if (!memberEntity) {
                memberEntity = [GMember NIM_createEntity];
                memberEntity.userid = user.user_id;
                memberEntity.group = groupEntity;
            }
            memberEntity.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid];
            memberEntity.userid = user.user_id;
            memberEntity.ct = [NIMBaseUtil GetServerTime];;
            memberEntity.vcard = vcardEntity;
            
            NSString *priorName = nil;
            NSString *nickname = user.user_nick_name;
            
            FDListEntity *fd = [FDListEntity instancetypeFindFriendId:user.user_id];
            if (!IsStrEmpty(fd.fdRemarkName)) {
                priorName = fd.fdRemarkName;
            }else{
                priorName = IsStrEmpty(nickname)?vcardEntity.defaultName:nickname;
            }
            if (![memberEntity.showName isEqualToString:priorName]) {
                memberEntity.showName = priorName;
                memberEntity.fullLitter = [PinYinManager getFullPinyinString:priorName];
                memberEntity.allFullLitter = [PinYinManager getAllFullPinyinString:priorName];
            }
            if (![memberEntity.fLitter isEqualToString:[PinYinManager getFirstLetter:priorName]]) {
                memberEntity.fLitter = [PinYinManager getFirstLetter:priorName];
            }
            memberEntity.groupmembernickname = [vcardEntity defaultName];
            memberEntity.groupIndex = user.user_group_index;
            [groupEntity addMembersObject:memberEntity];
            
            if (user.user_id==group.user_id) {
                continue;
            }
            
            NSString *username = [self getPriorNameWithGroup:groupEntity userid:user.user_id];
            if (IsStrEmpty(username)) {
                username = user.user_nick_name;
            }
            
            if (user.user_id == OWNERID) {
                
                if (users.count>2) {
                    [nameStr insertString:@"你、" atIndex:0];
                }else{
                    [nameStr insertString:@"你" atIndex:0];
                }
                
            }else{
                [nameStr appendString:username];
            }
            
            if (i<users.count-1) {
                if (user.user_id != OWNERID) {
                    [nameStr appendString:@"、"];
                }
            }
            
            
            
        }
        if (![nameStr isEqualToString:@"你"]) {
            nameStr = [NSMutableString stringWithFormat:@"\"%@\"",nameStr];
        }
        NSString *firstName = [self getPriorNameWithGroup:groupEntity userid:group.user_id];
        content = [NSString stringWithFormat:@"\"%@\"邀请%@加入群聊",firstName,nameStr];
        msg_time = op.msg_time;
        groupEntity.relation = group.group_add_is_agree;
    }
    if (type == GROUP_OFFLINE_CHAT_MODIFY_GROUP_NAME) {
        QBGroupOperatePacket *op = group.groupOperate;
        groupEntity.name = op.group_modify_content;
        groupEntity.allFullLitter = [PinYinManager getAllFullPinyinString:op.group_modify_content];
        [privateContext MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_NAME_MODIFY object:@(type)];
        if (group.user_id == OWNERID) {
            return;
        }else{
            NSString *firstName = [self getPriorNameWithGroup:groupEntity userid:group.user_id];
            content = [NSString stringWithFormat:@"\"%@\"修改群名为\"%@\"",firstName,op.group_modify_content];
        }
    }
    if (type == GROUP_OFFLINE_CHAT_MODIFY_GROUP_REMARK) {
        QBGroupOperatePacket *op = group.groupOperate;
        groupEntity.remark = op.group_modify_content;
        int64_t userid = group.user_id;
        //            NSArray *users = op.user_info_list;
        //            if (users.count>0) {
        //                QBUserBaseInfo *user = users[0];
        //                userid = user.user_id;
        //            }
        RemarkEntity *remarkEntity = [RemarkEntity instancetypeFindgroupid:groupid];
        if (IsStrEmpty(op.group_modify_content)) {
            if (remarkEntity) {
                [remarkEntity NIM_deleteEntity];
                [privateContext MR_saveToPersistentStoreAndWait];
                [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_REMARK_MODIFY object:op];
            }
            return;
        }
        if (!remarkEntity) {
            remarkEntity = [RemarkEntity NIM_createEntity];
            remarkEntity.groupid = groupid;
        }
        remarkEntity.userid = userid;
        remarkEntity.content = op.group_modify_content;
        remarkEntity.ct = op.msg_time;
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_REMARK_MODIFY object:op];
        
        content = @"群主更新了群公告";
    }
    if (type == GROUP_OFFLINE_CHAT_MODIFY_GROUP_USER_NAME) {
        QBGroupOperatePacket *op = group.groupOperate;
        if (group.user_id == OWNERID) {
            groupEntity.selfcard = op.group_modify_content;
            GMember *member = [GMember instancetypeFindUserid:group.user_id group:groupEntity];
            if (member) {
                member.groupmembernickname = op.group_modify_content;
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_GROUP_NAME_MODIFY object:@(type)];
            
        }else{
            GMember *member = [GMember instancetypeFindUserid:group.user_id group:groupEntity];
            if (member) {
                member.groupmembernickname = op.group_modify_content;
            }
        }
        [privateContext MR_saveToPersistentStoreAndWait];
        return;
        
    }
    if (IsStrEmpty(content)) {
        [privateContext MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
        return;
    }
    chatEntity = [ChatEntity NIM_createEntity];
    [chatEntity setMessageBodyId:msgBodyId];
    [chatEntity setMessageId:group.message_id];
    [chatEntity setChatType:GROUP];
    [chatEntity setMtype:mType];
    [chatEntity setStatus:QIMMessageStatuNormal];
    [chatEntity setGroupId:groupid];
    [chatEntity setUserId:OWNERID];
    if (!IsStrEmpty(sendUserName)) {
        [chatEntity setSendUserName:sendUserName];
    }
    [chatEntity setIsSender:YES];
    [chatEntity setCt:msg_time];
    //        [chatEntity setOpUserId:opdUserid];
    [chatEntity setStype:sType];
    if (type == GROUP_OFFLINE_CHAT_ADD_USER_AGREE) {
        [chatEntity setMsgContent:reason];
        [chatEntity setOpUserId:group.user_id];
    }else{
        [chatEntity setMsgContent:content];
    }
    [chatEntity setUnread:NO];
    TextEntity *textEntity = [TextEntity NIM_createEntity];
    [textEntity setText:content];
    [chatEntity setTextFile:textEntity];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP object:chatEntity];
    //        if (type == GROUP_OFFLINE_CHAT_MODIFY_GROUP_REMARK) {
    //            if (group.user_id == OWNERID) {
    //                [[NIMMessageCenter sharedInstance] sendMessage:chatEntity];
    //            }
    //        }
    if (type != GROUP_OFFLINE_CHAT_CREATE) {
        [ChatListEntity instancetypeWithMessageBodyId:chatEntity isRemind:NO];
    }
    [privateContext MR_saveToPersistentStoreAndWait];
}


-(void)exitGroup:(int64_t)groupid
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupKickUsers:@[@(OWNERID)] groupid:groupid];
}

-(void)recvExitGroup:(int64_t)groupid isSelf:(BOOL)isSelf
{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    [GroupList NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"groupId=%lld AND memberid=%lld", groupid,OWNERID]];
    NSPredicate*predicate=[NSPredicate predicateWithFormat:@"messageBodyId = %@",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]];
    //删除所有不该存在本机的recordlist消息
    [ChatListEntity NIM_deleteAllMatchingPredicate:predicate];
    [privateContext MR_saveToPersistentStoreAndWait];
    if (isSelf) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_EXIT_GROUP object:@(groupid)];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}


-(void)sendLeaderChangeUserid:(int64_t)opUserid groupid:(int64_t)groupid
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendLeaderChangeUserid:opUserid groupid:groupid];
}




- (void)swithTop:(BOOL)top withGroupMsgBodyId:(NSString *)msgBodyId{
    NSString *mbd = nil;
    NSArray *array = [msgBodyId componentsSeparatedByString:@":"];
    mbd = msgBodyId;
    if (array.count==4) {
        mbd = [NSString stringWithFormat:@"%@:%@:%@",array[0],array[1],array[2]];
    }
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    ChatListEntity *chatList = [ChatListEntity findFirstWithMessageBodyId:mbd];
    if (chatList==nil) {
        chatList = [ChatListEntity NIM_createEntity];
        chatList.messageBodyId = mbd;
        chatList.actualThread = msgBodyId;
        chatList.chatType = [NIMStringComponents chatTypeWithMsgBodyId:msgBodyId];
        chatList.ct = [NIMBaseUtil GetServerTime]/1000;
        chatList.userId = OWNERID;
        //默认设为0
        chatList.groupAssistantRead = 0;
        chatList.preview = @"";
    }
    
    if(chatList.topAlign != top)
    {
        chatList.topAlign = top;
        //TODO:save
        [privateContext MR_saveOnlySelfAndWait];
    }
    //TODO:save
    [privateContext MR_saveToPersistentStoreAndWait];
}

- (void)swithMsgNotify:(BOOL)msgNoitfy withGroupMsgBodyId:(NSString *)msgBodyId{
    
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    ChatListEntity *chatList = [ChatListEntity findFirstWithMessageBodyId:msgBodyId];
    if (chatList==nil) {
        chatList = [ChatListEntity NIM_createEntity];
        chatList.messageBodyId = msgBodyId;
        chatList.actualThread = msgBodyId;
        chatList.chatType = [NIMStringComponents chatTypeWithMsgBodyId:msgBodyId];
        chatList.ct = [NIMBaseUtil GetServerTime]/1000;
        chatList.userId = OWNERID;
        //默认设为0
        chatList.groupAssistantRead = 0;
        chatList.preview = @"";
    }
    [chatList setApnswitch:msgNoitfy];
    //TODO:save
    [privateContext MR_saveToPersistentStoreAndWait];
}

-(void)fetchGroupRemarkDetail:(int64_t)groupid
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor fetchGroupRemarkDetail:groupid];

}
#pragma mark - 修改群成员

-(NSString *)getPriorNameWithGroup:(GroupList *)groupEntity userid:(int64_t)userid
{
    NSString *priorName = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(messageBodyId = %@) AND (userid = %@)",groupEntity.messageBodyId,@(userid)];
    FDListEntity *fd = [FDListEntity instancetypeFindFriendId:userid];
    GMember *member = [GMember NIM_findFirstWithPredicate:predicate];
    VcardEntity *card = [VcardEntity instancetypeFindUserid:userid];
    
    
    if (!IsStrEmpty(fd.fdRemarkName)) {
        priorName = fd.fdRemarkName;
    }else{
        if (member) {
            priorName = IsStrEmpty([member groupmembernickname])? card.defaultName:[member groupmembernickname];
        }
    }
    if (IsStrEmpty(priorName)) {
        priorName = card.defaultName;
    }
    
    return priorName;
}


-(void)updateGroupIcon:(GroupList *)groupEntity count:(NSInteger)count
{
    if (count>groupEntity.members.count) {
        return;
    }
    NSSortDescriptor *indexDesc = [NSSortDescriptor sortDescriptorWithKey:@"ct" ascending:YES];
    
    NSMutableArray* muarray = @[].mutableCopy;
    for(NSInteger i=0;i<count;i++)
    {
        GMember* m = (GMember*)[[groupEntity.members.allObjects sortedArrayUsingDescriptors:@[indexDesc] ]objectAtIndex:i];
        
        NSString *avatar = USER_ICON_URL(m.userid);
        if (m.userid==groupEntity.ownerid) {
            [muarray insertObject:avatar atIndex:0];
        }else{
            [muarray addObject:avatar];
        }
    }
    NIMGroupUserIcon *icon = [[NIMGroupUserIcon alloc] init];
    [icon setViewDataSource:muarray groupId:groupEntity.groupId];
}

-(void)setupGroupIcon:(int64_t)groupid
{
    [[NIMGroupOperationBox sharedInstance] sendGroupMemberRQ:groupid complete:^(id object, NIMResultMeta *result) {
        
        if (object) {
            NSArray *members = object;
            NSUInteger cnt = members.count>=9?9:members.count;
            if (cnt==0) {
                return ;
            }
            
            NSMutableArray *iconArr = [NSMutableArray arrayWithCapacity:10];
            
            for (int i=0; i<cnt; i++) {
                NSDictionary *dict = [members objectAtIndex:i];
                int64_t memberid = [[dict objectForKey:@"userId"] longLongValue];
                [iconArr addObject:USER_ICON_URL(memberid)];
                
            }
            NIMGroupUserIcon *icon = [[NIMGroupUserIcon alloc] init];
            [icon setViewDataSource:iconArr groupId:groupid];
        }
    }];
}


-(void)sendGroupMessageStatue:(int64_t)groupid status:(GROUP_MESSAGE_STATUS)status
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupMessageStatue:groupid status:status];

}

-(void)sendGroupTypeList
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupTypeListRQ];
}

-(void)sendMemberNameRQ:(int64_t)groupid
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendMemberNameRQ:groupid];
}

-(void)sendGroupSave:(int64_t)groupid status:(NIM_GROUP_SAVE_TYPE)status
{
    [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupSave:groupid status:status];
}

@end
