//
//  ChatListEntity+CoreDataProperties.m
//  qbnimclient
//
//  Created by 秦雨 on 17/11/23.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "ChatListEntity+CoreDataProperties.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation ChatListEntity (CoreDataProperties)

+ (NSFetchRequest<ChatListEntity *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"ChatListEntity"];
}

@dynamic actualThread;
@dynamic apnswitch;
@dynamic badge;
@dynamic chatType;
@dynamic ct;
@dynamic groupAssistantRead;
@dynamic isflod;
@dynamic isPublic;
@dynamic messageBodyId;
@dynamic messageBodyIdType;
@dynamic preview;
@dynamic showRedPublic;
@dynamic sType;
@dynamic topAlign;
@dynamic userId;
@dynamic shopAssistantRead;

+ (instancetype)getRecordListByMessageBodyId:(NSString*)messageBodyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId=%@", messageBodyId];
    return [self NIM_findFirstWithPredicate:predicate];
}


+ (instancetype)findFirstWithMessageBodyId:(NSString*)messageBodyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId=%@ and userId = %lld", messageBodyId,OWNERID];
    return [self NIM_findFirstWithPredicate:predicate];
}

+(instancetype)instancetypeWithMessageBodyId:(ChatEntity *)chatEntity isRemind:(BOOL)isRemind
{
    NSString *mbd = nil;
    NSString *messageBodyId = chatEntity.messageBodyId;
    NSArray *array = [chatEntity.messageBodyId componentsSeparatedByString:@":"];
    if (array.count==4) {
        mbd = [NSString stringWithFormat:@"%@:%@:%@",array[0],array[1],array[2]];
    }
    ChatEntity* recordEntity = chatEntity;
    
    if (recordEntity == nil) {
        return nil;
    }
    
    
    E_MSG_CHAT_TYPE chatType = recordEntity.chatType;
    E_MSG_S_TYPE st = recordEntity.stype;
    E_MSG_M_TYPE ctt = recordEntity.mtype;
    
    
    
    NSMutableString *preview = [[NSMutableString alloc] init];
    
    
    ChatListEntity *recordListEntity = nil;

    //将收到的群消息或群通知存一分到recordlist
    NSString *message_body_id = IsStrEmpty(mbd)?messageBodyId:mbd;
    E_MSG_CHAT_TYPE chat_type = [NIMStringComponents chatTypeWithMsgBodyId:messageBodyId];
    recordListEntity = [[GroupManager sharedInstance] GetChatList: message_body_id chat_type:chat_type];
    recordListEntity.actualThread = messageBodyId;
    recordListEntity.ct = recordEntity.ct;
    recordListEntity.sType = st;
    recordListEntity.userId = OWNERID;
    //默认设为0
    recordListEntity.groupAssistantRead = 0;

    GroupList *groupList = [[GroupManager sharedInstance] GetGroupList:IsStrEmpty(mbd)?messageBodyId:mbd];

    UIApplicationState state = [SSIMBackgroundManager getApplicationState];//后台禁止震动，需要本地推送
    BOOL apnswitch = NO;
    
    switch (chatType) {
        case GROUP:
        {
            if (groupList) {
                apnswitch = groupList.switchnotify;
            }
        }
            break;
        case PRIVATE:
        {
            FDListEntity *fdListEntity = [[GroupManager sharedInstance] GetFDList:recordEntity.opUserId];
            if (fdListEntity) {
                apnswitch = fdListEntity.apnswitch;
            }
            
        }
            break;
            
        default:
            break;
    }
    if (isRemind) {
    
        static NSTimeInterval preTime;
        if (state != UIApplicationStateBackground) {
            NSTimeInterval nowTime;
            if (preTime==0) {
                preTime =  [NIMBaseUtil GetServerTime]/1000;
                nowTime = preTime;
            }else{
                nowTime = [NIMBaseUtil GetServerTime]/1000;
            }
            NSTimeInterval duration = nowTime - preTime;
            if (duration>=1000) {
                preTime = nowTime;
            }
            BOOL isNeed = duration>=1000 || duration == 0;
            if (!apnswitch&&
                ![[NIMSysManager sharedInstance].currentMbd isEqualToString:messageBodyId]&&
                isNeed) {
                
                NIM_MESSAGE_MODE m_medo =  [getObjectFromUserDefault(KEY_Message_Mode) integerValue];
                
                [self setupNotifyMode:m_medo];
                
            }
        }
        
    }
    
    recordListEntity.apnswitch = apnswitch;
    
    if (chatType == PUBLIC)
    {
        recordListEntity.showRedPublic = YES;
        recordListEntity.isPublic = YES;
        recordListEntity.isflod = YES;
    }
    else
    {
        recordListEntity.showRedPublic = 0;
        recordListEntity.isPublic = 0;
        recordListEntity.isflod = 0;
    }
    TextEntity *textEntity = recordEntity.textFile;
    
    NSString *m = textEntity.text;
    
    switch (ctt) {
        case TEXT:
        {
            //TextEntity *textEntity = recordEntity.textFile;
            [preview appendString:[m stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
            break;
        case ITEM:
        {
            //商品消息
            [preview appendString:@"[链接]"];
        }
            break;
            
        case SMILEY:
        {
            [preview appendString:@"[动态表情]"];
        }
            break;
        case IMAGE:
        {
            [preview appendString:@"[图片]"];
        }
            break;
        case VOICE:
        {
            [preview appendString:@"[声音]"];
        }
            break;
        case MAP:
        {
            [preview appendString:@"[地理位置]"];
        }
            break;
        case VIDEO:
        {
            [preview appendString:@"[小视频]"];
        }
            break;
        case JSON:
        {
            switch (st) {
                case CHAT:
                {
                    [preview appendString:@"[消息]"];
                    
                }
                    break;
                    
                case RED_PACKET:
                {
                    [preview appendString:@"[红包]"];
                }
                    break;
                case VCARD:
                {
                    //TODO:发送名片
                    [preview appendString:@"[名片]"];
                }
                    break;
                case ORDER:
                {
                    //订单消息
                    [preview appendString:@"[订单]"];
                }
                    break;
                case TIP:
                {
                    [preview appendString:m];
                }
                    break;
                case GROUP_NEED_AGREE:
                {
                    [preview appendString:m];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
    [recordListEntity setPreview:preview];
    
    
    if (state == UIApplicationStateBackground &&
        st != TIP &&
        st != GROUP_ADD_AGREE)
    {
        if (!apnswitch) {
            
            NSMutableString *body = [[NSMutableString alloc] init];
            
            switch (chatType) {
                case GROUP:
                {
                    NSString *idStr = [NSString stringWithFormat:@"%lld",groupList.groupId];
                    [body appendString:IsStrEmpty(groupList.name)?idStr:groupList.name];
                    [body appendString:@"："];
                    [body appendString:@"[消息]"];
                }
                    break;
                case PRIVATE:
                {
                    FDListEntity *fdListEntity = [[GroupManager sharedInstance] GetFDList:recordEntity.opUserId];
                    
                    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:recordEntity.opUserId];
                    
                    NSString *name = IsStrEmpty(fdListEntity.fdRemarkName)?[vcard defaultName]:fdListEntity.fdRemarkName;
                    
                    [body appendString:name];
                    [body appendString:@"："];
                    if (ctt == TEXT) {
                        preview = [[NSMutableString alloc] initWithString:@"[消息]"];
                    }
                    [body appendString:preview];
                }
                    
                    break;
                case PUBLIC:
                {
                    NOffcialEntity *offcialEntity = [NOffcialEntity findFirstWithOffcialid:recordEntity.offcialId];
                    
                    [body appendString:offcialEntity.name];
                    [body appendString:@"："];
                    [body appendString:@"[消息]"];
                }
                    break;
                case SHOP_BUSINESS:case CERTIFY_BUSINESS:
                {
                    int64_t bid = [NIMStringComponents getOpuseridWithMsgBodyId:recordEntity.messageBodyId];
                    NBusinessEntity *businessEntity = [NBusinessEntity instancetypeFindBid:bid];
                    NSString *name = IsStrEmpty(businessEntity.name)?@"钱宝商家":businessEntity.name;
                    [body appendString:name];
                    [body appendString:@"："];
                    if (ctt == TEXT) {
                        preview = [[NSMutableString alloc] initWithString:@"[消息]"];
                    }
                    [body appendString:preview];
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            [SSIMPushHelper scheduleLocalNotificationBody:body];
        }
    }
    //群助手
    if (chatType == GROUP)
    {
        
        GROUP_MESSAGE_STATUS isAss = groupList.switchnotify;
        if (isAss == GROUP_MESSAGE_IN_HELP_NO_HIT) {
            
            if (![NIMSysManager sharedInstance].isInAssistant && !recordEntity.isSender) {
                //只要有群消息过来，则设置为1
                recordListEntity.groupAssistantRead = 1;
                
                [[NIMOperationBox sharedInstance]makeGroupAssistantPacket:recordListEntity withUsePrivew:NO];
            }else{
                //只要有群消息过来，则设置为1
                
                BOOL isMe = recordEntity.opUserId == OWNERID;
                if (!isMe) {
                    NSString *name = groupList.name;
                    if (name.length>12) {
                        name = [NSString stringWithFormat:@"%@...：",[name substringToIndex:12]];
                    }else{
                        name = [NSString stringWithFormat:@"%@：",name];
                    }
                    [preview insertString:name atIndex:0];
                }
                
                [[NIMOperationBox sharedInstance]updateGroupAssistant:preview];
                
            }
            
        }
    }else if (chatType == PUBLIC && recordListEntity.isflod == YES)
    {
        [[NIMOperationBox sharedInstance] makePublicPacketShow:recordListEntity];
    }else if (chatType == SHOP_BUSINESS || chatType == CERTIFY_BUSINESS){
        
        recordListEntity.shopAssistantRead = 1;
        [[NIMOperationBox sharedInstance] makeShopAssistantPacketShow:recordListEntity isRevMsg:YES];
    }
    return recordListEntity;
}

//创建任务助手
+ (instancetype)instancetypeForTaskHelper{
    ChatListEntity *recordListEntity = [ChatListEntity findFirstWithMessageBodyId:kTaskHelperThread];
    if (recordListEntity == nil) {
        recordListEntity = [ChatListEntity NIM_createEntity];
        recordListEntity.messageBodyId = kTaskHelperThread;
        recordListEntity.actualThread = kTaskHelperThread;
        recordListEntity.ct = [NIMBaseUtil GetServerTime]/1000;
        recordListEntity.badge = 0;
        recordListEntity.chatType = SYS;
        recordListEntity.topAlign = NO;
        recordListEntity.messageBodyIdType = TaskHelper;
        recordListEntity.showRedPublic = NO;
        recordListEntity.isflod = NO;
    }
    recordListEntity.userId = OWNERID;
    NSString *taskPreview = @"任务好帮手，欢迎使用。";
    if (recordListEntity.badge > 0) {
        taskPreview =  [NSString stringWithFormat:@"还有%d个任务没有完成哦!",recordListEntity.badge];
    }
    recordListEntity.preview = taskPreview;
    return recordListEntity;
}

//创建订阅助手
+ (instancetype)instancetypeForSubscribeHelper{
    ChatListEntity *recordListEntity = [ChatListEntity findFirstWithMessageBodyId:kSubscribeThread];
    if (recordListEntity == nil) {
        recordListEntity = [ChatListEntity NIM_createEntity];
        recordListEntity.messageBodyId = kSubscribeThread;
        recordListEntity.actualThread = kSubscribeThread;
        recordListEntity.ct = [NIMBaseUtil GetServerTime]/1000;
        recordListEntity.badge = 0;
        recordListEntity.chatType = SYS;
        recordListEntity.topAlign = NO;
        recordListEntity.messageBodyIdType = SubscribeAssistant;
        recordListEntity.showRedPublic = NO;
        recordListEntity.isflod = NO;
    }
    recordListEntity.userId = OWNERID;
    NSString *taskPreview = @"集中管理已经订阅的公众号服务。";
    recordListEntity.preview = taskPreview;
    return recordListEntity;
}

//通过ChatListEntity来创建一个群通知
+ (instancetype)instancetypeForGroupAssistantPacket:(ChatListEntity*)list
{
    ChatListEntity *recordListEntity = [ChatListEntity  findFirstWithMessageBodyId:kGroupAssistantThread];
    if (recordListEntity == nil) {
        recordListEntity = [ChatListEntity NIM_createEntity];
        recordListEntity.messageBodyId = kGroupAssistantThread;//标识为群助手
        recordListEntity.chatType = SYS;
        recordListEntity.isflod = NO;
        recordListEntity.showRedPublic = NO;
        recordListEntity.userId = OWNERID;
        recordListEntity.topAlign = NO;
        recordListEntity.actualThread = kGroupAssistantThread;
        recordListEntity.messageBodyIdType = None;
        
    }
    if (list) {
        recordListEntity.ct = list.ct;
        recordListEntity.badge = list.badge;
        recordListEntity.preview = [list.preview copy];
    }else{
        recordListEntity.ct = [NIMBaseUtil GetServerTime]/1000;
    }
    return recordListEntity;
}


+ (instancetype)instancetypeForPublicPacket:(ChatListEntity *)list
{
    ChatListEntity *recordListEntity = [ChatListEntity  findFirstWithMessageBodyId:kPublicPacketThread];
    if (recordListEntity == nil) {
        recordListEntity = [ChatListEntity NIM_createEntity];
        recordListEntity.messageBodyId = kPublicPacketThread;
        recordListEntity.badge = 0;
        recordListEntity.chatType = PUBLIC;
        recordListEntity.isflod = NO;
        recordListEntity.showRedPublic = NO;
        recordListEntity.userId = OWNERID;
        recordListEntity.topAlign = NO;
        recordListEntity.isPublic = YES;
        recordListEntity.messageBodyIdType = None;
        
    }
    recordListEntity.actualThread = list.actualThread;
    recordListEntity.preview = list.preview;
    recordListEntity.showRedPublic = list.badge>0;
    recordListEntity.ct = list.ct;
    return recordListEntity;
}

+ (instancetype)instancetypeForShopAssistantPacket:(ChatListEntity*)list
{
    ChatListEntity *recordListEntity = [ChatListEntity  findFirstWithMessageBodyId:kShopThread];
    if (recordListEntity == nil) {
        recordListEntity = [ChatListEntity NIM_createEntity];
        recordListEntity.messageBodyId = kShopThread;
        recordListEntity.chatType = SYS;
        recordListEntity.isflod = NO;
        recordListEntity.showRedPublic = NO;
        recordListEntity.userId = OWNERID;
        recordListEntity.topAlign = NO;
        recordListEntity.actualThread = kShopThread;
        recordListEntity.messageBodyIdType = None;
        
    }
    if (list) {
        recordListEntity.ct = list.ct;
        recordListEntity.badge = list.badge;
        recordListEntity.preview = list.preview;
    }else{
        recordListEntity.ct = [NIMBaseUtil GetServerTime]/1000;
    }
    return recordListEntity;
}


+ (BOOL)clearRecordWithMessageBodyId:(NSString *)mbd{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId = %@",mbd];
    return [ChatListEntity NIM_deleteAllMatchingPredicate:predicate];
}


+(void)setupNotifyMode:(NIM_MESSAGE_MODE)mode
{
    switch (mode) {
        case MESSAGE_MODE_SOUND:
        {
            [NIMBaseUtil playBeep];
        }
            break;
        case MESSAGE_MODE_SHOCK:
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
        }
            break;
        case MESSAGE_MODE_BOTH:
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [NIMBaseUtil playBeep];
        }
            break;
        case MESSAGE_MODE_NONE:
        {
            
        }
            break;
            
        default:
            break;
    }
}


@end
