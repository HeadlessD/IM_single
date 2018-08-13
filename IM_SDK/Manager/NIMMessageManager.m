//
//  NIMMessageManager.m
//  qbnimclient
//
//  Created by 秦雨 on 17/12/9.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMMessageManager.h"

@implementation NIMMessageManager
SingletonImplementation(NIMMessageManager)

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.chatDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.chatListDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operateMessage:) name:NC_MESSAGE_OP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operateChatList:) name:NC_CHATLIST_OP object:nil];

    }
    
    return self;
}

-(NSInteger)indexOfMessage:(ChatEntity *)message
{
    NSInteger index = -1;
    NSArray *arr = [self.chatDict objectForKey:message.messageBodyId];
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dict = [arr objectAtIndex:i];
        if ([dict objectForKey:@(message.messageId)]) {
            return i;
        }
    }
    return index;
}

-(void)insertMessageList:(NSArray *)messageList messageBodyId:(NSString *)messageBodyId
{
    NSMutableArray *chatArr = [NSMutableArray arrayWithArray:[self.chatDict objectForKey:messageBodyId]];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:10];
    for (ChatEntity *message in messageList) {
        NSDictionary *tmpDict = @{@(message.messageId):message};
        [tmpArr addObject:tmpDict];
    }
    [chatArr insertObjects:tmpArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tmpArr.count)]];
    [self.chatDict setObject:chatArr forKey:messageBodyId];
}

-(NSInteger)addMessage:(ChatEntity *)message
{
    BOOL isAdd = YES;
    NSDictionary *tmpDict = @{@(message.messageId):message};
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:[self.chatDict objectForKey:message.messageBodyId]];
    if (tmpArr.count >0) {
        for (NSDictionary *dict in tmpArr) {
            if ([dict objectForKey:@(message.messageId)]) {
                isAdd = NO;
                break;
            }
        }
        if (isAdd) {
            [tmpArr addObject:tmpDict];
        }else{
            return -1;
        }
    }else{
        [tmpArr addObject:tmpDict];
    }
    
    [self.chatDict setObject:tmpArr forKey:message.messageBodyId];
    
    return tmpArr.count-1;
}


-(NSArray *)getMessageWithSessionid:(NSString *)messageBodyId Offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSArray *messages = [ChatEntity NIM_executeFetchRequest:[NSPredicate predicateWithFormat:@"messageBodyId = %@",messageBodyId] fetchOffset:offset fetchLimit:limit];
    messages = [[messages reverseObjectEnumerator] allObjects];
    return messages;
}

-(void)addMessageList:(NSArray *)messageList messageBodyId:(NSString *)messageBodyId
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:[self.chatDict objectForKey:messageBodyId]];
    for (ChatEntity *message in messageList) {
        NSDictionary *tmpDict = @{@(message.messageId):message};
        if (tmpArr.count >0) {
            [tmpArr addObject:tmpDict];
        }else{
            [tmpArr addObject:tmpDict];
        }
    }
    [self.chatDict setObject:tmpArr forKey:messageBodyId];

}

-(NSArray *)getMessagesBySessionId:(NSString *)messageBodyId
{
    NSArray *tmpArr = [self.chatDict objectForKey:messageBodyId];
    return tmpArr;
}

-(ChatEntity *)searchMessageWithMsgId:(int64_t)msgid messageBodyId:(NSString *)messageBodyId
{
    ChatEntity *message = nil;
    NSArray *tmpArr = [self.chatDict objectForKey:messageBodyId];
    for (NSDictionary *tmpDict in tmpArr) {
        if ([tmpDict objectForKey:@(msgid)]) {
            message = [tmpDict objectForKey:@(msgid)];
            break;
        }
    }
    
    return message;
}

-(void)removeMessageByMsgId:(int64_t)msgid messageBodyId:(NSString *)messageBodyId
{
    NSMutableArray *tmpArr = [self.chatDict objectForKey:messageBodyId];
    if (tmpArr == nil) {
        return;
    }
    for (NSDictionary *tmpDict in tmpArr) {
        if ([tmpDict objectForKey:@(msgid)]) {
            [tmpArr removeObject:tmpDict];
            break;
        }
    }
    [self.chatDict setObject:tmpArr forKey:messageBodyId];
}


-(void)removeAllMessageBy:(NSString *)messageBodyId
{
    [self.chatDict removeObjectForKey:messageBodyId];
}

-(void)updateMessage:(ChatEntity *)message isPost:(BOOL)isPost isChange:(BOOL)isChange
{
    NSMutableArray *tmpArr = [self.chatDict objectForKey:message.messageBodyId];
    NSInteger index = -1;
    if (tmpArr == nil ||
        tmpArr.count==0) {
        return ;
    }
    for (int i = 0; i<tmpArr.count; i++) {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary: tmpArr[i]];
        int64_t msgid = message.messageId;
        if ([tmpDict objectForKey:@(msgid)]) {
            index = i;
            [tmpDict setObject:message forKey:@(msgid)];
            [tmpArr replaceObjectAtIndex:i withObject:tmpDict];
            break;
        }
    }
    [self.chatDict setObject:tmpArr forKey:message.messageBodyId];
    
    if (isPost) {
        NIMMessage_OP_Type type = NIMMessage_OP_Type_UPDATE;
        if (isChange) {
            type = NIMMessage_OP_Type_RELOAD;
        }
        NSDictionary *dict = @{@"type":@(type),
                               @"index":@(index),
                               @"messageBodyId":message.messageBodyId
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SELF_MESSAGE_OP_UI object:dict];
        
    }
}

-(void)operateMessage:(NSNotification *)noti
{
    id object = noti.object;
    if (object) {
        ChatEntity *chatEntity = object;
        NSInteger index =  [self addMessage:chatEntity];
        
        if (index == -1) {
            return;
        }
        
        NSDictionary *dict = @{@"type":@(NIMMessage_OP_Type_ADD),
                               @"index":@(index),
                               @"messageBodyId":chatEntity.messageBodyId,
                               };
        if (chatEntity.isSender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SELF_MESSAGE_OP_UI object:dict];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP_UI object:dict];
        }
    }
    
}


//登录后传入
-(BOOL)addChatList:(NSArray *)chatList
{
    for (ChatListEntity *chatListEntity in chatList) {
        [self.chatListDict setObject:chatListEntity forKey:chatListEntity.messageBodyId];
        NSArray *messages = [self getMessageWithSessionid:chatListEntity.messageBodyId Offset:0 limit:20];
        [self addMessageList:messages messageBodyId:chatListEntity.messageBodyId];
    }
    
    return YES;
}

-(void)removeChatList:(NSString *)messageBodyId
{
    [self.chatListDict removeObjectForKey:messageBodyId];
}

//更新或者写入单条数据
-(void)updateChatList:(ChatListEntity *)chatListEntity
{
    [self.chatListDict setObject:chatListEntity forKey:chatListEntity.messageBodyId];
}

-(ChatListEntity *)getChatListEntity:(NSString *)messageBodyId
{
    ChatListEntity *chatList = nil;
    if ([self.chatListDict objectForKey:messageBodyId]) {
        chatList = [self.chatListDict objectForKey:messageBodyId];
    }
    return chatList;
}


-(void)operateChatList:(NSNotification *)noti
{
    id object = noti.object;
    if (object) {
        ChatListEntity *chatListEntity = object;
        [self updateChatList:chatListEntity];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_CHATLIST_OP_UI object:chatListEntity.messageBodyId];
    }
    
}

@end
