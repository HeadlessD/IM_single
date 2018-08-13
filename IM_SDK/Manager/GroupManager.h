//
//  GroupManager.h
//  qbnimclient
//
//  Created by 秦雨 on 2017/12/15.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupList+CoreDataClass.h"
@interface S_FD_INFO : NSObject
@property (nonatomic,assign) BOOL      is_readed_db;
@property (nonatomic,strong) FDListEntity *fd_info;
@end

@interface S_GROUP_INFO : NSObject
@property (nonatomic,assign) BOOL      is_readed_db;
@property (nonatomic,strong) GroupList *group_list;
@end

@interface S_CHAT_LIST_INFO : NSObject
@property (nonatomic,assign) BOOL      is_readed_db;
@property (nonatomic,strong) ChatListEntity *chat_list;
@end

@interface GroupManager : NSObject
@property (nonatomic,strong) NSMutableDictionary *fd_info_dic;
@property (nonatomic,strong) NSMutableDictionary *group_info_dic;
@property (nonatomic,strong) NSMutableDictionary *chat_list_dic;
@property (nonatomic,strong) NSMutableDictionary *member_info_dic;

SingletonInterface(GroupManager)

-(BOOL)LoadData;
-(FDListEntity *)GetFDList:(int64_t)friendid;
-(GroupList*) GetGroupList:(NSString*) message_body_id;
-(ChatListEntity*) GetChatList:(NSString*) message_body_id chat_type:(E_MSG_CHAT_TYPE) chat_type;
-(void)Clear;
@end
