//
//  NIMManager.h
//  QianbaoIM
//
//  Created by liu nian on 6/7/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMLoginUserInfo.h"

@class NVcardEntity;
@class NIMMessageContent;
@class NContactEntity;
@class GroupList;
@class NRecordEntity;
@class FeedEntity;


@interface NIMManager : NSObject
@property (nonatomic, strong,readonly ) NIMLoginUserInfo *loginUserInfo;

+ (instancetype)sharedImManager;
- (void)cleanHttpCookie;

//TODO:语音、图片上传
- (void)postFile:(id)file userid:(int64_t)userid toId:(int64_t)toId msgid:(int64_t)msgid fileType:(int)fileType completeBlock:(CompleteBlock)completeBlock;

//TODO:Fetch User
- (void)fetchInfoByUserid:(int64_t)userID CompleteBlock:(CompleteBlock)completeBlock;

- (void)fetchInfoByUseridt:(int64_t)userID CompleteBlock:(CompleteBlock)completeBlock;

- (void)fetchMobileByUserid:(int64_t)userID CompleteBlock:(CompleteBlock)completeBlock;

//登录之后获取自己的用户信息
- (void)fetchSelfUsesrInfoCompleteBlock:(CompleteBlock)completeBlock;


//TODO:获取趣味相投的人列表
- (void)fetchInterestListCompleteBlock:(CompleteBlock)completeBlock;

- (void)fetchInterestListCompleteBlocknew:(CompleteBlock)completeBlock;


- (void)fetchInfoByUserName:(NSString *)userName CompleteBlock:(CompleteBlock)completeBlock;

- (void)fetchUserNameByUserId:(int64_t)userId CompleteBlock:(CompleteBlock)completeBlock;

- (void)fetchUserNameByMobileOrEmail:(NSString *)MEM CompleteBlock:(CompleteBlock)completeBlock;


- (void)fetchInfoByFriendsUserid:(int64_t)userID postDic:(NSDictionary *)dict CompleteBlock:(CompleteBlock)completeBlock;

- (void)fetchWidsWithBid:(int64_t)bid CompleteBlock:(CompleteBlock)completeBlock;

- (void)uploadGroupIcon:(id)file groupid:(uint64_t)groupid completeBlock:(CompleteBlock)completeBlock;

- (void)uploadUserIcon:(id)file userid:(uint64_t)userid completeBlock:(CompleteBlock)completeBlock;

- (void)fetchOrdersWithSellerId:(int64_t)sellerId buyId:(int64_t)buyId CompleteBlock:(CompleteBlock)completeBlock;
- (void)uploadArticle:(id)file articleId:(int64_t)articleId index:(int)index  completeBlock:(CompleteBlock)completeBlock;
@end

