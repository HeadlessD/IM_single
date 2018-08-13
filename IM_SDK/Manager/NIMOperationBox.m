//
//  NIMOperationBox.m
//  qbim
//
//  Created by 秦雨 on 17/2/9.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMOperationBox.h"
//#import "NProfileEntity.h"
#import "NIMManager.h"
#import "GTMBase64.h"
@implementation NIMOperationBox
SingletonImplementation(NIMOperationBox)

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)operateChatJsonMessages:(NSArray *)messages isRemind:(BOOL)isRemind{
    
    if (messages.count == 0) {
        return;
    }
    for (int i=0; i<messages.count; i++) {
        id object = messages[i];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic_obj = object;
            int64_t opUserId        = [dic_obj[@"opUserId"] longLongValue];
            int64_t userId          = [dic_obj[@"userId"] longLongValue];
            int64_t bid        = [dic_obj[@"BID"] longLongValue];
            int64_t wid          = [dic_obj[@"WID"] longLongValue];
            
            NSString *sendUserName          = dic_obj[@"sendUserName"];
            
            E_MSG_CHAT_TYPE mt       = [[dic_obj objectForKey:@"mt"] integerValue];
            
            NSString *messageBodyId = nil;
            
            uint64_t groupid = [dic_obj[@"groupid"] longLongValue];
            uint64_t offcialid = [dic_obj[@"offcialid"] longLongValue];
            
            //私聊,群聊,公众号消息
            
            switch (mt) {//这个switch语句主要是为了获取并拼接thread
                case PRIVATE:
                {
                    
                    messageBodyId  = [NIMStringComponents createMsgBodyIdWithType:PRIVATE fromId:userId toId:opUserId];
                    
                }
                    
                    break;
                    
                case GROUP:
                {
                    messageBodyId   = [NIMStringComponents createMsgBodyIdWithType:mt  toId:groupid];
                }
                    break;
                    
                case PUBLIC:
                {
                    
                    messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PUBLIC  toId:offcialid];
                    
                }
                    break;
                    
                case SHOP_BUSINESS:
                {
                    if (bid!=0 && wid!=0){//说明是商家聊天消息
                        
                        messageBodyId  = [NSString stringWithFormat:@"%ld:%lld:%lld:%lld",(long)SHOP_BUSINESS,OWNERID,bid,wid];
                        
                    }else{
                        messageBodyId  = [NIMStringComponents createMsgBodyIdWithType:PRIVATE fromId:userId toId:opUserId];
                    }
                }
                    break;
                    
                case CERTIFY_BUSINESS:
                {
                    if (bid!=0 && wid!=0){//说明是企业商家聊天消息
                        messageBodyId  = [NSString stringWithFormat:@"%ld:%lld:%lld:%lld",(long)CERTIFY_BUSINESS,OWNERID,bid,wid];
                    }else{
                        messageBodyId = [NIMStringComponents createMsgBodyIdWithType:CERTIFY_BUSINESS  toId:offcialid];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            
            switch (mt) {//这个switch语句是为了检测本地是否有个人,群组或公众号的信息,更加清晰一些
                case PRIVATE:
                {
                    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:opUserId];
                    
                    if (vcard==nil) {
                        vcard = [VcardEntity NIM_createEntity];
                        vcard.userid = opUserId;
                        vcard.userName = sendUserName;
                        vcard.avatar = USER_ICON_URL(opUserId);
                        
                        
                        
                    }else{
                        if (!vcard.avatar) {
                            vcard.avatar = USER_ICON_URL(opUserId);
                        }
                    }
                    
                    
                }
                    break;
                case GROUP:
                {//检测本地是否存在该群,不存在则获取该群
                    GroupList *groupEntity =[[GroupManager sharedInstance] GetGroupList:messageBodyId];
//                    if (!groupEntity) {
//                        [[NIMGroupOperationBox sharedInstance] sendBatchGroupInfoRQ:@[@(groupid)]];
//                        groupEntity = [GroupList NIM_createEntity];
//                        groupEntity.groupId = groupid;
//                        groupEntity.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid];
//                        groupEntity.avatar = GROUP_ICON_URL(groupid);
//                        groupEntity.memberid = OWNERID;
//                    }
                }
                    break;
                case PUBLIC:
                {//如果本地没有次公众号,则获取
                    NSString *name = nil;
                    NOffcialEntity *offcialEntity = [NOffcialEntity findFirstWithMsgBodyId:[NIMStringComponents createMsgBodyIdWithType:PUBLIC  toId:offcialid]];
                    if (offcialEntity==nil) {
                        if (offcialid == kSystemID) {
                            name = @"系统消息";
                        }else{
                            name = [NSString stringWithFormat:@"公众号_%lld",offcialid];
                        }
                        NIMOffcialInfo *info = [[NIMOffcialInfo alloc] initWithOffcialid:offcialid name:[NSString stringWithFormat:name,offcialid] avatar:@"https://facebook.github.io/react/img/logo_og.png"];
                        [[NIMOfficialOperationBox sharedInstance] addOffcialInfo:info];
                    }
                    
                }
                    break;
                case SHOP_BUSINESS:
                {
                    if (bid!=0 && wid!=0){
                        opUserId = bid;
                        NBusinessEntity *businessEntity = [NBusinessEntity instancetypeFindBid:bid];
                        if (businessEntity == nil) {
                            businessEntity = [NBusinessEntity NIM_createEntity];
                            businessEntity.bid = bid;
                            businessEntity.cid = OWNERID;
                            businessEntity.isPersonal = YES;
                            businessEntity.name = _IM_FormatStr(@"商家_%lld",bid);
                            
                        }
                        
                    }else{
                        VcardEntity *vcard = [VcardEntity instancetypeFindUserid:opUserId];
                        
                        if (vcard==nil) {
                            NSManagedObjectContext * privateContent = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
                            
                            vcard = [VcardEntity NIM_createEntity];
                            vcard.userid = opUserId;
                            vcard.userName = sendUserName;
                            vcard.avatar = USER_ICON_URL(opUserId);
                            
                            [privateContent MR_saveToPersistentStoreAndWait];
                            
                            
                        }else{
                            if (!vcard.avatar) {
                                vcard.avatar = [NSString stringWithFormat:@"https://user.qbcdn.com/user/avatar/queryAvata65/%lld/nosrc/1",opUserId];
                            }
                        }
                    }
                    
                }
                    break;
                case CERTIFY_BUSINESS:
                {
                    NBusinessEntity *businessEntity = [NBusinessEntity instancetypeFindBid:offcialid];
                    if (businessEntity == nil) {
                        businessEntity = [NBusinessEntity NIM_createEntity];
                        businessEntity.bid = bid;
                        businessEntity.cid = OWNERID;
                        businessEntity.isPersonal = NO;
                        businessEntity.name = _IM_FormatStr(@"企业商家_%lld",bid);
                        
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
            dic_obj[@"T"]=messageBodyId;
            
            ChatEntity *chatEntity = [ChatEntity instancetypeWithJsonDic:dic_obj];
            if (chatEntity) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP object:chatEntity];
            }
            [ChatListEntity instancetypeWithMessageBodyId:chatEntity isRemind:isRemind];
        }else{
            [[NIMGroupOperationBox sharedInstance] recvGroupModifyChangeRQWithResponse:object];
        }
    }
    
    
    
    NSInteger uCount = 0;
    
    uCount = [[NIMMsgCountManager sharedInstance] GetAllUnreadCount];
    if (uCount < 100) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_UCOUNT object:@(uCount)];
    }
    
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];

}






- (void)updateTaskHelperWithUnFinishNum:(NSInteger)num{
//    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//    [privateContext performBlock:^{
//        ChatListEntity *recordListEntity = [ChatListEntity instancetypeForTaskHelper];
//        recordListEntity.badge = num;
//        recordListEntity.ct = [NIMBaseUtil GetServerTime]/1000;
//        NSString *taskPreview = @"今日任务已完成";
//        if (num > 0) {
//            taskPreview =  [NSString stringWithFormat:@"还有%ld个任务没有完成哦!",(long)num];
//        }
//        recordListEntity.preview = taskPreview;
//
//        //TODO:save
//        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
//    }];
}

- (void)makeTaskHelper{//任务助手
//    ChatListEntity *recordListEntity = [ChatListEntity instancetypeForTaskHelper];
//    //TODO:save
//    [[recordListEntity managedObjectContext] MR_saveToPersistentStoreAndWait];
//    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
        
}





//TODO:每次登录之后整理数据
- (void)arrangeTheneworder{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    [privateContext performBlock:^{
        //            NProfileEntity *profileEntity = [NProfileEntity instancetypeWithCurrentLogin];
        
        NSPredicate *pregroup = [NSPredicate predicateWithFormat:@"switchnotify == 0"];
        NSArray *listALL = [GroupList NIM_findAllWithPredicate:pregroup];
        
        NSMutableArray *source = [NSMutableArray array];
        for (GroupList *item in listALL)
        {
            [source addObject:item.messageBodyId];
        }
        
        NSArray *list = [ChatListEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(badge > 0) AND (isflod == 0) AND (chatType != 2) AND (messageBodyId != %@) AND (messageBodyId != %@) OR ((messageBodyId in %@))", @"1:2014:386864", @"2:2014:386864",source]];
        //            NSArray *list = [NRecordList findAllWithPredicate:[NSPredicate predicateWithFormat:@"badge > 0"]];
        
        
        NSInteger uCount = 0;
        for (ChatListEntity *entity in list) {
            uCount += entity.badge;
        }
        //            profileEntity.newMessageBadge = uCount;
        //TODO:save
        
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        //                [delegate setBadgeValue:[NSString stringWithFormat:@"%ld",(long)uCount] withIndex:1];
        //            });
        
        //            [[QBControllerMediator mediator] updateRedpoint:uCount];
        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    }];
}


//TODO:下载音频文件
- (void)downloadAudioRecordEntity:(ChatEntity *)recordEntity success:(void (^)(BOOL success))success
{
    if ([self.downloadDict objectForKey:@(recordEntity.messageId)]) {
        return;
    }else{
        [self.downloadDict setObject:@(recordEntity.userId) forKey:@(recordEntity.messageId)];
    }
    E_MSG_M_TYPE m_type = recordEntity.mtype;
    if (m_type != VOICE &&
        m_type != IMAGE &&
        m_type != VIDEO) {
        return;
    }
    
    NSString *fileUrl;
    NSString *filePath;
    NSString *cacheDirectory;;
    
    __block NSString *messageId = [NSString stringWithFormat:@"%lld",recordEntity.messageId];
    
    if (m_type == IMAGE) {
        ImageEntity *theImgEntity = recordEntity.imageFile;
        if (theImgEntity.thumb.length == 0) {
            return;
        }
        cacheDirectory = [[NIMCoreDataManager currentCoreDataManager] recordPathImg];
        
        fileUrl = theImgEntity.thumb;
        filePath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",messageId]];
    }else if (m_type == VOICE){
        AudioEntity *theAudioEntity = recordEntity.audioFile;
        if (theAudioEntity.url.length == 0) {
            return;
        }
        cacheDirectory = [[NIMCoreDataManager currentCoreDataManager] recordPathMp3];
        
        fileUrl = theAudioEntity.url;
        filePath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",messageId]];
        
    } else {
        VideoEntity *theVideoEntity = recordEntity.videoFile;
        if (theVideoEntity.thumbUrl.length == 0) {
            return;
        }
        cacheDirectory = [[NIMCoreDataManager currentCoreDataManager] recordPathMov];
        
        fileUrl = [SSIMSpUtil holderImgURL:theVideoEntity.thumbUrl];;
        filePath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",messageId]];
    }
    
    dispatch_async(self.download_queue_t, ^{
        
        void (^nOperateDownloadAudioBlock)(NSString *cachePath,NSInteger downloadStatus);
        nOperateDownloadAudioBlock = ^(NSString *cachePath,NSInteger downloadStatus)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                ChatEntity *recordEntity = [ChatEntity findFirstWithMessageId:messageId.longLongValue];
                
                NSString* filePath = nil;
                
                if (downloadStatus == 1) {
                    success(YES);
                    NSString* fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
                    filePath = [cachePath stringByReplacingOccurrencesOfString:fullPath withString:@""];
                    if (m_type == IMAGE) {
                        ImageEntity *imgEntity = recordEntity.imageFile;
                        UIImage *image = [UIImage imageWithContentsOfFile:cachePath];
                        int64_t msgid = recordEntity.messageId;
                        [NIMBaseUtil cacheImage:image mid:msgid];
                        imgEntity.file = [NIMBaseUtil thumbImageDocMsgId:msgid];
                        imgEntity.bigFile = [NIMBaseUtil bigImageDocMsgId:msgid];
                        recordEntity.imageFile = imgEntity;
                    }else if (m_type == VOICE){
                        AudioEntity *audioEntity = recordEntity.audioFile;
                        audioEntity.file = filePath;
                        recordEntity.audioFile = audioEntity;
                    } else {
                        VideoEntity *videoEntity = recordEntity.videoFile;
                        videoEntity.file = filePath;
                        recordEntity.videoFile = videoEntity;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NIMMessageManager sharedInstance] updateMessage:recordEntity isPost:YES isChange:NO];

                    });
                    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
                    
                    
                } else if(downloadStatus == 0){
                    success(NO);
                }
                
            });
            
        };
        //        NSString *cacheDirectory = [[NIMCoreDataManager currentCoreDataManager] recordPathMp3];
        //        NSString *filePath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",messageId]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            nOperateDownloadAudioBlock(filePath,1);
        }else{
            nOperateDownloadAudioBlock(nil,2);
            NSString *uuid  = [NSString stringWithFormat:@"%lld",recordEntity.messageId];
            [self downloadAudioWithRecordUUID:uuid url:fileUrl type:(E_MSG_M_TYPE)m_type completeBlock:^(id object, NIMResultMeta *result) {
                
                if (result) {
                    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                        NSError *error;
                        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                    }
                    nOperateDownloadAudioBlock(nil,0);
                    [self.downloadDict removeObjectForKey:@(recordEntity.messageId)];
                }else{
                    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                        nOperateDownloadAudioBlock(filePath,1);
                    }else{
                        nOperateDownloadAudioBlock(nil,0);
                        [self.downloadDict removeObjectForKey:@(recordEntity.messageId)];
                    }
                }
                
                
            }];
        }
    });
}



- (void)downloadAudioWithRecordUUID:(NSString *)uuid  url:(NSString *)url type:(E_MSG_M_TYPE)type completeBlock:(CompleteBlock)completeBlock{
    NSString *downloadUrl = url;
    NSString *downloadPath;
    
    if (type == IMAGE) {
        
        NSString *cacheDirectory = [[NIMCoreDataManager currentCoreDataManager] recordPathImg];
        downloadPath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",uuid]];
        
    }else if (type == VOICE){
        NSString *cacheDirectory = [[NIMCoreDataManager currentCoreDataManager] recordPathMp3];
        downloadPath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",uuid]];
    } else {
        NSString *cacheDirectory = [[NIMCoreDataManager currentCoreDataManager] recordPathMov];
        downloadPath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",uuid]];
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrl]];
    //检查文件是否已经下载了一部分
    unsigned long long downloadedBytes = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
        //获取已下载的文件长度
        downloadedBytes = [self fileSizeForPath:downloadPath];
        if (downloadedBytes > 0) {
            NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
            [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
            request = mutableURLRequest;
        }
    }
    //不使用缓存，避免断点续传出现问题
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    
    
    //下载请求
    /*
     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
     //下载路径
     operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadPath append:YES];
     //下载进度回调
     [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
     //下载进度
     //        float progress = ((float)totalBytesRead + downloadedBytes) / (totalBytesExpectedToRead + downloadedBytes);
     }];
     //成功和失败回调
     [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     DBLog(@"%@",responseObject);
     if (completeBlock) {
     completeBlock(downloadPath,nil);
     }
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     DBLog(@"%@",error);
     completeBlock(downloadPath,[NIMResultMeta resultWithCode:QBIMErrorData error:@"" message:@"下载音频失败"]);
     }];
     operation.completionQueue = self.download_queue_t;
     operation.completionGroup = self.httpRequest_group_t;
     [operation start];
     */
    //下载请求
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //下载路径
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error == nil) {
            completeBlock(downloadPath,nil);
        }else{
            completeBlock(downloadPath,[NIMResultMeta resultWithCode:(int32_t)httpResponse.statusCode error:@"" message:@"下载音频失败"]);
        }
    }];
    manager.completionQueue = self.download_queue_t;
    manager.completionGroup = self.httpRequest_group_t;
    [task resume];
    
}


//获取已下载的文件大小
- (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}


-(void)flagReadRecordEntityMsgID:(uint64_t)msgid
{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    [privateContext performBlock:^{
        ChatEntity *recordEntity = [ChatEntity findFirstWithMessageId:msgid];
        if (recordEntity.audioFile) {
            if (!recordEntity.audioFile.read) {
                recordEntity.audioFile.read = YES;
            }
            
            if (recordEntity.audioFile.state == QIMMessageStatuPlaying) {
                recordEntity.audioFile.state = QIMMessageStatuStopped;
            }
        }
        [privateContext MR_saveToPersistentStoreAndWait];
    }];
}



//清空未读计数
-(void)resetRecordListThread:(NSString *)thread isHomePageShow:(BOOL)isHomePageShow
{
    int64_t session_id = [NIMStringComponents getOpuseridWithMsgBodyId:thread];
    E_MSG_CHAT_TYPE chat_type = [NIMStringComponents chatTypeWithMsgBodyId:thread];
    [[NIMMsgCountManager sharedInstance] RemoveUnreadCount:session_id chat_type:chat_type];
}




//创建群助手
- (void)makeGroupAssistantPacket:(ChatListEntity *)list withUsePrivew:(BOOL)use
{
    
    ChatListEntity * oklist = list;
    
    //TODO:save
    ChatListEntity *recordListEntity1 = [ChatListEntity instancetypeForGroupAssistantPacket:oklist];
    
    if (use) {
        
        recordListEntity1.preview = oklist.preview;
        recordListEntity1.badge = 0;
        recordListEntity1.groupAssistantRead = 0;
    }
    else
    {
        NSPredicate *pregroup = [NSPredicate predicateWithFormat:@"switchnotify == %d and memberid=%lld",GROUP_MESSAGE_IN_HELP_NO_HIT,OWNERID];
        NSArray *glist = [GroupList NIM_findAllWithPredicate:pregroup];
        
        NSMutableArray *source = [NSMutableArray array];
        for (GroupList *item in glist)
        {
            [source addObject:item.messageBodyId];
        }
        
        NSPredicate *pd = [NSPredicate predicateWithFormat:@"(messageBodyId in %@) AND (groupAssistantRead == 1)",source];
        
        NSFetchedResultsController *fc = [ChatListEntity  NIM_fetchAllGroupedBy:@"messageBodyId" withPredicate:pd sortedBy:@"ct" ascending:NO delegate:nil];
        
        NSInteger unreadcount = fc.sections.count;
        
        if (unreadcount == 0) {
            unreadcount = oklist.groupAssistantRead;
        }
        
        recordListEntity1.badge = unreadcount;
        recordListEntity1.groupAssistantRead = unreadcount;
        
        
        if (unreadcount != 0)
        {
            recordListEntity1.preview = [NSString stringWithFormat:@"[%ld个群发来新消息]",(long)unreadcount];
        }
        else
        {
            recordListEntity1.preview = [oklist.preview copy];
        }
        
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}




- (void)deleteGroupAssistant
{
    dispatch_async(self.coredata_queue_t, ^{
        NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
        [privateContext performBlock:^{
            //更新群助手显示
            ChatListEntity *recordListEntity1 = [ChatListEntity findFirstWithMessageBodyId:kGroupAssistantThread];
            
            [recordListEntity1 NIM_deleteEntity];
            
            [[recordListEntity1 managedObjectContext] MR_saveToPersistentStoreAndWait];
            
        }];
    });
}



- (ChatEntity *)getfoldGroupAtLeastTime
{
    //获取折叠的群id
    NSPredicate *foldgroups = [NSPredicate predicateWithFormat:@"switchnotify == %d and memberid == %lld",GROUP_MESSAGE_IN_HELP_NO_HIT,OWNERID];
    NSArray *glist = [GroupList NIM_findAllWithPredicate:foldgroups];
    NSMutableArray *gids = [NSMutableArray array];
    for (GroupList *item in glist) {
        [gids addObject:[NSString stringWithFormat:@"%lld",item.groupId]];
    }
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"groupId in %@",gids];
    
    NSArray *rs = [ChatEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:filter];
    
    if (rs.count > 0) {
        return [rs firstObject];
    }
    
    return nil;
}


- (BOOL)checkIsCanDeleteGroupAssistant
{
    BOOL OK = YES;
    
    //查折叠群
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"switchnotify == %d and memberid == %lld",GROUP_MESSAGE_IN_HELP_NO_HIT,OWNERID];
    NSArray *list = [GroupList NIM_findAllWithPredicate:pre];
    NSMutableArray *source = [NSMutableArray array];
    for (GroupList *item in list)
    {
        [source addObject:item.messageBodyId];
    }
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"messageBodyId in %@",source];
    
    NSFetchedResultsController *fs = [ChatListEntity NIM_fetchAllGroupedBy:@"topAlign" withPredicate:filter sortedBy:@"ct" ascending:NO delegate:nil];
    
    //只要有通知或折叠群，则群组手就不能删除
    
    if (fs.fetchedObjects.count > 0)
    {
        OK = NO;
    }
    
    
    return OK;
}


//更新群助手
- (void)updateGroupAssistant:(NSString *)preview
{
    dispatch_async(self.coredata_queue_t, ^{
        NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
        [privateContext performBlock:^{
            
            NSLog(@"---------------> 已更新群助手preview == %@",preview);
            
            //更新群助手显示
            ChatListEntity *recordListEntity1 = [ChatListEntity findFirstWithMessageBodyId:kGroupAssistantThread];
            
            if (recordListEntity1)
            {
                recordListEntity1.preview = preview;
                recordListEntity1.badge = 0;
                recordListEntity1.groupAssistantRead = 0;
                
                //把所有大于0的更新为0
                NSPredicate *pflag = [NSPredicate predicateWithFormat:@"groupAssistantRead > 0 and userId == %lld",OWNERID];
                
                NSArray *glist = [ChatListEntity NIM_findAllWithPredicate:pflag];
                
                [glist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ChatListEntity *item = obj;
                    item.groupAssistantRead = 0;
                }];
                
                [privateContext MR_saveToPersistentStoreAndWait];
            }
        }];
    });
}


- (NSString *)getPreviewForGroupAssistantBy:(ChatEntity *)chatitem
{
    NSMutableString *preview = [[NSMutableString alloc] init];
    
    switch (chatitem.mtype) {
        case TEXT:
            [preview appendFormat:@"%@",chatitem.msgContent];
            break;
        case ITEM:
            [preview appendString:@"[链接]"];
            break;
        case IMAGE:
            [preview appendString:@"[图片]"];
            break;
        case VOICE:
            [preview appendString:@"[声音]"];
            break;
        case SMILEY:
            [preview appendString:@"[动态表情]"];
            break;
        case JSON:
        {
            switch (chatitem.stype) {
                case RED_PACKET:
                    [preview appendString:@"[红包]"];
                    break;
                case ORDER:
                    [preview appendString:@"[订单]"];
                    break;
                case VCARD:
                    [preview appendString:@"[名片]"];
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case MAP:
            [preview appendString:@"[地理位置]"];
            break;
        default:
            break;
    }
    
    return preview;
}


//创建/更新公众号助手
- (void)makePublicPacketShow:(ChatListEntity *)list{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    [privateContext performBlock:^{
        //TODO:save
        ChatListEntity *recordListEntity = [ChatListEntity instancetypeForPublicPacket:list];
        [[recordListEntity managedObjectContext] MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
    }];
}

//创建我的店铺
- (void)makeShopAssistantPacketShow:(ChatListEntity *)chatList isRevMsg:(BOOL)isRevMsg
{
    //TODO:save
    ChatListEntity *recordListEntity = [ChatListEntity instancetypeForShopAssistantPacket:chatList];
    
    [[recordListEntity managedObjectContext] MR_saveToPersistentStoreAndWait];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}

//更新店铺消息
- (void)updateShopAssistantWithChatent:(ChatListEntity *)chatlistEnt withPre:(NSString * )preView{
    
    
    ChatListEntity *recordListEntity = [ChatListEntity  findFirstWithMessageBodyId:kShopThread];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"(chatType = %d || chatType = %d) AND userId = %lld",SHOP_BUSINESS,CERTIFY_BUSINESS,OWNERID];
    
    NSArray * businessArr = [ChatListEntity NIM_findAllWithPredicate:pre];
    
    if (businessArr.count == 0) {
        recordListEntity.preview = @"暂无商家消息";
    }else{
        NSPredicate *lastPre = [NSPredicate predicateWithFormat:@"(chatType = %d || chatType = %d) AND userId = %lld",SHOP_BUSINESS,CERTIFY_BUSINESS,OWNERID];
        
        NSArray * msgArr = [ChatEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:lastPre];
        ChatEntity * lastMsg = msgArr[0];
        
        ChatListEntity *recordListEntity = [ChatListEntity instancetypeForShopAssistantPacket:chatlistEnt];
        NSArray * unreadArr = [ChatListEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"shopAssistantRead > 0 and userId == %lld",OWNERID]];
        
        if (unreadArr.count != 0)
        {
            recordListEntity.preview = [NSString stringWithFormat:@"[%ld个店铺有新消息]",unreadArr.count];
        }else{
            if (lastMsg.isSender != 1) {
                recordListEntity.preview = [NSString stringWithFormat:@"商家%lld：%@",lastMsg.opUserId,preView];
            }else{
                recordListEntity.preview = preView;
            }
        }
    }
    [[recordListEntity managedObjectContext] MR_saveToPersistentStoreAndWait];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}

- (void)makeSubscribeHelper{//订阅助手
//    ChatListEntity *recordListEntity = [ChatListEntity instancetypeForSubscribeHelper];
//    //TODO:save
//    [[recordListEntity managedObjectContext] MR_saveToPersistentStoreAndWait];
//    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}

-(void)checkRecordStatus{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %lld and status = %d",OWNERID,QIMMessageStatuIsUpLoading];
    NSArray * all = [ChatEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:predicate];
    if(all.count!=0){
        for (ChatEntity *chatEntity in all) {
            if (chatEntity == nil) {
                return ;
            }
            chatEntity.status = QIMMessageStatuUpLoadFailed;
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];

        }
    }
    
    
}


#pragma mark getter
- (dispatch_group_t)httpRequest_group_t{
    if (!_httpRequest_group_t) {
        _httpRequest_group_t =  dispatch_group_create();
    }
    return _httpRequest_group_t;
}

- (dispatch_queue_t)httpRequest_queue_t{
    if (_httpRequest_queue_t == nil) {
        _httpRequest_queue_t = dispatch_queue_create("com.QianbaoSerialQueue.httpRequest", DISPATCH_QUEUE_SERIAL);
    }
    return _httpRequest_queue_t;
}
- (dispatch_queue_t)coredata_queue_t{
    if (_coredata_queue_t == nil) {
        _coredata_queue_t = dispatch_queue_create("com.QianbaoSerialQueue", DISPATCH_QUEUE_SERIAL);
        //        _coredata_queue_t = dispatch_get_main_queue();
    }
    return _coredata_queue_t;
}

- (dispatch_queue_t)download_queue_t{
    if (_download_queue_t == nil) {
        _download_queue_t = dispatch_queue_create("com.Qianbao.downloadQueue", DISPATCH_QUEUE_SERIAL);
        
    }
    return _download_queue_t;
}

@end
