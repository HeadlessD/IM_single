//
//  NIMMessageCenter.m
//  qbim
//
//  Created by ssQINYU on 17/1/26.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "ChatEntity+CoreDataProperties.h"
#import "ChatListEntity+CoreDataProperties.h"
#import "GMember+CoreDataClass.h"
#import "NIMMessageCenter.h"
#import "NIMGlobalProcessor.h"
#import "NIMHttpRequestHeader.h"
#import "NIMManager.h"
#import "NIMLoginOperationBox.h"
#import "GTMBase64.h"
#import "UIImage+NIMEllipse.h"
#import "UIImage+NIMEffects.h"
@interface NIMMessageCenter()


@property (nonatomic, strong) dispatch_queue_t download_queue_t;


@end

@implementation NIMMessageCenter
SingletonImplementation(NIMMessageCenter)

-(void)sendMessageWithObject:(NSObject *)object mType:(E_MSG_M_TYPE)mType sType:(E_MSG_S_TYPE)sType eType:(E_MSG_E_TYPE)eType messageBodyId:(NSString *)messageBodyId msgid:(int64_t)msgid{
    
    __block int64_t msg_id = msgid;
    __block NSString *mbd = messageBodyId;
    
    id msg_content = object;
    
    int64_t bid = 0;
    int64_t op_user_id = 0;
    NSString *sendUserName = nil;
    NSArray *array = [mbd componentsSeparatedByString:@":"];
    
    E_MSG_CHAT_TYPE chatType = [NIMStringComponents chatTypeWithMsgBodyId:mbd];
    
    if (array.count==4) { //商家聊天
        bid = [array[2] longLongValue];
        op_user_id = [array.lastObject longLongValue];
        mbd = [NSString stringWithFormat:@"%@:%@:%@",array[0],array[1],array[2]];
    }else{
        op_user_id = [NIMStringComponents getOpuseridWithMsgBodyId:mbd];
    }
    
    NSString *preview = @"消息";
    int64_t msg_time = [NIMBaseUtil GetServerTime]/1000;
    ChatEntity * chatEntity = [ChatEntity NIM_createEntity];
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    chatEntity.chatType = chatType;
    chatEntity.userId = OWNERID;
    chatEntity.mtype = mType;
    chatEntity.stype = sType;
    chatEntity.ct = msg_time;
    chatEntity.isSender = YES;
    chatEntity.ext = eType;
    chatEntity.messageBodyId = mbd;
    chatEntity.messageId = msg_id;
    chatEntity.unread = NO;
    
    
    if (array.count==4) {
        int64_t bid = [NIMStringComponents getOpuseridWithMsgBodyId:mbd];
        
        if([[NIMSysManager sharedInstance].sidDict objectForKey:@(bid)]){
            int32_t sessionid = [[[NIMSysManager sharedInstance].sidDict objectForKey:@(bid)] unsignedIntValue];
            chatEntity.sid = sessionid;
        }
        chatEntity.bId = bid;
        chatEntity.wId = op_user_id;
        chatEntity.cId = OWNERID;
        
        //公众号id为商家id
        if (chatType == CERTIFY_BUSINESS) {
            op_user_id = bid;
        }
    }
    
    if (chatType==GROUP) {
        
        op_user_id = OWNERID;
        
        int64_t groupid= [NIMStringComponents getOpuseridWithMsgBodyId:mbd];
        chatEntity.groupId = groupid;
        
        GroupList *groupList = [GroupList instancetypeFindGroupId:groupid];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(messageBodyId = %@) AND (userid = %@)",mbd,@(OWNERID)];
        
        if (groupList&&!IsStrEmpty(groupList.selfcard)) {
            sendUserName = groupList.selfcard;
        }else{
            GMember *member = [GMember NIM_findFirstWithPredicate:predicate];
            if (member) {
                sendUserName = IsStrEmpty(member.groupmembernickname)?[card defaultName]:member.groupmembernickname;
            }else{
                sendUserName = [card defaultName];
            }
        }
        
    }else{
        sendUserName = [card defaultName];
    }
    
    chatEntity.sendUserName = sendUserName;
    chatEntity.opUserId = op_user_id;
    
    switch (mType) {
        case TEXT:
        {
            msg_content = (NSString *)object;
            TextEntity *textEntity = [TextEntity NIM_createEntity];
            textEntity.text = msg_content;
            [chatEntity setTextFile:textEntity];
            [chatEntity setMsgContent:msg_content];
            preview = [msg_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
            break;
            
        case ITEM:
        {
            preview = [NSString stringWithFormat:@"[链接]"];
            if ([msg_content isKindOfClass:[NSDictionary class]]) {
                NSDictionary *link_dic = msg_content;
                [chatEntity setMsgContent:[NIMUtility jsonStringWithDictionary:link_dic]];
            }else{
                [chatEntity setMsgContent:msg_content];
            }
        }
            break;
            //            case HTML:
            //            {
            //                if ([object isKindOfClass:[NSDictionary class]]) {
            //                    NSDictionary *link_dic = (NSDictionary *)object;
            //                    preview = [NSString stringWithFormat:@"[分享链接]"];
            //                    [chatEntity setMsgContent:[NIMUtility jsonStringWithDictionary:link_dic]];
            //                }
            //            }
            //                break;
        case SMILEY:
        {
            msg_content = (NSString *)object;
            [chatEntity setMsgContent:msg_content];
            TextEntity *textEntity = [TextEntity NIM_createEntity];
            textEntity.text = msg_content;
            [chatEntity setTextFile:textEntity];
            preview = @"[动态表情]";
            
        }
            break;
        case IMAGE:
        {
            NSLog(@"抛了之前");

            if ([msg_content isKindOfClass:[NSDictionary class]]) {
                NSDictionary *imageDic = msg_content;
                //UIImage *thumbnail = [imageDic objectForKey:@"thumbnail"];
                UIImage *photo = [imageDic objectForKey:@"original"];
                E_MSG_E_TYPE type = eType;
                CGFloat width = photo.size.width;
                CGFloat heigth = photo.size.height;
                
                if(width == heigth){
                    type = SQUARE_PICTURE;
                }else if(width>heigth){
                    type = WIDE_PICTURE;
                }else{
                    type = LONG_PICTURE;
                }
                ImageEntity *imageEntity = [ImageEntity NIM_createEntity];
                imageEntity.file = [NIMBaseUtil thumbImageDocMsgId:msgid];
                imageEntity.bigFile = [NIMBaseUtil bigImageDocMsgId:msgid];
                [chatEntity setImageFile:imageEntity];
                [chatEntity setExt:type];
            }else if ([msg_content isKindOfClass:[NSString class]]){
                ImageEntity *imageEntity = [ImageEntity NIM_createEntity];
                NSString*uuid=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedImageUuid"];
                ChatEntity*record=[[NIMMessageManager sharedInstance] searchMessageWithMsgId:uuid.longLongValue messageBodyId:messageBodyId];
                imageEntity.file = record.imageFile.file;
                imageEntity.bigFile = record.imageFile.bigFile;
                imageEntity.img = msg_content;
                imageEntity.thumb = [SSIMSpUtil holderImgURL:msg_content];
                [chatEntity setImageFile:imageEntity];
                [chatEntity setExt:record.ext];
                
            }
            preview = [NSString stringWithFormat:@"[图片]"];
        }
            break;
        case VOICE:
        {
            
            if ([msg_content isKindOfClass:[NSString class]]) {
                NSString *filePath = msg_content;
                NSString *path = [[[NIMCoreDataManager currentCoreDataManager] recordPathMp3] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.mp3",msg_id]];
                
                if (![NIMBaseUtil coverAAC:filePath toMP3:path]) {
                    DBLog(@"录音错误");
                    [chatEntity setStatus:QIMMessageStatuUpLoadFailed];
                }else{
                    NSURL *saveAudioURL = [[NSURL alloc] initFileURLWithPath:path];
                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:saveAudioURL options:nil];
                    CMTime time = asset.duration;
                    CGFloat secondss = CMTimeGetSeconds(time);
                    NSInteger seconds = roundf(secondss);
                    if (seconds>=60) {
                        seconds = 60;
                    }
                    AudioEntity *audioEntity = [AudioEntity NIM_createEntity];
                    
                    NSString* fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
                    fullPath = [filePath stringByReplacingOccurrencesOfString:fullPath withString:@""];
                    [audioEntity setRead:YES];
                    [audioEntity setFile:fullPath];
                    [audioEntity setDuration:seconds];
                    [chatEntity setExt:seconds];
                    [chatEntity setAudioFile:audioEntity];
                    
                }
            }else if ([msg_content isKindOfClass:[AudioEntity class]]){
                AudioEntity *audioEntity = msg_content;
                [chatEntity setAudioFile:audioEntity];
            }
            preview = [NSString stringWithFormat:@"[声音]"];
            
        }
            break;
        case MAP:
        {
            preview = [NSString stringWithFormat:@"[地理位置]"];
            NSDictionary *imLocation = nil;
            if ([msg_content isKindOfClass:[NSDictionary class]]){
                imLocation = msg_content;
            }else{
                imLocation = [NIMUtility jsonWithJsonString:msg_content];
            }
            double latitude = [[imLocation objectForKey:@"lat"] doubleValue];
            double longitude = [[imLocation objectForKey:@"lng"] doubleValue];
            NSString *address = [imLocation objectForKey:@"address"];
            Location *location = [Location NIM_createEntity];
            location.lat = latitude;
            location.lng = longitude;
            location.address = address;
            [chatEntity setLocation:location];
            NSData*bodyData=[NSJSONSerialization dataWithJSONObject:imLocation options:NSJSONWritingPrettyPrinted error:nil];
            NSString *bodyString = [[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding];
            [chatEntity setMsgContent:bodyString];
        }
            break;
        case VIDEO:
        {
            if ([msg_content isKindOfClass:[NSDictionary class]]) {
                NSDictionary *videoDic = msg_content;
                NSString *file = videoDic[@"file"];
                VideoEntity *videoEntity = [VideoEntity NIM_createEntity];
                if (videoDic[@"thumb"]) {
                    videoEntity.thumb = videoDic[@"thumb"];
                } else {
                    videoEntity.thumb = [NSString stringWithFormat:@"%lld.jpg",msg_id];
                }
                videoEntity.file = file;
                [chatEntity setVideoFile:videoEntity];
            } else if ([msg_content isKindOfClass:[NSString class]]){
                VideoEntity *videoEntity = [VideoEntity NIM_createEntity];
                NSString*uuid=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedVideoUuid"];
                ChatEntity*record=[[NIMMessageManager sharedInstance] searchMessageWithMsgId:uuid.longLongValue messageBodyId:messageBodyId];
                videoEntity.file = record.videoFile.file;
                videoEntity.thumb = record.videoFile.thumb;
                NSArray *arr = [msg_content componentsSeparatedByString:@"#"];
                for (NSString *urlStr in arr) {
                    NSString *extension = [urlStr pathExtension];
                    if ([extension isEqualToString:@"img"]) {
                        videoEntity.thumbUrl = urlStr;
                    } else {
                        videoEntity.url = urlStr;
                    }
                }
                
                [chatEntity setVideoFile:videoEntity];
            }
            preview = [NSString stringWithFormat:@"[小视频]"];
        }
            break;
        case JSON:
        {
            switch (sType) {
                case VCARD:
                {
                    preview = [NSString stringWithFormat:@"[名片]"];
                    
                    if ([msg_content isKindOfClass:[NSDictionary class]]){
                        int type = [[msg_content objectForKey:@"type"] intValue];
                        
                        
                        if (type == 1){
                            int64_t pid = [[msg_content objectForKey:@"id"] longLongValue];
                            NOffcialEntity *publicEntity = [NOffcialEntity findFirstWithOffcialid:pid];
                            chatEntity.offcialEntity = publicEntity;
                            
                        }
                        
                        [chatEntity setMsgContent:[NIMUtility jsonStringWithDictionary:msg_content]];
                    }else{
                        msg_content = (NSString *)object;
                        
                        NSData *m_Data        = [msg_content dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *m_Dict  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                                                options:NSJSONReadingMutableLeaves
                                                                                  error:nil];
                        int type = [[m_Dict objectForKey:@"type"] intValue];
                        
                        
                        if (type == 1){
                            int64_t pid = [[m_Dict objectForKey:@"id"] longLongValue];
                            NOffcialEntity *publicEntity = [NOffcialEntity findFirstWithOffcialid:pid];
                            chatEntity.offcialEntity = publicEntity;
                            
                        }
                        
                        [chatEntity setMsgContent:msg_content];
                    }
                    
                    
                    
                    
                }
                    break;
                case RED_PACKET:
                {
                    preview = [NSString stringWithFormat:@"[红包]"];
                    if ([msg_content isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *link_dic = msg_content;
                        [chatEntity setMsgContent:[NIMUtility jsonStringWithDictionary:link_dic]];
                    }else{
                        [chatEntity setMsgContent:msg_content];
                    }
                    
                    
                    
                }
                    break;
                    
                case ORDER:
                {
                    preview = [NSString stringWithFormat:@"[订单]"];
                    if ([msg_content isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *link_dic = msg_content;
                        [chatEntity setMsgContent:[NIMUtility jsonStringWithDictionary:link_dic]];
                    }else{
                        [chatEntity setMsgContent:msg_content];
                        
                    }
                    break;

                }
                case ARTICLE:
                {
                    preview = [NSString stringWithFormat:@"[链接]"];
                    if ([msg_content isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *link_dic = msg_content;
                        [chatEntity setMsgContent:[NIMUtility jsonStringWithDictionary:link_dic]];
                    }else{
                        [chatEntity setMsgContent:msg_content];
                    }
                    break;
                }
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
        
    if (chatType == PRIVATE && array.count < 4) {
        FDListEntity *fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and (fdFriendShip = %d || fdFriendShip = %d)",OWNERID,op_user_id,FriendShip_Friended,FriendShip_UnilateralFriended]];
        if (fdListEntity == nil) {
            chatEntity.status = QIMMessageStatuUpLoadFailed;
        }else{
            if (fdListEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK || fdListEntity.fdBlackShip == FD_BLACK_MUTUAL_BLACK || fdListEntity.fdFriendShip == FriendShip_UnilateralFriended) {
                chatEntity.status = QIMMessageStatuUpLoadFailed;
            }else{
                E_NET_STATUS status = [NetCenter sharedInstance].GetNetStatus;
                if ( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable || status == CLOSED ||
                    status == CLOSING ||
                    status == DISCONNECT ||
                    status == BEKICKED) {
                    chatEntity.status = QIMMessageStatuUpLoadFailed;
                }else{
                    chatEntity.status = QIMMessageStatuIsUpLoading;
                    [self sendChatRecord:chatEntity];
                }
            }
        }
    }else{
        E_NET_STATUS status = [NetCenter sharedInstance].GetNetStatus;
        if ( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable || status == CLOSED ||
            status == CLOSING ||
            status == DISCONNECT ||
            status == BEKICKED) {
            chatEntity.status = QIMMessageStatuUpLoadFailed;
        }else{
            chatEntity.status = QIMMessageStatuIsUpLoading;
            [self sendChatRecord:chatEntity];
        }
    }
    NSLog(@"抛了");
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP object:chatEntity];
    
    ChatListEntity * chatList = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",chatEntity.messageBodyId]];
    if (chatList==nil) {
        chatList = [ChatListEntity NIM_createEntity];
        chatList.messageBodyId  = chatEntity.messageBodyId;
        chatList.chatType = chatType;
        chatList.messageBodyIdType = None;
        chatList.topAlign = NO;
    }
    chatList.actualThread = messageBodyId;
    chatList.userId = OWNERID;
    chatList.sType = sType;
    chatList.isPublic = 0;
    [chatList setShowRedPublic:0];
    chatList.ct = msg_time;
    chatList.preview = preview;
    if (chatType == PUBLIC) {
        chatList.isflod = YES;
    }else{
        chatList.isflod = NO;
    }
    if (chatType == GROUP) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"messageBodyId = %@",chatEntity.messageBodyId];
        GroupList *groupList = [GroupList NIM_findFirstWithPredicate:pre];
        GROUP_MESSAGE_STATUS isAss = (GROUP_MESSAGE_STATUS)groupList.switchnotify;
        if (isAss == GROUP_MESSAGE_IN_HELP_NO_HIT) {
            //只要有群消息过来，则设置为1
            [[NIMOperationBox sharedInstance]makeGroupAssistantPacket:chatList withUsePrivew:NO];
        }
    }
    
    if (chatType == SHOP_BUSINESS || chatType == CERTIFY_BUSINESS){
        [[NIMOperationBox sharedInstance] makeShopAssistantPacketShow:chatList isRevMsg:YES];
    }
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    
    //黑名单和非好友入口
    if (chatType == PRIVATE && array.count != 4) {
        
        FDListEntity * fdList = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and (fdFriendShip = %d || fdFriendShip = %d)",OWNERID,op_user_id,FriendShip_Friended,FriendShip_UnilateralFriended]];
        if (fdList == nil) {
            //                chatList.sType =  GROUP_ADD_AGREE;
            [self createNotFriendTips:chatEntity strType:@"对方开启了好友验证，你还不是他(她)的好友。请先添加对方为好友，对方验证通过后，才能聊天，发送好友验证"];
        }else{
            if (fdList.fdBlackShip == FD_BLACK_PASSIVE_BLACK || fdList.fdBlackShip == FD_BLACK_MUTUAL_BLACK) {
                [self createNotFriendTips:chatEntity strType:@"消息已发出，但被对方拒收了"];
            }else if (fdList.fdFriendShip == FriendShip_UnilateralFriended){
                [self createNotFriendTips:chatEntity strType:@"对方开启了好友验证，你还不是他(她)的好友。请先添加对方为好友，对方验证通过后，才能聊天，发送好友验证"];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
    
    //    });
}


//TODO:发文本和表情
- (void)sendTextWithRecord:(ChatEntity *)chatEntity{
    //    if (chatEntity.mtype == SMILEY) {
    //        chatEntity.msgContent = [NSString stringWithFormat:@"[smiley]%@[/smiley]",chatEntity.msgContent];
    //    }
    
    [self sendMessage:chatEntity];
}

//TODO:发图片
- (void)sendPhotoWithRecord:(ChatEntity *)chatEntity
{
    dispatch_async(self.download_queue_t, ^{
    ImageEntity *imageEntity = chatEntity.imageFile;
    id object = nil;
    if (imageEntity.img.length) {
        object = imageEntity.img;
    }else if (imageEntity.bigFile) {
        
        
        NSString *fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",fullPath,imageEntity.bigFile];
        
        object = [UIImage imageWithContentsOfFile:filePath];
        
        
    }else if (imageEntity.file) {
        //        NSData *_decodedImageData = [[NSData alloc]initWithBase64EncodedString:imageEntity.file options:NSDataBase64DecodingIgnoreUnknownCharacters];
        //        object = [UIImage imageWithData:_decodedImageData];
        NSString *fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",fullPath,imageEntity.file];
        object = [UIImage imageWithContentsOfFile:filePath];
        
    }else{
        chatEntity.status = QIMMessageStatuUpLoadFailed;
        return;
    }
    if ([object isKindOfClass:[NSString class]]) {
        
        chatEntity.msgContent = object;
        
        [self sendMessage:chatEntity];
        
        return;
    }
    UIImage *sendImg = object;
    UIImageOrientation imgOrientation = UIImageOrientationUp;
    switch (sendImg.imageOrientation) {
        case UIImageOrientationUp:
            imgOrientation = UIImageOrientationUp;
            break;
        case UIImageOrientationDown:
            imgOrientation = UIImageOrientationDown;
            
            break;
        case UIImageOrientationLeft:
            imgOrientation = UIImageOrientationLeft;
            
            break;
        case UIImageOrientationRight:
            imgOrientation = UIImageOrientationRight;
            break;
            
        default:
            break;
    }
    //    object = [object rotatedByDegrees:90];
    
    object = [UIImage nim_transferImage:object orientation:imgOrientation];
    int64_t userid = 0;
    int64_t toid = 0;
    if (chatEntity.chatType==GROUP) {
        userid = OWNERID;
        toid = chatEntity.groupId;
    }else  {
        userid = OWNERID;
        toid = chatEntity.opUserId;
    }
    
        [[NIMManager sharedImManager] postFile:object userid:userid toId:toid msgid:chatEntity.messageId fileType:FILE_TYPE_IMAGE completeBlock:^(id object, NIMResultMeta *result) {
            if (result) {
                chatEntity.status = QIMMessageStatuUpLoadFailed;
                [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
            }else{
                NSString *fileurl = [object objectForKey:@"url"];
                chatEntity.msgContent = fileurl;
                NSString *imageURL = [NSString stringWithFormat:@"http://39.104.84.2:8088/%@",fileurl];
                
                //                    NSString *remoteid = [object objectForKey:@"msg"];
                chatEntity.msgContent = fileurl;
                chatEntity.imageFile.img=fileurl;
                chatEntity.imageFile.thumb = [SSIMSpUtil holderImgURL:fileurl];
                [self sendMessage:chatEntity];
            }
        }];
    });
    
}


//TODO:发音频
- (void)sendAudioWithRecord:(ChatEntity *)chatEntity
{
    AudioEntity *audioEntity = chatEntity.audioFile;
    
    id object = nil;
    if (audioEntity.url.length) {
        object = audioEntity.url;
    }else{
        NSString* pathMp3 = [[NIMCoreDataManager currentCoreDataManager] recordPathMp3];
        
        NSString *fileName = [pathMp3 stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.mp3",chatEntity.messageId]];
        NSURL *saveAudioURL = [NSURL fileURLWithPath:fileName];
        object =saveAudioURL;
    }
    if ([object isKindOfClass:[NSString class]]) {
        NSString *fileurl = object;
        NSString *prepareString = [NSString stringWithFormat:@"%@",fileurl];
        
        chatEntity.msgContent = prepareString;
        //发送消息
        [self sendMessage:chatEntity];
        return;
    }
    int64_t userid = OWNERID;
    int64_t toid = 0;
    if (chatEntity.chatType==PRIVATE) {
        toid = chatEntity.opUserId;
    }else if (chatEntity.chatType==GROUP) {
        toid = chatEntity.groupId;
    }else if (chatEntity.chatType==PUBLIC) {
        toid = chatEntity.opUserId;
    }
    
    dispatch_async(self.download_queue_t, ^{
        [[NIMManager sharedImManager] postFile:object userid:userid toId:toid msgid:chatEntity.messageId fileType:FILE_TYPE_AUDIO completeBlock:^(id object, NIMResultMeta *result) {
            if (result) {
                chatEntity.status = QIMMessageStatuUpLoadFailed;
                [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
            }else{
                NSString *fileurl = [object objectForKey:@"url"];
                chatEntity.msgContent = fileurl;
                [self sendMessage:chatEntity];
            }
        }];
    });
    
    
}

//TODO:发视频
- (void)sendVideoWithRecord:(ChatEntity *)chatEntity
{
    VideoEntity *videoEntity = chatEntity.videoFile;
    NSMutableArray *urls = [[NSMutableArray alloc] init];

    // 1.队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    id object = nil;
    int64_t userid = OWNERID;
    int64_t toid = 0;
    if (chatEntity.chatType==PRIVATE) {
        toid = chatEntity.opUserId;
    }else if (chatEntity.chatType==GROUP) {
        toid = chatEntity.groupId;
    }else if (chatEntity.chatType==PUBLIC) {
        toid = chatEntity.opUserId;
    }
    if (videoEntity.url.length>0) {
        object = videoEntity.url;
    } else if (videoEntity.file.length>0) {
        NSString *docPath = [[NIMCoreDataManager currentCoreDataManager] recordPathMov];
        object = [NSURL fileURLWithPath:[docPath stringByAppendingPathComponent:videoEntity.file]];
    } else {
        NSString* pathMp3 = [[NIMCoreDataManager currentCoreDataManager] recordPathMov];
        NSString *fileName = [pathMp3 stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.mov",chatEntity.messageId]];
        NSURL *saveAudioURL = [NSURL fileURLWithPath:fileName];
        object =saveAudioURL;
    }
    if ([object isKindOfClass:[NSString class]]) {
        NSString *fileurl = object;
        NSString *prepareString = [NSString stringWithFormat:@"%@",fileurl];
        [urls addObject:prepareString];
    } else {
        if (object) {
            dispatch_group_enter(group);
            [[DFFileManager sharedInstance] compression:object block:^(NSData *data) {
                dispatch_async(self.download_queue_t, ^{
                    [[NIMManager sharedImManager] postFile:data userid:userid toId:toid msgid:chatEntity.messageId fileType:FILE_TYPE_VIDEO completeBlock:^(id object, NIMResultMeta *result) {
                        dispatch_group_leave(group);
                        if (result) {
                            //                        chatEntity.status = QIMMessageStatuUpLoadFailed;
                            //                        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
                        }else{
                            NSString *fileurl = [object objectForKey:@"url"];
                            [urls addObject:fileurl];
                        }
                    }];
                });
            }];
        }
    }
    id image = nil;
    if (videoEntity.thumbUrl.length>0) {
        image = videoEntity.thumbUrl;
    } else if (videoEntity.thumb.length>0) {
        NSString *filePath = [[[NIMCoreDataManager currentCoreDataManager] recordPathMov] stringByAppendingPathComponent:videoEntity.thumb];
        image = [UIImage imageWithContentsOfFile:filePath];
        if (image == nil) {
            NSString *path = [[[NIMCoreDataManager currentCoreDataManager]recordPathMov] stringByAppendingPathComponent:videoEntity.file];
            image = [UIImage nim_getVideoPreViewImage:[NSURL fileURLWithPath:path]];
        }
    } else{
        chatEntity.status = QIMMessageStatuUpLoadFailed;
        return;
    }
    if ([image isKindOfClass:[NSString class]]) {
        [urls addObject:image];
    } else {
        if (image) {
            UIImage *sendImg = image;
            dispatch_group_enter(group);
            dispatch_async(self.download_queue_t, ^{
                [[NIMManager sharedImManager] postFile:sendImg userid:userid toId:toid msgid:chatEntity.messageId fileType:FILE_TYPE_IMAGE completeBlock:^(id object, NIMResultMeta *result) {
                    dispatch_group_leave(group);
                    if (result) {
                        //                    chatEntity.status = QIMMessageStatuUpLoadFailed;
                        //                    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
                    }else{
                        NSString *fileurl = [object objectForKey:@"url"];
                        [urls addObject:fileurl];
                    }
                }];
            });
        }
    }
    dispatch_group_notify(group, queue, ^{
        if (urls.count>1) {
            chatEntity.msgContent = [urls componentsJoinedByString:@"#"];
            [self sendMessage:chatEntity];
        } else {
            chatEntity.status = QIMMessageStatuUpLoadFailed;
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
        }
    });
    
}

//TODO:统一消息接口
-(void)sendChatRecord:(ChatEntity *)chatEntity
{
    switch (chatEntity.mtype) {
        case TEXT: case SMILEY:
            [self sendTextWithRecord:chatEntity];
            break;
        case ITEM:
            [self sendMessage:chatEntity];
            break;
        case IMAGE:
            [self sendPhotoWithRecord:chatEntity];
            break;
        case VOICE:
            [self sendAudioWithRecord:chatEntity];
            break;
        case MAP:
            [self sendMessage:chatEntity];
            break;
        case VIDEO:
            [self sendVideoWithRecord:chatEntity];
            break;
        case JSON:
            
            switch (chatEntity.stype) {
                case VCARD:case RED_PACKET:case ORDER:
                    [self sendMessage:chatEntity];
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
}


-(void)sendMessage:(ChatEntity *)chatEntity
{
    switch (chatEntity.chatType) {
        case PRIVATE: case SHOP_BUSINESS:
            [[NIMGlobalProcessor sharedInstance].msg_processor sendSingleMessageRQ:chatEntity];
            break;
        case GROUP:
            [[NIMGlobalProcessor sharedInstance].msg_processor sendGroupMessageRQ:chatEntity];
            break;
        case PUBLIC: case CERTIFY_BUSINESS:
            
            
//            if (OWNERID == 5504128) {//公众号
//                //                [[NIMGlobalProcessor sharedInstance].msg_processor sysSendMessageRQ:chatEntity];
//                //                [[NIMGlobalProcessor sharedInstance].msg_processor sysSendOneMessageRQ:chatEntity];
//                //                [[NIMGlobalProcessor sharedInstance].msg_processor sysSendSomeMessageRQ:chatEntity];
//                //
//                //                [[NIMGlobalProcessor sharedInstance].msg_processor offcialSendMessageRQ:chatEntity];
//                //                [[NIMGlobalProcessor sharedInstance].msg_processor offcialSendOneMessageRQ:chatEntity];
//                [[NIMGlobalProcessor sharedInstance].msg_processor offcialSendSomeMessageRQ:chatEntity];
//            }else{
                [[NIMGlobalProcessor sharedInstance].msg_processor sendFansMessageRQ:chatEntity];
//            }
            
            
            break;
        default:
            break;
    }
}



//TODO:删除聊天记录
- (void)deleteRecordsThread:(NSString *)messageBodyId completeBlock:(CompleteBlock)completeBlock{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId = %@",messageBodyId];
    [ChatEntity NIM_deleteAllMatchingPredicate:predicate];
    ChatListEntity* recordListEntity = [ChatListEntity findFirstWithMessageBodyId:messageBodyId];
    recordListEntity.preview = @"";
    //TODO:save
    [[NIMMessageManager sharedInstance] removeAllMessageBy:messageBodyId];
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];

    if (completeBlock) {
        completeBlock (messageBodyId, nil);
    }
}


//TODO:消息重发
- (void)reSendRecordEntity:(ChatEntity *)recordEntity{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    ChatListEntity * chatList = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",recordEntity.messageBodyId]];
    
    NSArray *array = [chatList.actualThread componentsSeparatedByString:@":"];
    
    //商家聊天非好友不拦截
    
    recordEntity.ct = [NIMBaseUtil GetServerTime]/1000;
    if (recordEntity.chatType == PRIVATE && array.count != 4) {
        FDListEntity *fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and (fdFriendShip = %d || fdFriendShip = %d)",OWNERID,recordEntity.opUserId,FriendShip_Friended,FriendShip_UnilateralFriended]];
        if (fdListEntity == nil) {
            recordEntity.status = QIMMessageStatuUpLoadFailed;
        }else{
            if (fdListEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK || fdListEntity.fdBlackShip == FD_BLACK_MUTUAL_BLACK || fdListEntity.fdFriendShip == FriendShip_UnilateralFriended) {
                recordEntity.status = QIMMessageStatuUpLoadFailed;
            }else{
                E_NET_STATUS status = [NetCenter sharedInstance].GetNetStatus;
                if ( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable || status == CLOSED ||
                    status == CLOSING ||
                    status == DISCONNECT ||
                    status == BEKICKED) {
                    recordEntity.status = QIMMessageStatuUpLoadFailed;
                }else{
                    recordEntity.status = QIMMessageStatuIsUpLoading;
                    [self sendChatRecord:recordEntity];
                }
            }
        }
    }else{
        recordEntity.status = QIMMessageStatuIsUpLoading;
        if (recordEntity.bId !=0 && recordEntity.wId !=0) {
            NSString *key = [NSString stringWithFormat:@"%lld_wid",recordEntity.bId];
            int64_t currentWid = [[[NIMSysManager sharedInstance].sidDict objectForKey:key] longLongValue];
            if (currentWid != recordEntity.wId) {
                recordEntity.wId = currentWid;
                recordEntity.opUserId = currentWid;
            }
        }
        E_NET_STATUS status = [NetCenter sharedInstance].GetNetStatus;
        if ( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable || status == CLOSED ||
            status == CLOSING ||
            status == DISCONNECT ||
            status == BEKICKED) {
            recordEntity.status = QIMMessageStatuUpLoadFailed;
        }else{
            recordEntity.status = QIMMessageStatuIsUpLoading;
            [self sendChatRecord:recordEntity];
        }
    }
    [[NIMMessageManager sharedInstance] updateMessage:recordEntity isPost:YES isChange:YES];
    [privateContext MR_saveToPersistentStoreAndWait];
    
    
    
    
    //黑名单和非好友入口
    if (recordEntity.chatType == PRIVATE && array.count != 4) {
        
        FDListEntity * fdList = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and (fdFriendShip = %d || fdFriendShip = %d)",OWNERID,recordEntity.opUserId,FriendShip_Friended,FriendShip_UnilateralFriended]];
        if (fdList == nil) {
            [self createNotFriendTips:recordEntity strType:@"对方开启了好友验证，你还不是他(她)的好友。请先添加对方为好友，对方验证通过后，才能聊天，发送好友验证"];
        }else{
            if (fdList.fdBlackShip == FD_BLACK_PASSIVE_BLACK || fdList.fdBlackShip == FD_BLACK_MUTUAL_BLACK) {
                [self createNotFriendTips:recordEntity strType:@"消息已发出，但被对方拒收了"];
            }else if (fdList.fdFriendShip == FriendShip_UnilateralFriended){
                [self createNotFriendTips:recordEntity strType:@"对方开启了好友验证，你还不是他(她)的好友。请先添加对方为好友，对方验证通过后，才能聊天，发送好友验证"];
            }
        }
    }
}

//TODO:消息转发
-(void)forwardRecordEntity:(ChatEntity *)recordEntity toMsgBodyId:(NSString *)msgBodyId{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    E_MSG_M_TYPE contentType = (E_MSG_M_TYPE)recordEntity.mtype;
    E_MSG_S_TYPE contentSubType = (E_MSG_S_TYPE)recordEntity.stype;
    NSObject *prepareObject = nil;
    switch (contentType) {
        case TEXT:
        {
            TextEntity *textEntity = recordEntity.textFile;
            NSString *text = textEntity.text;
            prepareObject = text;
        }
            break;
        case ITEM:
        {
            prepareObject = recordEntity.msgContent;
            
        }
            break;
        case IMAGE:
        {
            ImageEntity *imageEntity = recordEntity.imageFile;
            if (imageEntity.img) {
                prepareObject = imageEntity.img;
            }else if(imageEntity.bigFile){
                prepareObject = imageEntity.bigFile;
            }
            [[NSUserDefaults standardUserDefaults]setObject:@(recordEntity.messageId) forKey:@"selectedImageUuid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
            break;
        case VOICE:
        {
            AudioEntity *audioEntity = recordEntity.audioFile;
            if (audioEntity.file) {
                prepareObject = [NSURL URLWithString:audioEntity.file];
            }else if(audioEntity.url){
                prepareObject = audioEntity.url;
            }
        }
            break;
        case SMILEY:
        {
            TextEntity *textEntity = recordEntity.textFile;
            NSString *text = textEntity.text;
            prepareObject = text;
        }
            break;
        case MAP:
        {
            
            NSData *m_Data        = [recordEntity.msgContent dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
            if (dic) {
                prepareObject = dic;
            }
            
        }
            break;
        case VIDEO:
        {
            
            VideoEntity *videoEntity = recordEntity.videoFile;

            if (!IsStrEmpty(recordEntity.msgContent)) {
                prepareObject = recordEntity.msgContent;
            } else {
                NSMutableDictionary *videoDict = [[NSMutableDictionary alloc] init];
                NSString *file = @"";
                NSString *thumb = @"";
                if (!IsStrEmpty(videoEntity.file)) {
                    file = videoEntity.file;
                    [videoDict setObject:file forKey:@"file"];
                }
                if (!IsStrEmpty(videoEntity.thumb)) {
                    
                    NSString *path = [[[NIMCoreDataManager currentCoreDataManager] recordPathMov] stringByAppendingPathComponent:videoEntity.thumb];
                    UIImage *image = [UIImage imageWithContentsOfFile:path];
                    if (image==nil) {
                        image = [UIImage nim_getVideoPreViewImage:[NSURL URLWithString:videoEntity.url]];
                        if (image) {
                            [NIMBaseUtil cacheVideoThumb:image msgId:recordEntity.messageId];
                            [videoDict setObject:[NSString stringWithFormat:@"%lld.jpg",recordEntity.messageId] forKey:@"thumb"];
                        }
                    } else {
                        thumb = videoEntity.thumb;
                        [videoDict setObject:thumb forKey:@"thumb"];
                    }
                    
                }
                if (videoDict) {
                    prepareObject = videoDict;
                }
            }
            [[NSUserDefaults standardUserDefaults]setObject:@(recordEntity.messageId) forKey:@"selectedVideoUuid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
            break;
        case JSON:
        {
            switch (contentSubType) {
                case RED_PACKET:
                {
                    
                    prepareObject = recordEntity.msgContent;
                    
                }
                    break;
                case VCARD:
                {
                    
                    prepareObject = recordEntity.msgContent;
                    
                }
                    break;
                case ORDER:
                {
                    
                    NSDictionary *dic = [SSIMSpUtil convertJSONToDict:recordEntity.msgContent];
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        prepareObject = dic;
                    }
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
    [self sendMessageWithObject:prepareObject mType:contentType sType:contentSubType eType:DEFAULT messageBodyId:msgBodyId msgid:[NIMBaseUtil GetServerTime]];
    [privateContext MR_saveOnlySelfAndWait];
    
}

-(void)sendSDKMessage:(SSIMMessage *)message messageid:(int64_t)messageid
{
    NSString *messageBodyId =  [NIMStringComponents createMsgBodyIdWithType:message.chatType fromId:message.userid toId:message.toid];
    [self sendMessageWithObject:message.msgContent mType:(E_MSG_M_TYPE)message.mtype sType:(E_MSG_S_TYPE)message.stype eType:(E_MSG_E_TYPE)message.etype messageBodyId:messageBodyId msgid:messageid];
}


-(void)createNotFriendTips:(ChatEntity *)chat strType:(NSString *)strType
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_MESSAGE_STATUS object:strType];
    
    int64_t time = [NIMBaseUtil GetServerTime]/1000;
    ChatEntity * chatEntity = [ChatEntity NIM_createEntity];
    chatEntity.chatType = PRIVATE;
    chatEntity.userId = OWNERID;
    chatEntity.mtype = JSON;
    chatEntity.stype = GROUP_ADD_AGREE;
    chatEntity.ct = time;
    chatEntity.isSender = YES;
    chatEntity.messageBodyId = chat.messageBodyId;
    chatEntity.messageId = [[NetCenter sharedInstance] CreateMsgID];
    chatEntity.unread = NO;
    chatEntity.sendUserName = chat.sendUserName;
    chatEntity.opUserId = chat.opUserId;
    NSString *content = strType;
    TextEntity *textEntity = [TextEntity NIM_createEntity];
    textEntity.text = content;
    [chatEntity setTextFile:textEntity];
    [chatEntity setMsgContent:content];
    
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
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    SSIMMessage *message = [[NIMMessageErrorManager sharedInstance] transChatEntity:chat.messageId];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_MESSAGE object:message];
}

- (dispatch_queue_t)download_queue_t{
    if (_download_queue_t == nil) {
        _download_queue_t = dispatch_queue_create("com.nim.downloadQueue", DISPATCH_QUEUE_SERIAL);
        
    }
    return _download_queue_t;
}

@end
