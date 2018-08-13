//
//  GroupManager.m
//  qbnimclient
//
//  Created by 秦雨 on 2017/12/15.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "GroupManager.h"



@implementation S_GROUP_INFO
@end
@implementation S_FD_INFO
@end
@implementation S_CHAT_LIST_INFO
@end

@implementation GroupManager
SingletonImplementation(GroupManager)

static NSString * const CLASS_NAME = @"GroupManager";


- (id)init
{
    self = [super init];
    _fd_info_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];
    _group_info_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];
    _chat_list_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];
    _member_info_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];
    return self;
}

- (void)dealloc
{
    
}

-(BOOL)LoadData
{
    NSLog(@"LoadData start");
    NSArray *fd_array = [FDListEntity MR_findAllInContext:[[NIMCoreDataManager currentCoreDataManager]privateObjectContext]];
    for (int index = 0; index < fd_array.count; ++index)
    {
        FDListEntity *fd_entity = fd_array[index];
        S_FD_INFO *s_fd_info = [[S_FD_INFO alloc] init];
        s_fd_info.fd_info = fd_entity;
        s_fd_info.is_readed_db = YES;
        [_fd_info_dic setObject:s_fd_info forKey:fd_entity.messageBodyId];
    }
    
    NSArray *group_array = [GroupList MR_findAllInContext:[[NIMCoreDataManager currentCoreDataManager]privateObjectContext]];
    for (int index = 0; index < group_array.count; ++index)
    {
        GroupList *group_list = group_array[index];
        S_GROUP_INFO *s_group_info = [[S_GROUP_INFO alloc] init];
        s_group_info.group_list = group_list;
        s_group_info.is_readed_db = YES;
        [_group_info_dic setObject:s_group_info forKey:group_list.messageBodyId];
    }
    
    NSArray *chat_array = [ChatListEntity MR_findAllInContext:[[NIMCoreDataManager currentCoreDataManager]privateObjectContext]];
    for (int index = 0; index < chat_array.count; ++index)
    {
        ChatListEntity *chat_list = chat_array[index];
        [_chat_list_dic setObject:chat_list forKey:chat_list.messageBodyId];
    }
    NSLog(@"LoadData end");
    return YES;
}

-(FDListEntity *)GetFDList:(int64_t)friendid
{
    NSString *message_body_id = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:friendid];
    S_FD_INFO *s_fd_info = [_fd_info_dic objectForKey: message_body_id];
    if(s_fd_info)
    {
        return s_fd_info.fd_info;
    }
    FDListEntity *fd_list = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld ",OWNERID,friendid]];
    s_fd_info = [[S_FD_INFO alloc] init];
    s_fd_info.fd_info = fd_list;
    s_fd_info.is_readed_db = YES;
    [_fd_info_dic setObject:s_fd_info forKey:message_body_id];
    return fd_list;
}

-(GroupList*) GetGroupList:(NSString*) message_body_id
{
    S_GROUP_INFO *s_group_info = [_group_info_dic objectForKey: message_body_id];
    if(s_group_info)
    {
        return s_group_info.group_list;
    }
    
    GroupList *group_list = [GroupList NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",message_body_id]];
    
    s_group_info = [[S_GROUP_INFO alloc] init];
    s_group_info.group_list = group_list;
    s_group_info.is_readed_db = YES;
    [_group_info_dic setObject:s_group_info forKey:message_body_id];
    
    return group_list;
}

-(ChatListEntity*) GetChatList:(NSString*) message_body_id chat_type:(E_MSG_CHAT_TYPE) chat_type
{
    ChatListEntity *chat_list = [_chat_list_dic objectForKey: message_body_id];
    if(chat_list)
    {
        return chat_list;
    }
    
    chat_list = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",message_body_id]];
    
    if(chat_list == nil)
    {
        chat_list = [ChatListEntity NIM_createEntity];
        chat_list.messageBodyId = message_body_id;
        chat_list.chatType = chat_type;
        chat_list.messageBodyIdType = None;
        chat_list.topAlign = NO;
    }
    
    [_chat_list_dic setObject:chat_list forKey:message_body_id];
    
    return chat_list;
}
/*
-(GMember*) GetMember:(int64_t) member_id group_id:(int64_t) group_id
{
    NSArray *member_list = [_member_info_dic objectForKey: group_id];
    
    if(chat_list)
    {
        return chat_list;
    }
    
    chat_list = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",message_body_id]];
    
    if(chat_list == nil)
    {
        chat_list = [ChatListEntity NIM_createEntity];
        chat_list.messageBodyId = message_body_id;
        chat_list.chatType = chat_type;
        chat_list.messageBodyIdType = None;
        chat_list.topAlign = NO;
    }
    
    [_chat_list_dic setObject:chat_list forKey:message_body_id];
    
    return chat_list;
}
*/
-(void) Clear
{
    [_fd_info_dic removeAllObjects];
    [_group_info_dic removeAllObjects];
    [_chat_list_dic removeAllObjects];
}

@end
