//
//  NIMMomentsManager.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/4.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMMomentsManager.h"
#import "NetCenter.h"
#import "NIMGlobalProcessor.h"
#import "NIMManager.h"
@implementation NIMMomentsManager
SingletonImplementation(NIMMomentsManager)

- (id)init
{
    self = [super init];
    if(self){
        _user_dict = [[NSMutableDictionary alloc]initWithCapacity: 10];
        _comment_dict = [[NSMutableDictionary alloc]initWithCapacity: 10];
        _moment_dict = [[NSMutableDictionary alloc]initWithCapacity: 10];
        _moment_arr = [[NSMutableArray alloc]initWithCapacity: 10];
        _user_arr = [[NSMutableArray alloc]initWithCapacity: 10];
        _setItem = [[DFSettingItem alloc] init];
    }
    return self;
}


-(void)sendMomentsArticleRQ:(DFBaseLineItem *)item
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor sendMomentsArticleRQ:item];
}

-(void)deleteMomentsArticleRQ:(DFBaseLineItem *)item
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor deleteMomentsArticleRQ:item];
}

-(void)sendMomentsTimelineQueryRQ:(int64_t)userid startTime:(int64_t)startTime endTime:(int64_t)endTime
{
    _isDetail = NO;
    [[NIMGlobalProcessor sharedInstance].momentsProcessor sendMomentsTimelineQueryRQ:userid startTime:startTime endTime:endTime];
}

-(void)sendMomentsCommentAddRQ:(DFLineCommentItem *)commentItem
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor sendMomentsCommentAddRQ:commentItem];
}

-(void)deleteMomentsCommentRQ:(DFLineCommentItem *)commentItem
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor deleteMomentsCommentRQ:commentItem];
}

-(void)sendQueryMomentsRQ:(int64_t)friendid endTime:(int64_t)endTime
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor sendQueryMomentsRQ:friendid endTime:endTime];
}

-(void)settingModifyRQ:(DFSettingItem *)item
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor settingModifyRQ:item];
}

-(void)settingQueryRQ:(int64_t)userid
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor settingQueryRQ:userid];
}


-(void)settingBlacknotcarelistModifyRQ:(List_Type)type list:(NSString *)list
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor settingBlacknotcarelistModifyRQ:type list:list];
}

-(void)queryPicArticle:(int64_t)userid
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor queryPicArticle:userid];
}

-(void)sendMomentsIdsQueryRQ:(NSArray *)timelines
{
    [[NIMGlobalProcessor sharedInstance].momentsProcessor sendMomentsIdsQueryRQ:timelines];
}

/*********************************************这是内存处理分割线*********************************************/


//内存处理
-(DFTextImageLineItem *)createTextImage:(NSString *)text images:(NSArray *)images
{
    VcardEntity * ownVcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userid=%lld",OWNERID]];
    NSString *name = [ownVcard defaultName];
    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
    textImageItem.itemId = [[NetCenter sharedInstance] CreateMsgID]; //随便设置一个 待服务器生成
    textImageItem.userId = OWNERID;
    textImageItem.userAvatar = USER_ICON_URL(OWNERID);
    textImageItem.userNick = name;
    textImageItem.title = @"";
    textImageItem.text = text;
    textImageItem.ts = [NIMBaseUtil GetServerTime]/1000;
    if (images.count>0) {
        textImageItem.contentType = Moments_Content_Type_TextImg;
    }else{
        textImageItem.contentType = Moments_Content_Type_Text;
    }
    NSMutableArray *srcImages = [NSMutableArray array];
    textImageItem.srcImages = srcImages; //大图 可以是本地路径 也可以是网络地址 会自动判断
    
    NSMutableArray *thumbImages = [NSMutableArray array];
    textImageItem.thumbImages = thumbImages; //小图 可以是本地路径 也可以是网络地址 会自动判断
    
    for (id img in images) {
        [srcImages addObject:img];
        [thumbImages addObject:img];
    }
//    textImageItem.location = @"金色洗脚城";
    return textImageItem;
}


-(DFVideoLineItem *)createVideoItem:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot
{
    VcardEntity * ownVcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userid=%lld",OWNERID]];
    NSString *name = [ownVcard defaultName];
    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
    videoItem.itemId = [[NetCenter sharedInstance] CreateMsgID]; //随便设置一个 待服务器生成
    videoItem.userId = OWNERID;
    videoItem.userAvatar = USER_ICON_URL(OWNERID);
    videoItem.userNick = name;
    videoItem.title = @"";
    videoItem.text = text; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
    
    videoItem.localVideoPath = videoPath;
    videoItem.videoUrl = @""; //网络路径
    videoItem.thumbUrl = @"";
    videoItem.thumbImage = screenShot; //如果thumbImage存在 优先使用thumbImage
    videoItem.ts = [NIMBaseUtil GetServerTime]/1000;
    videoItem.contentType = Moments_Content_Type_Video;
    return videoItem;

}



//增
-(void)insertBottomArticleItem:(DFBaseLineItem *)item
{
    NSString *key = _IM_FormatStr(@"%lld",item.itemId);
    if ([_moment_dict objectForKey:key]==nil) {
//        [_moment_arr insertObject:textImage atIndex:0];
//        [_moment_arr addObject:item];
        NSInteger index = -1;
        for (NSInteger i=_moment_arr.count-1; i>=0; i--) {
            DFBaseLineItem *preItem = [_moment_arr objectAtIndex:i];
            if (item.ts<preItem.ts) {
                index = i;
                break;
            }
            continue;
        }
        if (index == -1) {
            [_moment_arr insertObject:item atIndex:0];
        }else{
            [_moment_arr insertObject:item atIndex:index+1];
        }
    }else{
        DFBaseLineItem *preItem = [_moment_dict objectForKey:key];
        NSUInteger index = [_moment_arr indexOfObject:preItem];
        [_moment_arr replaceObjectAtIndex:index withObject:item];

    }
    [_moment_dict setObject:item forKey:key];
//    MomentEntity *entity = [MomentEntity instancetypeWithMomentItem:item];
//    if (entity) {
//        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
//    }
}

//增
-(void)insertTopArticleItem:(DFBaseLineItem *)item
{
    NSString *key = _IM_FormatStr(@"%lld",item.itemId);
    if ([_moment_dict objectForKey:key]==nil) {
//        DFBaseLineItem *preItem = _moment_arr.firstObject;
        int index = -1;
        for (int i=0; i<_moment_arr.count; i++) {
            DFBaseLineItem *preItem = [_moment_arr objectAtIndex:i];
            if (item.ts>preItem.ts) {
                index = i;
                break;
            }
            continue;
        }
        if (index == -1) {
            [_moment_arr addObject:item];
        }else{
            [_moment_arr insertObject:item atIndex:index];
        }
//        for (DFBaseLineItem *preItem in _moment_arr) {
//            if (item.ts>preItem.ts) {
//                [_moment_arr insertObject:item atIndex:0];
//            }else{
//                [_moment_arr insertObject:item atIndex:1];
//            }
//        }
        
    }else{
        DFBaseLineItem *preItem = [_moment_dict objectForKey:key];
        NSUInteger index = [_moment_arr indexOfObject:preItem];
        [_moment_arr replaceObjectAtIndex:index withObject:item];
    }
    [_moment_dict setObject:item forKey:key];
//    MomentEntity *entity = [MomentEntity instancetypeWithMomentItem:item];
//    if (entity) {
//        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
//    }
    
}

//删
-(void)deleteItem:(int64_t)itemId
{
    NSString *key = _IM_FormatStr(@"%lld",itemId);
    DFBaseLineItem *item = [self getItem:itemId];
    [_moment_arr removeObject:item];
    [_moment_dict removeObjectForKey:key];
    [MomentEntity deleteWithMomentId:itemId];
}


//改
-(void)updateTextImage:(DFBaseLineItem *)item itemId:(int64_t)itemId
{
    NSString *key = _IM_FormatStr(@"%lld",itemId);
    if ([_moment_dict objectForKey:key]!=nil) {
        [_moment_dict setObject:item forKey:key];
    }
}

//查
-(DFBaseLineItem *)getItem:(int64_t) itemId
{
    return [self.moment_dict objectForKey:_IM_FormatStr(@"%lld",itemId)];
}


-(void)deleteMomentsWithUserid:(int64_t)userid
{
    if (_moment_arr.count>0) {
        [_moment_arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DFBaseLineItem *item = obj;
            if (item.userId == userid) {
                *stop = YES;
                if (*stop == YES) {
                    NSString *key = _IM_FormatStr(@"%lld",item.itemId);
                    [_moment_dict removeObjectForKey:key];
                    [_moment_arr removeObjectAtIndex:idx];
                }
            }
        }];
    }
}

/************评论***********/

//增
-(void)insertLikeItem:(DFLineCommentItem *)item
{
    NSString *key = _IM_FormatStr(@"%lld",item.userId);
    [_comment_dict setObject:item forKey:key];
//    CommentEntity *entity = [CommentEntity instancetypeWithCommentItem:item];
//    if (entity) {
//        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
//    }
}

//删
-(void)deleteLikeItem:(int64_t)userid
{
    NSString *key = _IM_FormatStr(@"%lld",userid);
    [_comment_dict removeObjectForKey:key];
    DFLineCommentItem *item = [_comment_dict objectForKey:key];
    [CommentEntity deleteCommentWithCommentId:item.commentId];
}


//查
-(DFLineCommentItem *)getLikeItem:(int64_t)userid
{
    return [_comment_dict objectForKey:_IM_FormatStr(@"%lld",userid)];
}

//增
-(void)insertCommentItem:(DFLineCommentItem *)item
{
    NSString *key = _IM_FormatStr(@"%lld",item.commentId);
    [_comment_dict setObject:item forKey:key];
//    CommentEntity *entity = [CommentEntity instancetypeWithCommentItem:item];
//    if (entity) {
//        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
//    }
}

//删
-(void)deleteCommentItem:(int64_t)commentId
{
    NSString *key = _IM_FormatStr(@"%lld",commentId);
    [_comment_dict removeObjectForKey:key];
    [CommentEntity deleteCommentWithCommentId:commentId];
}

//查
-(DFLineCommentItem *)getCommentItem:(int64_t) itemId
{
    return [self.comment_dict objectForKey:_IM_FormatStr(@"%lld",itemId)];
}




/********************用户朋友模块********************/
//增
-(void)insertUserItem:(DFBaseUserLineItem *)item
{
    NSString *key = _IM_FormatStr(@"%lld",item.itemId);
    if ([_user_dict objectForKey:key]==nil) {
        [_user_arr addObject:item];
    }else{
        DFBaseUserLineItem *uItem = [_user_dict objectForKey:key];
        NSUInteger index = [_user_arr indexOfObject:uItem];
        [_user_arr replaceObjectAtIndex:index withObject:item];
    }
    [_user_dict setObject:item forKey:key];
}

//删
-(void)deleteUserItem:(int64_t)itemId
{
    NSString *key = _IM_FormatStr(@"%lld",itemId);
    DFBaseUserLineItem *item = [self getUserItem:itemId];
    [_user_dict removeObjectForKey:key];
    [_user_arr removeObject:item];
}

//查
-(DFBaseUserLineItem *)getUserItem:(int64_t) itemId
{
    return [_user_dict objectForKey:_IM_FormatStr(@"%lld",itemId)];
}

-(NSArray *)loadMomentData
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:10];
    for (NSString *key in _moment_dict.allKeys) {
        DFBaseLineItem *item = [_moment_dict objectForKey:key];
        [items addObject:item];
    }
    return items;
}

-(void)clear
{
    [_moment_dict removeAllObjects];
    [_comment_dict removeAllObjects];
    [_user_dict removeAllObjects];
    [_user_arr removeAllObjects];
    [_moment_arr removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
}


//朋友圈图片列表下载
-(void)down:(NSArray *)superImages textImage:(DFTextImageLineItem *)textImage
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<superImages.count-1; i++) {
        // 创建信号量
        dispatch_group_async(group, queue, ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[NIMManager sharedImManager] uploadArticle:superImages[i] articleId:textImage.itemId index:i completeBlock:^(id object, NIMResultMeta *result) {
                if (object) {
                    NSString *url = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,[object objectForKey:@"url"]);
                    [images addObject:url];
                }else{
                    
                }
                // 发送信号量
                dispatch_semaphore_signal(semaphore);
            }];
            // 在请求成功之前等待信号量
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        textImage.srcImages = images;
        textImage.thumbImages = images;
        textImage.content = [images componentsJoinedByString:@"#"];
        [[NIMMomentsManager sharedInstance] sendMomentsArticleRQ:textImage];
    });
}




-(void) genLikeAttrString:(DFBaseLineItem *) item
{
    if (item.likes.count == 0) {
        return;
    }
    
    if (item.likesStr == nil) {
        NSMutableArray *likes = item.likes;
        NSString *result = @"";
        
        for (int i=0; i<likes.count;i++) {
            DFLineCommentItem *like = [likes objectAtIndex:i];
            if (i == 0) {
                result = [NSString stringWithFormat:@"%@",like.userNick];
            }else{
                result = [NSString stringWithFormat:@"%@, %@", result, like.userNick];
            }
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
        NSUInteger position = 0;
        for (int i=0; i<likes.count;i++) {
            DFLineCommentItem *like = [likes objectAtIndex:i];
            [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)like.userId] range:NSMakeRange(position, like.userNick.length)];
            position += like.userNick.length+2;
        }
        
        item.likesStr = attrStr;
    }
    
}

-(void) genCommentAttrString:(DFBaseLineItem *)item
{
    NSMutableArray *comments = item.comments;
    
    [item.commentStrArray removeAllObjects];
    
    for (int i=0; i<comments.count;i++) {
        DFLineCommentItem *comment = [comments objectAtIndex:i];
        
        NSString *resultStr;
        FDListEntity *fd = [FDListEntity instancetypeFindFriendId:comment.userId];
        NSString *name = @"";
        if (!IsStrEmpty(fd.fdRemarkName)) {
            name = fd.fdRemarkName;
        } else {
            VcardEntity *vcard = [VcardEntity instancetypeFindUserid:comment.userId];
            name = vcard.defaultName;
        }
        if (!IsStrEmpty(name)) {
            comment.userNick = name;
        }
        if (comment.replyUserId == 0) {
            resultStr = [NSString stringWithFormat:@"%@: %@",comment.userNick, comment.content];
        }else{
            if (![comment.replyUserNick isEqualToString:@"我"]) {
                FDListEntity *fd = [FDListEntity instancetypeFindFriendId:comment.replyUserId];
                NSString *name = @"";
                if (!IsStrEmpty(fd.fdRemarkName)) {
                    name = fd.fdRemarkName;
                } else {
                    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:comment.replyUserId];
                    name = vcard.defaultName;
                }
                if (!IsStrEmpty(name)) {
                    comment.replyUserNick = name;
                }
            }
            resultStr = [NSString stringWithFormat:@"%@回复%@: %@",comment.userNick, comment.replyUserNick, comment.content];
        }
        
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc]initWithString:resultStr];
        if (comment.replyUserId == 0) {
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(0, comment.userNick.length)];
        }else{
            NSUInteger localPos = 0;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(localPos, comment.userNick.length)];
            localPos += comment.userNick.length + 2;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.replyUserId] range:NSMakeRange(localPos, comment.replyUserNick.length)];
        }
        
        NSLog(@"ffff: %@", resultStr);
        
        [item.commentStrArray addObject:commentStr];
    }
}


/*********************************************这是落库处理分割线*********************************************/
-(void)loadMomentDataWithUserId:(int64_t)userId offset:(NSInteger)offset
{
    NSArray *arr = [MomentEntity findMomentsWithUserId:userId offset:offset];
    for (MomentEntity *entity in arr) {
        DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
        textImageItem.itemId = entity.mid; //
        textImageItem.userId = entity.userId;
        textImageItem.userAvatar = USER_ICON_URL(entity.userId);
        textImageItem.userNick = entity.userNick;
        textImageItem.contentType = (Moments_Content_Type)entity.contentType;
        textImageItem.text = entity.text;
        
        Moments_Content_Type type = textImageItem.contentType;
        if (type == Moments_Content_Type_TextImg) {
            NSString *content = entity.content;
            if (!IsStrEmpty(content)) {
                NSArray *srcImages = [content componentsSeparatedByString:@"#"];
                NSMutableArray *images = [NSMutableArray arrayWithCapacity:5];
                for (NSString *src in srcImages) {
                    if (IsStrEmpty(src)) {
                        continue;
                    }
                    NSString *imageSrc = src;
                    if (![imageSrc containsString:@"http"]&&![imageSrc containsString:@"https"]) {
                        imageSrc = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,src);
                    }
                    [images addObject:imageSrc];
                }
                textImageItem.srcImages = [NSMutableArray arrayWithArray:images]; //大图 可以是本地路径 也可以是网络地址 会自动判断
                textImageItem.thumbImages = [NSMutableArray arrayWithArray:images]; //小图 可以是本地路径 也可以是网络地址 会自动判断
            }
        }
        textImageItem.ts = entity.ct;
        textImageItem.location = entity.location;
        [[NIMMomentsManager sharedInstance] insertBottomArticleItem:textImageItem];
        [self loadCommentData:textImageItem];
    }
}


-(void)loadCommentData:(DFTextImageLineItem *)item
{
    NSArray *arr = [CommentEntity findAllCommentWithArtitleId:item.itemId];
    for (CommentEntity *entity in arr) {
        Comment_Type type = (Comment_Type)entity.commentType;
        DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
        commentItem.commentId = entity.commentId;
        commentItem.userId = entity.userId;
        commentItem.userNick = entity.userNick;
        commentItem.content = entity.content;
        commentItem.commentType = type;
        commentItem.articleUserId = entity.articleUserId;
        commentItem.articleId = entity.articleId;
        commentItem.createTime = entity.ct;
        
        if(type==Comment_Type_Comment){
            int64_t commentedUserId = entity.replyUserId;
            if(commentedUserId>0){
                commentItem.replyUserId = commentedUserId;
                if(!IsStrEmpty(entity.replyUserNick)){
                    commentItem.replyUserNick = entity.replyUserNick;
                }
            }
            [item.comments addObject:commentItem];
            [[NIMMomentsManager sharedInstance] genCommentAttrString:item];
            [[NIMMomentsManager sharedInstance] insertCommentItem:commentItem];
        }else if(type==Comment_Type_Like){
            [item.likes addObject:commentItem];
            [[NIMMomentsManager sharedInstance] genLikeAttrString:item];
            [[NIMMomentsManager sharedInstance] insertLikeItem:commentItem];
            [[NIMMomentsManager sharedInstance] insertCommentItem:commentItem];
        }
        
    }
}

-(void)deleteMomentsInNotCare:(NSString *)listStr
{
    NSArray *list = [listStr componentsSeparatedByString:@","];
    for (NSString *idStr in list) {
        [self deleteMomentsWithUserid:idStr.longLongValue];
        [MomentEntity NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"userId = %lld AND ownerId = %lld",idStr.longLongValue,OWNERID]];
        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    }
}



-(void)onLike:(int64_t)itemId
{
    //点赞
    DFLineCommentItem *lItem = [[NIMMomentsManager sharedInstance] getLikeItem:OWNERID];
    if (lItem) {
        [[NIMMomentsManager sharedInstance] deleteMomentsCommentRQ:lItem];
    }else{
        VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
        DFLineCommentItem *likeItem = [[DFLineCommentItem alloc] init];
        likeItem.commentId = [NIMBaseUtil GetServerTime]/1000;
        likeItem.userId = OWNERID;
        likeItem.userNick = [card defaultName];
        likeItem.createTime = [NIMBaseUtil GetServerTime]/1000;
        likeItem.commentType = Comment_Type_Like;
        DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:itemId];
        likeItem.articleId = item.itemId;
        likeItem.articleUserId = item.userId;
        [[NIMMomentsManager sharedInstance] sendMomentsCommentAddRQ:likeItem];
    }
}

@end
