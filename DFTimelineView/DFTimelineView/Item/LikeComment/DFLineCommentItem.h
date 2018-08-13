//
//  DFLineCommentItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//


@interface DFLineCommentItem : NSObject

@property (nonatomic, assign) int64_t commentId;

@property (nonatomic, assign) int64_t userId;

@property (nonatomic, strong) NSString *userNick;

@property (nonatomic, assign) int64_t replyUserId;

@property (nonatomic, strong) NSString *replyUserNick;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) int64_t createTime;

@property (nonatomic, assign) Comment_Type commentType;

@property (nonatomic, assign) int64_t articleUserId;

@property (nonatomic, assign) int64_t articleId;

@end
