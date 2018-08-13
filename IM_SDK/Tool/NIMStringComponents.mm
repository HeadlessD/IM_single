//
//  StringComponents.m
//  qbim
//
//  Created by 豆凯强 on 17/2/8.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMStringComponents.h"
#import "NetCenter.h"
@implementation NIMStringComponents




+(NSString *)finFristNameWithID:(int64)userID{
    NSString * firstName = @"";
    FDListEntity * fdlist = [FDListEntity instancetypeFindAbsoluteFriendId:userID];
    if (fdlist.fdRemarkName) {
        firstName = fdlist.fdRemarkName;
    }else{
        VcardEntity * vcard = [VcardEntity instancetypeFindUserid:userID];
        firstName = [vcard defaultName];
    }
    return firstName;
}

+(NSString *)createMsgBodyIdWithType:(E_MSG_CHAT_TYPE)chatType toId:(int64_t)toId{

    NSMutableString *messageBody = [[NSMutableString alloc]init];
    [messageBody appendFormat:@"%ld",(long)chatType];
    [messageBody appendFormat:@":%lld",OWNERID];
    [messageBody appendFormat:@":%lld",toId];
    
    return messageBody;
}

+(NSString *)createMsgBodyIdWithType:(E_MSG_CHAT_TYPE)chatType fromId:(int64_t)fromId toId:(int64_t)toId{

    NSMutableString *messageBody = [[NSMutableString alloc]init];
    [messageBody appendFormat:@"%ld",(long)chatType];
    [messageBody appendFormat:@":%lld",OWNERID];
    [messageBody appendFormat:@":%lld",toId];
    
    return messageBody;
}


+(int64_t)getOpuseridWithMsgBodyId:(NSString *)msgBodyId
{
    NSArray *array = [msgBodyId componentsSeparatedByString:@":"];
    if(array.count >2){
        return [array.lastObject longLongValue];
    }
    return 0;
}


+ (E_MSG_CHAT_TYPE)chatTypeWithMsgBodyId:(NSString *)msgBodyId{
    NSArray *array = [msgBodyId componentsSeparatedByString:@":"];
    if(array.count >0){
        E_MSG_CHAT_TYPE type =  (E_MSG_CHAT_TYPE)[[array objectAtIndex:0] integerValue];
        return type;
    }
    return INVALID;
}

+(int64_t)createMessageid:(E_MSG_CHAT_TYPE)chatType
{
    int64_t msgid = [NIMBaseUtil GetServerTime];
    if (chatType == PRIVATE || chatType == SHOP_BUSINESS) {
        msgid = [[NetCenter sharedInstance] CreateMsgID];
    }else if (chatType == PUBLIC || chatType == CERTIFY_BUSINESS) {
        msgid = msgid/1000 << 1;
    }
    return msgid;
}

////客户端专用，不需要向服务器传值的
//+(E_MSG_CHAT_TYPE)businessChatTypeWithMsgBodyId:(NSString *)msgBodyId
//{
//    NSArray *array = [msgBodyId componentsSeparatedByString:@":"];
//    if(array.count >3){
//        E_MSG_CHAT_TYPE type =  [[array objectAtIndex:0] integerValue];
//        return type;
//    }else{
//        E_MSG_CHAT_TYPE type =  [[array objectAtIndex:0] integerValue];
//        type = type==SHOP_BUSINESS?PRIVATE:type;
//        return type;
//    }
//    return 0;
//}

+(void)createTipsWithMbd:(NSString *)mbd stype:(E_MSG_S_TYPE)stype friends:(NSArray *)friends
{
    
    __block NSString *tips = @"";
    NSMutableString * nameStr = [[NSMutableString alloc] init];
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:5];
    for (int i=0; i<friends.count; i++) {
        int64_t userid = [[friends objectAtIndex:i] longLongValue];
        
        FDListEntity *dfdList = nil;
        if (stype == TIP) {
            dfdList = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and fdBlackShip = %d",OWNERID,userid,FD_BLACK_PASSIVE_BLACK]];

        }else{
            dfdList = [FDListEntity instancetypeFindMUTUALFriendId:userid];
        }
        
        NSString *name = dfdList.defaultName;
        
        [nameStr appendString:name];
        if (i<friends.count-1) {
            [nameStr appendString:@"、"];
        }
        
        if (stype != TIP) {
            
            NSDictionary *dict = @{@"id":@(userid),
                                   @"name":name};
            [nameArr addObject:dict];
        }
    }
    if (stype == TIP) {
        tips = [NSString stringWithFormat:@"%@拒绝加入群聊",nameStr];
    }else{
        tips = [NSString stringWithFormat:@"请先发送好友验证申请给%@，对方将你加为好友后，才能邀请其加入群聊",nameStr];
    }
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    int64_t time = [NIMBaseUtil GetServerTime]/1000;
    ChatEntity * chatEntity = [ChatEntity NIM_createEntity];
    chatEntity.chatType = PRIVATE;
    chatEntity.userId = OWNERID;
    chatEntity.mtype = JSON;
    chatEntity.stype = stype;
    chatEntity.ct = time;
    chatEntity.isSender = YES;
    chatEntity.messageBodyId = mbd;
    chatEntity.messageId = [NIMBaseUtil GetServerTime];
    chatEntity.unread = NO;
    //        chatEntity.sendUserName = chat.sendUserName;
    chatEntity.opUserId = OWNERID;
    NSString *content = tips;
    TextEntity *textEntity = [TextEntity NIM_createEntity];
    textEntity.text = content;
    [chatEntity setTextFile:textEntity];
    if (nameArr.count>0) {
        
        NSDictionary *dict = @{@"fds":nameArr};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [chatEntity setMsgContent:str];
    }else{
        [chatEntity setMsgContent:content];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP object:chatEntity];
    ChatListEntity * chatList = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",chatEntity.messageBodyId]];
    if (chatList==nil) {
        chatList = [ChatListEntity NIM_createEntity];
        chatList.messageBodyId  = chatEntity.messageBodyId;
        chatList.chatType = PRIVATE;
        chatList.messageBodyIdType = None;
        chatList.topAlign = NO;
        chatList.userId = OWNERID;
        
    }
    chatList.ct = time;
    chatList.preview = content;
    [privateContext MR_saveToPersistentStoreAndWait];
    
}


+(void)createProductTipsWithMbd:(NSString *)mbd stype:(E_MSG_S_TYPE)stype content:(id)content
{
    
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    
    int64_t time = [NIMBaseUtil GetServerTime]/1000;
    if (stype == ORDER_TIP || stype == PRODUCT_TIP) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"stype = %d AND messageBodyId = %@",stype,mbd];
        ChatEntity *chat = [ChatEntity NIM_findFirstWithPredicate:pre];
        if (chat) {
            chat.ct = time;
            [[NIMMessageManager sharedInstance] updateMessage:chat isPost:YES isChange:NO];
            [privateContext MR_saveToPersistentStoreAndWait];
            return;
        }
    }
    ChatEntity * chatEntity = [ChatEntity NIM_createEntity];
    chatEntity.chatType = PRIVATE;
    chatEntity.userId = OWNERID;
    chatEntity.mtype = JSON;
    chatEntity.stype = stype;
    chatEntity.ct = time;
    chatEntity.isSender = YES;
    chatEntity.messageBodyId = mbd;
    chatEntity.messageId = [NIMBaseUtil GetServerTime];
    chatEntity.unread = NO;
    chatEntity.opUserId = OWNERID;
    int64_t bid = [NIMStringComponents getOpuseridWithMsgBodyId:mbd];
    
    if([[NIMSysManager sharedInstance].sidDict objectForKey:@(bid)]){
        int32_t sessionid = [[[NIMSysManager sharedInstance].sidDict objectForKey:@(bid)] unsignedIntValue];
        chatEntity.sid = sessionid;
    }
    NSString *contentStr = nil;
    if ([content isKindOfClass:[NSDictionary class]]) {
        contentStr = [NIMUtility jsonStringWithDictionary:content];
    }else{
        contentStr = content;
    }
    TextEntity *textEntity = [TextEntity NIM_createEntity];
    textEntity.text = contentStr;
    [chatEntity setTextFile:textEntity];
    [chatEntity setMsgContent:contentStr];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP object:chatEntity];
    [privateContext MR_saveToPersistentStoreAndWait];
}

+(void)deleteProductTipsWithMbd:(NSString *)mbd stype:(E_MSG_S_TYPE)stype
{
    
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"stype = %d AND messageBodyId = %@",stype,mbd];
    ChatEntity *chat = [ChatEntity NIM_findFirstWithPredicate:pre];
    if (chat) {
        [[NIMMessageManager sharedInstance] removeMessageByMsgId:chat.messageId messageBodyId:mbd];
        [chat NIM_deleteEntity];
        [privateContext MR_saveToPersistentStoreAndWait];
    }

}


+(NIM_SEARCH_TYPE)getSearchTypeWithFriends:(NSArray *)friends groups:(NSArray *)groups
{
    NIM_SEARCH_TYPE type = NIM_SEARCH_TYPE_NONE;
    if (friends.count>0 && groups.count>0) {
        type = NIM_SEARCH_TYPE_BOTH;
    }else if (friends.count>0){
        type = NIM_SEARCH_TYPE_FRIEND;
    }else if (groups.count>0){
        type = NIM_SEARCH_TYPE_GROUP;
    }else{
        
    }

    return type;
}

@end
