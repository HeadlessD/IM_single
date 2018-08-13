//
//  ChatEntity+CoreDataProperties.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/26.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "ChatEntity+CoreDataProperties.h"

@implementation ChatEntity (CoreDataProperties)

+ (NSFetchRequest<ChatEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ChatEntity"];
}

@dynamic apId;
@dynamic bId;
@dynamic chatType;
@dynamic cId;
@dynamic ct;
@dynamic ext;
@dynamic groupId;
@dynamic isSender;
@dynamic messageBodyId;
@dynamic messageId;
@dynamic msgContent;
@dynamic mtype;
@dynamic offcialId;
@dynamic oldMessageId;
@dynamic opUserId;
@dynamic packId;
@dynamic sendUserName;
@dynamic sid;
@dynamic status;
@dynamic stype;
@dynamic unread;
@dynamic userId;
@dynamic wId;
@dynamic audioFile;
@dynamic imageFile;
@dynamic location;
@dynamic offcialEntity;
@dynamic textFile;
@dynamic vcard;
@dynamic videoFile;


+ (NSInteger)getRecordEntityCountByPredicate:(NSPredicate*)predicate
{
    return [self NIM_countOfEntitiesWithPredicate:predicate];
}

+(instancetype)findFirstWithMessageId:(int64_t)messageId
{
    return [self NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageId = %lld and userId=%lld",messageId,OWNERID]];
}


+(instancetype)instancetypeWithJsonDic:(NSDictionary *)jsonDic
{
    uint64_t messageId    = [[jsonDic objectForKey:@"messageId"] longLongValue];
    NSString *thread      = [jsonDic objectForKey:@"T"];
    NSArray *array = [thread componentsSeparatedByString:@":"];
    if (array.count==4) {
        thread = [NSString stringWithFormat:@"%@:%@:%@",array[0],array[1],array[2]];
    }
    
    int64_t ct             = [[jsonDic objectForKey:@"ct"] doubleValue];
    E_MSG_CHAT_TYPE mt       = [[jsonDic objectForKey:@"mt"] integerValue];
    int64_t opUserId         = [[jsonDic objectForKey:@"opUserId"] longValue];
    int64_t userId         = [[jsonDic objectForKey:@"userId"] longValue];
    E_MSG_M_TYPE ctt = [[jsonDic objectForKey:@"mtype"] integerValue];
    E_MSG_S_TYPE st  = [[jsonDic objectForKey:@"stype"] integerValue];
    E_MSG_E_TYPE ext  = [[jsonDic objectForKey:@"ext"] integerValue];
    int32_t sid  = [[jsonDic objectForKey:@"sessionId"] intValue];
    int64_t bid  = [[jsonDic objectForKey:@"BID"] longLongValue];
    int64_t cid  = [[jsonDic objectForKey:@"CID"] longLongValue];
    int64_t wid  = [[jsonDic objectForKey:@"WID"] longLongValue];
    
    BOOL isSender         = [[jsonDic objectForKey:@"isSender"] boolValue];
    uint64_t groupid      = [[jsonDic objectForKey:@"groupid"] longLongValue];
    //uint64_t offcialid      = [[jsonDic objectForKey:@"offcialid"] longLongValue];
    NSString *sendUserName  = jsonDic[@"sendUserName"];
    
    id content            = [jsonDic objectForKey:@"msgContent"];
    
    if ([content isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    ChatEntity* chatEntity = [[NIMMessageManager sharedInstance] searchMessageWithMsgId:messageId messageBodyId:thread];
    if (chatEntity) {
        return nil;
    }
    chatEntity = [self NIM_createEntity];
    [chatEntity setIsSender:isSender];
    [chatEntity setMessageBodyId:thread];
    [chatEntity setMessageId:messageId];
    [chatEntity setChatType:mt];
    [chatEntity setOpUserId:opUserId];
    [chatEntity setUserId:OWNERID];
    [chatEntity setCt:ct];
    if ([[NIMSysManager sharedInstance].currentMbd isEqualToString:thread]) {
        [chatEntity setUnread:NO];
    }else{
        [chatEntity setUnread:YES];
    }
    [chatEntity setMtype:ctt];
    [chatEntity setStype:st];
    [chatEntity setMsgContent:content];
    [chatEntity setStatus:QIMMessageStatuNormal];
    [chatEntity setGroupId:groupid];
    [chatEntity setSendUserName:sendUserName];
    [chatEntity setSid:sid];
    [chatEntity setExt:ext];
    [chatEntity setBId:bid];
    [chatEntity setWId:wid];
    [chatEntity setCId:cid];
    
    NSMutableString *preview = [[NSMutableString alloc] init];
    [preview appendString:content];
    
    switch (ctt)
    {
        case TEXT:
        {
            NSString *txt = content;
            TextEntity *textEntity = [TextEntity NIM_createEntity];
            [textEntity setText:txt];
            [chatEntity setTextFile:textEntity];
        }
            break;
            
        case ITEM:
        {
            //商品消息
            NSString *txt = content;
            chatEntity.msgContent = txt;
        }
            break;
        case SMILEY:
        {
            NSString *text = content;
            TextEntity *textEntity = [TextEntity NIM_createEntity];
            [textEntity setText:text];
            [chatEntity setTextFile:textEntity];
            
            /*
             NSArray *smiley = [text regular:@"smiley"];
             if (smiley.count) {
             NSString *txt = [smiley firstObject];
             text = txt;
             TextEntity *textEntity = [TextEntity NIM_createEntity];
             [textEntity setText:txt];
             [chatEntity setTextFile:textEntity];
             }
             */
        }
            break;
        case IMAGE:
        {
            //            NSString *imageURL = [NSString stringWithFormat:@"http://fim.qbao.com/%@",content];
            ImageEntity *imageEntity = [ImageEntity NIM_createEntity];
            [imageEntity setImg:content];
            [imageEntity setThumb:[SSIMSpUtil holderImgURL:content]];
            [chatEntity setImageFile:imageEntity];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:chatEntity success:^(BOOL success) {
                    
                }];
            });
            
        }
            break;
        case VOICE:
        {
            NSString *fileUrl = [SSIMSpUtil holderImgURL:content];
            //                    NSArray* tmpArray = [fileUrl componentsSeparatedByString:@"?t="];
            NSInteger time = 0;
            time = ext;
            AudioEntity *audioEntity = [AudioEntity NIM_createEntity];
            [audioEntity setUrl:fileUrl];
            [audioEntity setRead:NO];
            [audioEntity setDuration:time];
            [chatEntity setAudioFile:audioEntity];
            [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:chatEntity success:^(BOOL success) {
                
            }];
            /*
             if(tmpArray.count>=2)
             {
             NSString* stmp = [tmpArray lastObject];
             time = stmp.integerValue;
             AudioEntity *audioEntity = [AudioEntity NIM_createEntity];
             [audioEntity setUrl:fileUrl];
             [audioEntity setRead:NO];
             [audioEntity setDuration:time];
             [chatEntity setAudioFile:audioEntity];
             [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:chatEntity];
             }
             else
             {
             NSString* stmp = [tmpArray lastObject];
             time = stmp.integerValue;
             AudioEntity *audioEntity = [AudioEntity NIM_createEntity];
             [audioEntity setUrl:fileUrl];
             [audioEntity setRead:NO];
             [chatEntity setAudioFile:audioEntity];
             [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:chatEntity];
             //                        [self resetPublicTime:body];
             
             }
             */
        }
            break;
        case MAP:
        {
            
            NSData *m_Data        = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *m_Dict  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
            double lat = [[m_Dict objectForKey:@"lat"] doubleValue];
            double lng = [[m_Dict objectForKey:@"lng"] doubleValue];
            NSString *address = [m_Dict objectForKey:@"address"];
            
            if (!m_Dict || lat == 0 || lng == 0 || !address)
            {
                address = @"   无法定位";
            }
            
            Location *location = [Location NIM_createEntity];
            
            [location setLat:lat];
            [location setLng:lng];
            
            [location setAddress:address];
            [chatEntity setLocation:location];
        }
            break;
        case VIDEO:
        {
            VideoEntity *videoEntity = [VideoEntity NIM_createEntity];
            NSArray *arr = [content componentsSeparatedByString:@"#"];
            for (NSString *urlStr in arr) {
                NSString *extension = [urlStr pathExtension];
                NSString *realExtension = @"";
                if ([extension isEqualToString:@"vo"]) {
                    realExtension = @"mov";
                    [videoEntity setUrl:urlStr];
                } else {
                    realExtension = @"jpg";
                    [videoEntity setThumbUrl:urlStr];
                }
            }
            [chatEntity setVideoFile:videoEntity];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:chatEntity success:^(BOOL success) {
                }];
            });
        }
            break;
        case JSON:
        {
            switch (st)
            {
                case RED_PACKET:
                {
                    chatEntity.msgContent = content;
                    
                }
                case VCARD:
                {
                    
                    //TODO:发送名片
                    NSData *m_Data        = [content dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *m_Dict  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                                            options:NSJSONReadingMutableLeaves
                                                                              error:nil];
                    int type = [[m_Dict objectForKey:@"type"] intValue];
                    if (type == 0) {
                        int64_t userid = [[m_Dict objectForKey:@"id"] longLongValue];
                        
                        VcardEntity *card = [VcardEntity instancetypeFindUserid:userid];
                        if (card==nil) {
                            card = [VcardEntity NIM_createEntity];
                            card.userid = userid;
                        }
                        chatEntity.vcard = card;
                    }else{
                        int64_t offcialid = [[m_Dict objectForKey:@"id"] longLongValue];
                        NSString *name = [m_Dict objectForKey:@"offcialName"];
                        NOffcialEntity *publicEntity = [NOffcialEntity findFirstWithOffcialid:offcialid];
                        if (publicEntity==nil) {
                            publicEntity = [NOffcialEntity NIM_createEntity];
                            publicEntity.offcialid = offcialid;
                            publicEntity.name = name;
                        }
                        chatEntity.offcialEntity = publicEntity;
                    }
                    [chatEntity setExt:ext];
                }
                    break;
                    
                case ORDER:
                {
                    //订单消息
                    NSString *txt = content;
                    chatEntity.msgContent = txt;
                }
                    break;
                case TIP:
                {
                    NSString *txt = content;
                    TextEntity *textEntity = [TextEntity NIM_createEntity];
                    [textEntity setText:txt];
                    [chatEntity setTextFile:textEntity];
                }
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return chatEntity;
}




@end
