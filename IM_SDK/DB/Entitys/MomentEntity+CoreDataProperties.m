//
//  MomentEntity+CoreDataProperties.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/5.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "MomentEntity+CoreDataProperties.h"

@implementation MomentEntity (CoreDataProperties)

+ (NSFetchRequest<MomentEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MomentEntity"];
}

@dynamic mid;
@dynamic contentType;
@dynamic userId;
@dynamic userNick;
@dynamic location;
@dynamic ct;
@dynamic content;
@dynamic text;
@dynamic priType;
@dynamic whiteList;
@dynamic blackList;
@dynamic ownerId;

+(instancetype)instancetypeWithMomentItem:(DFBaseLineItem *)item
{
    MomentEntity* momentEntity = [MomentEntity findFirstWithMomentId:item.itemId];
    if (momentEntity) {
        return nil;
    }
    momentEntity = [MomentEntity NIM_createEntity];
    momentEntity.mid = item.itemId;
    momentEntity.contentType = item.contentType;
    momentEntity.userId = item.userId;
    momentEntity.userNick = item.userNick;
    momentEntity.location = item.location;
    momentEntity.ct = item.ts;
    momentEntity.content = IsStrEmpty(item.content)?@"":item.content;
    momentEntity.text = item.text;
    momentEntity.priType = item.priType;
    momentEntity.blackList = item.blackList;
    momentEntity.whiteList = item.whiteList;
    momentEntity.ownerId = OWNERID;
    return momentEntity;
}

+(instancetype)findFirstWithMomentId:(int64_t)mid
{
    return [self NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"mid = %lld AND ownerId = %lld",mid,OWNERID]];
}

+(void)deleteWithMomentId:(int64_t)mid
{
    MomentEntity* momentEntity = [MomentEntity findFirstWithMomentId:mid];
    if (momentEntity) {
        [momentEntity NIM_deleteEntity];
        [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    }
}

+(NSArray *)findMomentsWithUserId:(int64_t)userId offset:(NSInteger)offset
{
    NSArray *arr = [MomentEntity NIM_executeFetchRequest:[NSPredicate predicateWithFormat:@"ownerId = %lld",userId] fetchOffset:offset fetchLimit:10];
    return arr;
}
@end
