//
//  NIMPacket.m
//  QianbaoIM
//
//  Created by ssQINYU on 17/1/5.
//  Copyright © 2017年 qianbao.com. All rights reserved.
//

#import "NIMPacket.h"

@implementation NIMPacket
- (NSMutableDictionary *)compositeWithAttributes{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:@(self.user_id),@"userId",[NSNumber numberWithInt:self.pack_id],@"packId",[NSNumber numberWithInt:self.result],@"result",nil];
}
@end

@implementation QBUserInfoPacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    if (!IsStrEmpty(self.username)) {
        [dictionary setObject:self.username forKey:@"userName"];
    }
    if (!IsStrEmpty(self.avatarPic)) {
        [dictionary setObject:self.avatarPic forKey:@"avatarPic"];
    }
    
    if (!IsStrEmpty(self.avataStatus)) {
        [dictionary setObject:self.avataStatus forKey:@"avataStatus"];
    }
    
    if (!IsStrEmpty(self.avatarPic300)) {
        [dictionary setObject:self.avatarPic300 forKey:@"avatarPic300"];
    }
    
    if (!IsStrEmpty(self.mobile)) {
        [dictionary setObject:self.mobile forKey:@"mobile"];
    }
    if (!IsStrEmpty(self.nickName)) {
        [dictionary setObject:self.nickName forKey:@"nackName"];
    }
    
    [dictionary setObject:@(self.user_id) forKey:@"userId"];
    //[dictionary setObject:self.city forKey:@"city"];
    [dictionary setObject:self.province forKey:@"province"];
    
    return dictionary;
}
@end

@implementation QBLoginPacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    [dictionary setObject:[NSNumber numberWithInteger:self.ap_id] forKey:@"apId"];
    [dictionary setObject:[NSNumber numberWithInteger:self.platform] forKey:@"platform"];
    [dictionary setObject:[NSNumber numberWithInteger:self.net_type] forKey:@"netType"];
    [dictionary setObject:[NSNumber numberWithInteger:self.server_time] forKey:@"serverTime"];
    return dictionary;
}

@end

@implementation QBChatPacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    [dictionary setObject:@(self.ap_id) forKey:@"apId"];
    [dictionary setObject:@(self.session_id) forKey:@"sessionId"];
    [dictionary setObject:@(self.m_type) forKey:@"mtype"];
    [dictionary setObject:@(self.s_type) forKey:@"stype"];
    [dictionary setObject:@(self.ext_type) forKey:@"ext"];
    [dictionary setObject:@(self.chat_type) forKey:@"mt"];
    [dictionary setObject:@(self.isSender) forKey:@"isSender"];
    [dictionary setObject:@(self.msg_time) forKey:@"ct"];
    [dictionary setObject:@(self.message_id) forKey:@"messageId"];
    [dictionary setObject:self.msg_content forKey:@"msgContent"];
    if (!IsStrEmpty(self.send_user_name)) {
        [dictionary setObject:self.send_user_name forKey:@"sendUserName"];
    }
    
    return dictionary;
}

@end

@implementation QBSingleChatPacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    [dictionary setObject:@(self.op_user_id) forKey:@"opUserId"];
    [dictionary setObject:@(self.b_id) forKey:@"BID"];
    [dictionary setObject:@(self.c_id) forKey:@"CID"];
    [dictionary setObject:@(self.w_id) forKey:@"WID"];
    return dictionary;
}

@end

@implementation QBGroupChatPacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    [dictionary setObject:@(self.group_id) forKey:@"groupid"];
    [dictionary setObject:@(self.op_user_id) forKey:@"opUserId"];
    return dictionary;
}

@end

@implementation QBGroupInfoPacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    [dictionary setObject:@(self.group_id) forKey:@"groupId"];
    [dictionary setObject:@(self.group_count) forKey:@"count"];
    [dictionary setObject:@(self.group_manager_user_id) forKey:@"manager"];
    [dictionary setObject:@(self.group_add_is_agree) forKey:@"isAgree"];
    [dictionary setObject:@(self.group_max_count) forKey:@"maxCount"];
    [dictionary setObject:@(self.group_ct) forKey:@"ct"];
    [dictionary setObject:@(self.message_status) forKey:@"status"];
    [dictionary setObject:@(self.group_type) forKey:@"type"];
    [dictionary setObject:@(self.group_add_max_count) forKey:@"addMax"];

    if (!IsStrEmpty(self.group_img_url)) {
        [dictionary setObject:self.group_img_url forKey:@"groupImg"];
    }
    if (!IsStrEmpty(self.group_name)) {
        [dictionary setObject:self.group_name forKey:@"groupName"];
    }
    if (!IsStrEmpty(self.group_remark)) {
        [dictionary setObject:self.group_remark forKey:@"groupRemark"];
    }
    return dictionary;
}
@end


@implementation QBGroupCreatePacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    [dictionary setObject:self.user_id_list forKey:@"items"];
    [dictionary setObject:@(self.message_id) forKey:@"messageid"];
    return dictionary;
}
@end


@implementation QBGroupListPacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    [dictionary setObject:self.groupList forKey:@"items"];
    [dictionary setObject:@(self.group_id) forKey:@"groupId"];
    return dictionary;
}
@end

@implementation QBGroupModifyPacket

@end

@implementation QBGroupOfflinePacket



@end

@implementation QBGroupOperatePacket

@end


@implementation QBFriendInfoPacket
@end


@implementation NIMFriendPacket
@end


@implementation QBOffcialChatPacket
- (NSMutableDictionary *)compositeWithAttributes{
    NSMutableDictionary *dictionary = [super compositeWithAttributes];
    [dictionary setObject:@(self.offcialid) forKey:@"offcialid"];
    [dictionary setObject:@(self.b_id) forKey:@"BID"];
    [dictionary setObject:@(self.c_id) forKey:@"CID"];
    [dictionary setObject:@(self.w_id) forKey:@"WID"];
    return dictionary;
}

@end

