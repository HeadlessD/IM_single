//
//  NIMPublicOperationBox.h
//  QianbaoIM
//
//  Created by liu nian on 8/5/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMOperationBox.h"

@interface NIMPublicOperationBox : NIMOperationBox
SingletonInterface(NIMPublicOperationBox);

- (void)fetchPublic:(double)publicid completeBlock:(CompleteBlock)completeBlock;
- (void)fetchFansPublicid:(double)publicid offset:(NSInteger)offset completeBlock:(CompleteBlock)completeBlock;
- (void)subscribePublic:(double)publicid andSource:(NSInteger)source completeBlock:(CompleteBlock)completeBlock;
- (void)unsubscribePublic:(double)publicid completeBlock:(CompleteBlock)completeBlock;
- (void)fetchPublicsCompleteBlock:(CompleteBlock)completeBlock;
- (void)fetchPublicFans:(double)publicid offset:(NSInteger)offset limit:(NSInteger)limit completeBlock:(CompleteBlock)completeBlock;

- (void)fetchLocalPublicOffset:(NSInteger )offset count:(NSInteger)count completeBlock:(CompleteBlock)completeBlock;

- (void)fetchPublicRecommendandParameters:(NSDictionary *)parameters WithcompleteBlock:(CompleteBlock)completeBlock ;

//TODO:修改公众号提醒开关
- (void)switchPublicWithPubid:(double)pubid switchValue:(BOOL)switchValue completeBlock:(CompleteBlock)completeBlock;

//TODO:公众号模糊搜索
- (void)publicSearchKeyWord:(NSString*)keywords offset:(NSInteger)offset limit:(NSInteger)limit completeBlock:(CompleteBlock)completeBlock;

//TODO:获取频道公众号组
- (void)fetchPublicChannelWithCompleteBlock:(CompleteBlock)completeBlock;
@end
