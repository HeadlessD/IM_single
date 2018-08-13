//
//  NIMMessageErrorManager.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/6/7.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMMessageErrorManager.h"

@implementation NIMMessageErrorManager

SingletonImplementation(NIMMessageErrorManager)

-(SDK_MESSAGE_RESULT)getMessageStatus:(SSIMMessage *)message
{
    if (message==nil ||
        message.userid<=0 ||
        message.toid<=0 ||
        !message.msgContent) {
        return SDK_MESSAGE_LOSE;
    }else{
        if (message.chatType == PRIVATE) {
            NSPredicate *friendPre = [NSPredicate predicateWithFormat:@"fdOwnId = %lld AND fdPeerId = %lld",OWNERID,message.toid];
            FDListEntity *friend = [FDListEntity NIM_findFirstWithPredicate:friendPre];
            if (!friend) {
                return SDK_MESSAGE_USER_NOTFOUND;
            }
 
        }else if (message.chatType == GROUP){
            GroupList *group = [GroupList instancetypeFindGroupId:message.toid];
            if (!group) {
                return SDK_MESSAGE_GROUP_NOTFOUND;
            }
        }
        
        
        
        switch (message.chatType) {
            case GROUP:
            case PUBLIC:
            case PRIVATE:
                
                break;
                
            default:
                return SDK_MESSAGE_CT_NOTFOUND;
                break;
        }
        
        switch (message.mtype) {
            case TEXT:
            case ITEM:
            case IMAGE:
            case VOICE:
            case SMILEY:
            case JSON:
            case MAP:
                
                break;
            default:
                return SDK_MESSAGE_MT_NOTFOUND;
                break;
        }
        
        switch (message.stype) {
            case CHAT:
            case RED_PACKET:
            case ORDER:
            case VCARD:
            case ARTICLE:
            case TIP:
                
                break;
            default:
                return SDK_MESSAGE_ST_NOTFOUND;
                break;
        }
        
        
    }
    
    return SDK_MESSAGE_OK;
}


-(SSIMMessage *)transChatEntity:(int64_t)msgid
{
    ChatEntity *chatEntity = [ChatEntity findFirstWithMessageId:msgid];
    if (!chatEntity) {
        return nil;
    }
    SSIMMessage *message = [[SSIMMessage alloc] init];
    message.userid = chatEntity.userId;
    message.toid = chatEntity.opUserId;
    message.chatType = chatEntity.chatType;
    message.mtype = chatEntity.mtype;
    message.stype = chatEntity.stype;
    message.etype = chatEntity.ext;
    message.msgContent = chatEntity.msgContent;
    message.bid = chatEntity.bId;
    message.wid = chatEntity.wId;
    message.cid = chatEntity.cId;
    [message setValue:@(chatEntity.messageId) forKey:NSStringFromSelector(@selector(messageId))];
    return message;
}

-(NSDictionary *)getMyFavorJsonByContent:(id)content
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:5];
    if ([content isKindOfClass:[NSArray class]]) {
        NSArray *models = content;
        NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:5];
        for (SSIMArticleModel *model in models) {
            NSDictionary *tmpDict = @{@"img_url":model.img_url?:@"",
                                      @"ct":model.time?:@"",
                                      @"title":model.title?:@"",
                                      @"url":model.url?:@""};
            [tmpArr addObject:tmpDict];
        }
        [dict setObject:tmpArr forKey:@"items"];
    }else if ([content isKindOfClass:[SSIMShareModel class]]){
        SSIMShareModel *model = content;
        dict = @{@"product_title":model.title?:@"",
                 @"main_img":model.imgUrl?:@"",
                 /*@"product_name":model.desc?:@"",*/
                 @"product_desc":model.desc?:@"",
                 @"source_img":model.sourceImg?:@"",
                 @"source_txt":model.sourceTxt?:@"",
                 @"url":model.url?:@""
                 };
    }
    
    return dict;
}

@end
