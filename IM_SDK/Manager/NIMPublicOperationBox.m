//
//  NIMPublicOperationBox.m
//  QianbaoIM
//
//  Created by liu nian on 8/5/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMPublicOperationBox.h"
#import "NIMManager.h"
//#import "NRecordEntity.h"
//#import "PublicEntity.h"
//#import "NIMMessageContent.h"
//#import "NIMMessageCenter.h"

@implementation NIMPublicOperationBox

- (void)dealloc
{
    DLog(@"%s", __FUNCTION__);
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

SingletonImplementation(NIMPublicOperationBox);

#pragma mark private methods
- (void)opreateMakePublics:(NSArray *)publics completeBlock:(CompleteBlock)completeBlock{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    [privateContext performBlockAndWait:^{
        [publics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSDictionary *dict = obj;
            //IMUserRoleType roleType = [[dict objectForKey:@"role"] integerValue];
//           PublicEntity *public =[PublicEntity instancetypeWithHttpResponse:dict];
//            public.thread = [NSString stringWithFormat:@"3:%.0f:%lld",public.publicid,OWNERID];
//            public.subscribed = 1;
//            if (roleType == IMUserRoleTypePublic) {
//                [PublicEntity instancetypeWithHttpResponse:dict];
//            }
        }];
//        [privateContext MR_saveOnlySelfAndWait];
        [privateContext MR_saveToPersistentStoreAndWait];
    }];
    if (completeBlock) {
        completeBlock(publics,nil);
    }
}

- (void)opreateBeDeletedPublic:(double)publicid completeBlock:(CompleteBlock)completeBlock{
//    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//    [privateContext performBlockAndWait:^{
//        PublicEntity *publicEntity = [PublicEntity instancetypeWithPublic:publicid];
//        if (publicEntity) {
////            [publicEntity NIM_deleteEntity];
//        }
//        [privateContext MR_saveOnlySelfAndWait];
//    }];
    if (completeBlock) {
        completeBlock(nil,[NIMResultMeta resultWithCode:QBIMErrorData error:@"" message:@"公众号已停用"]);
    }
}

- (void)opreateUpdatePublic:(double )publicid fans:(NSArray *)fans completeBlock:(CompleteBlock)completeBlock{
//    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//    [privateContext performBlockAndWait:^{
//        PublicEntity *publicEntity = [PublicEntity instancetypeWithPublic:publicid fans:fans];
//        [[publicEntity managedObjectContext] MR_saveOnlySelfAndWait];
//    }];
    if (completeBlock) {
        completeBlock([NSNumber numberWithDouble:publicid],nil);
    }
}


- (void)subscribe:(BOOL)subscribe public:(double)publicid  completeBlock:(CompleteBlock)completeBlock{
//    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//    [privateContext performBlockAndWait:^{
//        PublicEntity *publicEntity = [PublicEntity instancetypeWithPublic:publicid];
//        
//        if (publicEntity == nil) {
//            publicEntity = [PublicEntity getEntity];
//        }
//        
////        int64_t ownerid = [NIMManager sharedImManager].owerid;
//        NSString *thread = [NIMStringComponents createMsgBodyIdWithType:PUBLIC  toId:publicid];
//        [publicEntity setThread:thread];
//        publicEntity.publicid = publicid;
//        if (subscribe)
//        {
//            if (publicEntity.subscribed == 0)
//            {
//                [publicEntity setSubscribed:1];
//            }
//        }
//        else
//        {
//            if (publicEntity.subscribed == 2)
//            {
//                
//            }
//            else if(publicEntity.subscribed == 1)
//            {
//                [publicEntity setSubscribed:0];
//            }
//        }
//        
////        [publicEntity setSubscribed:subscribe];
//        [privateContext MR_saveOnlySelfAndWait];
//    }];
    if (completeBlock) {
        completeBlock([NSNumber numberWithDouble:publicid],nil);
    }
}

#pragma mark public methods
- (void)fetchPublic:(double)publicid completeBlock:(CompleteBlock)completeBlock{

    void (^fetchFriendModelBlock)(id object, NIMResultMeta *result);
    fetchFriendModelBlock = ^(id object, NIMResultMeta *result)
    {
        if (result) {
            completeBlock(object,result);
        }else{
            NSDictionary *friendInfo = nil;
            if (object && [object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseData = object;
                if ([responseData[@"user"] isKindOfClass:[NSNull class]]) {
                    [self opreateBeDeletedPublic:publicid completeBlock:completeBlock];
                }else{
                    friendInfo = PUGetObjFromDict(@"user", responseData, [NSDictionary class]);
                    if (friendInfo) {
                        [self opreateMakePublics:@[friendInfo] completeBlock:completeBlock];
                    }else{
                        completeBlock(object,result);
                    }
                }
          
            }
        }
    };
    if (publicid == OWNERID) {
//        [self httpRequestMethod:HttpMethodGet url:@"users/self" parameters:nil completeBlock:^(id object, NIMResultMeta *result) {
//            fetchFriendModelBlock(object,result);
//        }];
    }else{
        
//        [self httpRequestMethod:HttpMethodGet url:[NSString stringWithFormat:@"users/%0.f",publicid] parameters:nil completeBlock:^(id object, NIMResultMeta *result) {
//            fetchFriendModelBlock(object,result);
//        }];
    }
    
    
}
- (void)fetchFansPublicid:(double)publicid offset:(NSInteger)offset completeBlock:(CompleteBlock)completeBlock{
    
    /*
    NSMutableDictionary *parameters = @{}.mutableCopy;
    [parameters setObject:[NSNumber numberWithDouble:publicid]  forKey:@"pubid"];
    [parameters setObject:[NSNumber numberWithInteger:offset]  forKey:@"offset"];
    [parameters setObject:[NSNumber numberWithInteger:100]  forKey:@"limit"];
    
    [self httpRequestMethod:HttpMethodPost url:kAPI_FANS parameters:parameters completeBlock:^(id object, NIMResultMeta *result) {
        if (result) {
            completeBlock(object,result);
        }else{
            NSArray *items = nil;
            if (object && [object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDic = object;
                items = [responseDic objectForKey:@"items"];
                [self opreateUpdatePublic:publicid fans:items completeBlock:completeBlock];
            }
        }
    }];
     */
}

- (void)subscribePublic:(double)publicid andSource:(NSInteger )source completeBlock:(CompleteBlock)completeBlock{
    /*
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithDouble:publicid] forKey:@"pubid"];
    [params setObject:IsStrEmpty(source)?@"":source forKey:@"source"];
    [self httpRequestMethod:HttpMethodPost url:kAPI_PUBLIC_SUBSCRIBE parameters:params completeBlock:^(id object, NIMResultMeta *result) {
        if (result) {
            completeBlock(object,result);
        }else{
            //[self subscribe:YES public:publicid completeBlock:completeBlock];
            completeBlock([NSNumber numberWithDouble:publicid],nil);
        }
    }];
     */
}

- (void)unsubscribePublic:(double)publicid completeBlock:(CompleteBlock)completeBlock{
    /*
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithDouble:publicid] forKey:@"pubid"];
    [self httpRequestMethod:HttpMethodPost url:kAPI_PUBLIC_UNSUBSCRIBE parameters:params completeBlock:^(id object, NIMResultMeta *result) {
        if (result) {
            completeBlock(object,result);
        }else{
            [self subscribe:NO public:publicid completeBlock:completeBlock];
        }
    }];
     */
}
- (void)fetchPublicsCompleteBlock:(CompleteBlock)completeBlock{
    /*
    [self httpRequestMethod:HttpMethodGet url:kAPI_PUBLIC parameters:nil completeBlock:^(id object, NIMResultMeta *result) {

        if (result) {
            completeBlock(object,result);
        }else{
            NSMutableArray *publics = nil;
            if (object && [object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseData = object;
                NSArray *items = PUGetObjFromDict(@"items", responseData, [NSArray class]);
                publics = [NSMutableArray arrayWithArray:items];
                [self opreateMakePublics:publics completeBlock:completeBlock];
            }
        }
    }];
     */

}

- (void)fetchLocalPublicOffset:(NSInteger )offset count:(NSInteger)count completeBlock:(CompleteBlock)completeBlock{
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@""];
    
}

- (void)fetchPublicFans:(double)publicid offset:(NSInteger)offset limit:(NSInteger)limit completeBlock:(CompleteBlock)completeBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithDouble:publicid] forKey:@"pubid"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    /*
    [self httpRequestMethod:HttpMethodPost url:kAPI_FANS parameters:params completeBlock:^(id object, NIMResultMeta *result) {
        if(result)
        {
            completeBlock(nil,result);
        }
        else
        {
            if([object isKindOfClass:[NSDictionary class]])
            {
                 NSArray* fans = [object  objectForKey:@"items"];
//                if(![NIMMessageCenter shared].isQbaoLoginSuccess)
//                {
                    completeBlock(fans,result);

//                }
//                else
//                {
//                    [self opreateUpdatePublic:publicid fans:fans completeBlock:completeBlock];
//                }
               
                
            }
            else
            {
                completeBlock(object,result);
            }
        }
    }];
*/
}

- (void)fetchPublicRecommendandParameters:(NSDictionary *)parameters WithcompleteBlock:(CompleteBlock)completeBlock
{
    
//    [self httpRequestMethod:HttpMethodGet url:kAPI_PUBLIC_RECOMMEND parameters:parameters completeBlock:^(id object, NIMResultMeta *result) {
//        completeBlock(object,result);
//    }];
}

- (void)switchPublicWithPubid:(double)pubid switchValue:(BOOL)switchValue completeBlock:(CompleteBlock)completeBlock
{
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithDouble:pubid] forKey:@"pubid"];
    [params setObject:[NSNumber numberWithBool:!switchValue] forKey:@"switch"];
    
//    [self httpRequestMethod:HttpMethodPost url:kAPI_SWITCH_PUBLIC parameters:params completeBlock:^(id object, NIMResultMeta *result) {
//        completeBlock(object,result);
//    }];

}

//TODO:公众号模糊搜索
- (void)publicSearchKeyWord:(NSString*)keywords offset:(NSInteger)offset limit:(NSInteger)limit completeBlock:(CompleteBlock)completeBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:keywords forKey:@"keyword"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    /*
    [self httpRequestMethod:HttpMethodGet
                        url:kAPI_PUBLIC_SEARCH
                 parameters:params
              completeBlock:^(id object, NIMResultMeta *result) {
                  completeBlock(object,result);
              }];
     */
}

//TODO:获取频道公众号组
- (void)fetchPublicChannelWithCompleteBlock:(CompleteBlock)completeBlock
{
    /*
    [self httpRequestMethod:HttpMethodGet
                        url:kAPI_PUBLIC_CHANNEL
                 parameters:nil
              completeBlock:^(id object, NIMResultMeta *result) {
                  completeBlock(object,result);
              }];
     */
}

@end
