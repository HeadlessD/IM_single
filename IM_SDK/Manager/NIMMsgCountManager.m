//
//  NIMMsgCountManager.m
//  SSIMSDK
//
//  Created by shiyunjie on 2017/12/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMMsgCountManager.h"
@interface NIMMsgCountManager()
-(NSString*) GenPrimaryKey:(long) session_id chat_type:(int) chat_type;
@end


@implementation NIMMsgCountManager

static NSString * const CLASS_NAME = @"NIMMsgCountManager";

SingletonImplementation(NIMMsgCountManager)

- (id)init
{
    self = [super init];
    sc_count_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];
    gc_count_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];
    oc_count_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];
    bc_count_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];
    ec_count_dic = [[NSMutableDictionary alloc]initWithCapacity: 100];

    return self;
}

- (void)dealloc
{
    [self Clear:NO];
    sc_count_dic = nil;
    gc_count_dic = nil;
    oc_count_dic = nil;
    bc_count_dic = nil;
    ec_count_dic = nil;
}

-(void)Load
{
    NSLog(@"加载start%f",[[NSDate date] timeIntervalSince1970]);
    //todo load from db;
    NSArray *db_array = [NUnreadEntity MR_findAllInContext:[[NIMCoreDataManager currentCoreDataManager]privateObjectContext]];
    for (NUnreadEntity *entity in db_array)
    {
        switch (entity.chatType)
        {
            case PRIVATE:
                {
                    [sc_count_dic setObject:entity forKey:@(entity.sesssionid)];
                }
                break;
            case GROUP:
                {
                    [gc_count_dic setObject:entity forKey:@(entity.sesssionid)];
                }
                break;
            case PUBLIC:
                {
                    [oc_count_dic setObject:entity forKey:@(entity.sesssionid)];
                }
                break;
            case SHOP_BUSINESS:
            {
                [bc_count_dic setObject:entity forKey:@(entity.sesssionid)];
            }
                break;
            case CERTIFY_BUSINESS:
            {
                [ec_count_dic setObject:entity forKey:@(entity.sesssionid)];
            }
                break;
            default:
                break;
        }
    }
    NSLog(@"加载end%f",[[NSDate date] timeIntervalSince1970]);

}

-(void)Clear: (BOOL)clear_db
{
    [sc_count_dic removeAllObjects];
    [gc_count_dic removeAllObjects];
    [oc_count_dic removeAllObjects];
    [bc_count_dic removeAllObjects];
    [ec_count_dic removeAllObjects];
    if(clear_db)
        [NUnreadEntity NIM_deleteAllMatchingPredicate:nil];
}

-(int)UpsertUnreadCount:(int64_t) session_id chat_type:(int) chat_type unread_count:(int) unread_count
{
    NUnreadEntity *entity = nil;
    switch (chat_type)
    {
        case PRIVATE:
            {
                entity = [sc_count_dic objectForKey: @(session_id)];
                if(!entity)
                {
                    entity = [NUnreadEntity NIM_createEntity];
                    entity.sesssionid = session_id;
                    entity.messageBodyId = [self GenPrimaryKey:session_id chat_type:chat_type];
                    entity.uCount = 0;
                }
                entity.uCount += unread_count;
                [sc_count_dic setObject:entity forKey: @(session_id)];
            }
            break;
        case GROUP:
            {
                entity = [gc_count_dic objectForKey:  @(session_id)];
                if(!entity)
                {
                    entity = [NUnreadEntity NIM_createEntity];
                    entity.sesssionid = session_id;
                    entity.messageBodyId = [self GenPrimaryKey:session_id chat_type:chat_type];
                    entity.uCount = 0;
                }
                entity.uCount += unread_count;
                [gc_count_dic setObject:entity forKey: @(session_id)];
            }
            break;
        case PUBLIC:
            {
                entity = [oc_count_dic objectForKey:  @(session_id)];
                if(!entity)
                {
                    entity = [NUnreadEntity NIM_createEntity];
                    entity.sesssionid = session_id;
                    entity.messageBodyId = [self GenPrimaryKey:session_id chat_type:chat_type];
                    entity.uCount = 0;
                }
                entity.uCount += unread_count;
                [oc_count_dic setObject:entity forKey: @(session_id)];
            }
            break;
        case SHOP_BUSINESS:
        {
            entity = [bc_count_dic objectForKey:  @(session_id)];
            if(!entity)
            {
                entity = [NUnreadEntity NIM_createEntity];
                entity.sesssionid = session_id;
                entity.messageBodyId = [self GenPrimaryKey:session_id chat_type:chat_type];
                entity.uCount = 0;
            }
            entity.uCount += unread_count;
            [bc_count_dic setObject:entity forKey: @(session_id)];
        }
            break;
        case CERTIFY_BUSINESS:
        {
            entity = [ec_count_dic objectForKey:  @(session_id)];
            if(!entity)
            {
                entity = [NUnreadEntity NIM_createEntity];
                entity.sesssionid = session_id;
                entity.messageBodyId = [self GenPrimaryKey:session_id chat_type:chat_type];
                entity.uCount = 0;
            }
            entity.uCount += unread_count;
            [ec_count_dic setObject:entity forKey: @(session_id)];
        }
            break;
        default:
            break;
    }
   
    [[entity managedObjectContext] MR_saveToPersistentStoreAndWait];
    
    return entity.uCount;
}

-(void)RemoveUnreadCount:(int64_t) session_id chat_type:(int) chat_type
{
    NUnreadEntity *entity = nil;
    switch (chat_type)
    {
        case PRIVATE:
            {
                entity = [sc_count_dic objectForKey: @(session_id)];
                [sc_count_dic removeObjectForKey: @(session_id)];
            }
            break;
        case GROUP:
            {
                entity = [gc_count_dic objectForKey: @(session_id)];
                [gc_count_dic removeObjectForKey: @(session_id)];
            }
            break;
        case PUBLIC:
            {
                entity = [oc_count_dic objectForKey: @(session_id)];
                [oc_count_dic removeObjectForKey: @(session_id)];
            }
            break;
        case SHOP_BUSINESS:
        {
            entity = [bc_count_dic objectForKey: @(session_id)];
            [bc_count_dic removeObjectForKey: @(session_id)];
        }
            break;
        case CERTIFY_BUSINESS:
        {
            entity = [ec_count_dic objectForKey: @(session_id)];
            [ec_count_dic removeObjectForKey: @(session_id)];
        }
            break;
        default:
            break;
    }
    if (!entity) {
        return;
    }
    [entity NIM_deleteEntity];
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    //改变db
}

-(int)GetUnreadCount:(int64_t) session_id chat_type:(int) chat_type
{
    NUnreadEntity *entity = nil;
    switch (chat_type)
    {
        case PRIVATE:
            entity = [sc_count_dic objectForKey: @(session_id)];
            break;
        case GROUP:
            entity = [gc_count_dic objectForKey: @(session_id)];
            break;
        case PUBLIC:
            entity = [oc_count_dic objectForKey: @(session_id)];
            break;
        case SHOP_BUSINESS:
            entity = [bc_count_dic objectForKey: @(session_id)];
            break;
        case CERTIFY_BUSINESS:
            entity = [ec_count_dic objectForKey: @(session_id)];
            break;
        default:
            break;
    }
    
    int count = entity == nil ? 0 : entity.uCount;
    return count;
}

-(int)SumSCCount
{
    int count = 0;
    for (NSNumber *key in sc_count_dic.allKeys)
    {
        NUnreadEntity *entity = [sc_count_dic objectForKey:key];
        if(entity)
        {
            count += entity.uCount;
        }
    }
    return count;
}

-(int)SumGCCount
{
    int count = 0;
    for (NSNumber *key in gc_count_dic.allKeys)
    {
        NUnreadEntity *entity = [gc_count_dic objectForKey:key];
        if(entity)
        {
            count += entity.uCount;
        }
    }
    return count;
}

-(int)SumOCCount
{
    int count = 0;
    for (NSNumber *key in oc_count_dic.allKeys)
    {
        NUnreadEntity *entity = [oc_count_dic objectForKey:key];
        if(entity)
        {
            count += entity.uCount;
        }
    }
    return count;
}

-(int)SumBCCount
{
    int count = 0;
    for (NSNumber *key in bc_count_dic.allKeys)
    {
        NUnreadEntity *entity = [bc_count_dic objectForKey:key];
        if(entity)
        {
            count += entity.uCount;
        }
    }
    return count;
}

-(int)SumECCount
{
    int count = 0;
    for (NSNumber *key in ec_count_dic.allKeys)
    {
        NUnreadEntity *entity = [ec_count_dic objectForKey:key];
        if(entity)
        {
            count += entity.uCount;
        }
    }
    return count;
}

-(int)GetAllUnreadCount
{
    int count = [self SumSCCount];
    count += [self SumGCCount];
    count += [self SumOCCount];
    count += [self SumBCCount];
    count += [self SumECCount];
    return count;
}

-(int)GetShowUnreadCount
{
    int count = [self SumSCCount];
    count += [self SumGCCount];
    count += [self SumOCCount];
    return count;
}

-(NSString *) GenPrimaryKey:(long) session_id chat_type:(int) chat_type
{
    NSString *primary_key = [NSString stringWithFormat:@"%ld_%d", session_id, chat_type];
    return primary_key;
}
@end
