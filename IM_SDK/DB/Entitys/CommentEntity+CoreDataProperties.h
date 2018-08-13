//
//  CommentEntity+CoreDataProperties.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/6.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "CommentEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CommentEntity (CoreDataProperties)

+ (NSFetchRequest<CommentEntity *> *)fetchRequest;

@property (nonatomic) int64_t commentId;
@property (nonatomic) int64_t userId;
@property (nullable, nonatomic, copy) NSString *userNick;
@property (nonatomic) int64_t replyUserId;
@property (nullable, nonatomic, copy) NSString *replyUserNick;
@property (nullable, nonatomic, copy) NSString *content;
@property (nonatomic) int64_t ct;
@property (nonatomic) int32_t commentType;
@property (nonatomic) int64_t articleUserId;
@property (nonatomic) int64_t articleId;

+(instancetype)instancetypeWithCommentItem:(DFLineCommentItem *)item;
+(instancetype)findFirstWithCommentId:(int64_t)commentId;
+(void)deleteCommentWithCommentId:(int64_t)commentId;
+(NSArray *)findAllCommentWithArtitleId:(int64_t)articleId;
@end

NS_ASSUME_NONNULL_END
