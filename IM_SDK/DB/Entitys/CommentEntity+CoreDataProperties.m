//
//  CommentEntity+CoreDataProperties.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/6.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "CommentEntity+CoreDataProperties.h"

@implementation CommentEntity (CoreDataProperties)

+ (NSFetchRequest<CommentEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CommentEntity"];
}

@dynamic commentId;
@dynamic userId;
@dynamic userNick;
@dynamic replyUserId;
@dynamic replyUserNick;
@dynamic content;
@dynamic ct;
@dynamic commentType;
@dynamic articleUserId;
@dynamic articleId;

+(instancetype)instancetypeWithCommentItem:(DFLineCommentItem *)item
{
    CommentEntity* commentEntity = [CommentEntity findFirstWithCommentId:item.commentId];
    if (commentEntity) {
        return nil;
    }
    commentEntity = [CommentEntity NIM_createEntity];
    commentEntity.commentId = item.commentId;
    commentEntity.userId = item.userId;
    commentEntity.userNick = item.userNick;
    commentEntity.replyUserId = item.replyUserId;
    commentEntity.replyUserNick = item.replyUserNick;
    commentEntity.commentType = item.commentType;
    commentEntity.articleUserId = item.articleUserId;
    commentEntity.ct = item.createTime;
    commentEntity.articleId = item.articleId;
    commentEntity.content = item.content;
    return commentEntity;
}

+(instancetype)findFirstWithCommentId:(int64_t)commentId
{
    return [self NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"commentId = %lld",commentId]];
}

+(void)deleteCommentWithCommentId:(int64_t)commentId
{
    CommentEntity* commentEntity = [CommentEntity findFirstWithCommentId:commentId];
    if (commentEntity) {
        [commentEntity NIM_deleteEntity];
        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    }
}

+(NSArray *)findAllCommentWithArtitleId:(int64_t)articleId
{
    NSArray *arr = [CommentEntity NIM_findAllSortedBy:@"ct" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"articleId = %lld",articleId]];
    return arr;
}
@end
