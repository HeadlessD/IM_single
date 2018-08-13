//
//  NOffcialEntity+CoreDataProperties.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/7/14.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NOffcialEntity+CoreDataProperties.h"

@implementation NOffcialEntity (CoreDataProperties)

+ (NSFetchRequest<NOffcialEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NOffcialEntity"];
}

@dynamic avatar;
@dynamic messageBodyId;
@dynamic name;
@dynamic offcialid;
@dynamic fansid;
@dynamic chatRecord;


+ (instancetype)findFirstWithOffcialid:(int64_t)offcialid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId=%@", [NIMStringComponents createMsgBodyIdWithType:PUBLIC  toId:offcialid]];
    return [self NIM_findFirstWithPredicate:predicate];
}

+ (instancetype)findFirstWithMsgBodyId:(NSString *)msgBodyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId=%@", msgBodyId];
    return [self NIM_findFirstWithPredicate:predicate];
}


+(instancetype)instancetypeWithOffcialInfo:(NIMOffcialInfo *)offcialInfo
{
    NOffcialEntity *offcialEntity = nil;
    offcialEntity = [NOffcialEntity findFirstWithOffcialid:offcialEntity.offcialid];
    if (offcialEntity == nil) {
        offcialEntity = [NOffcialEntity NIM_createEntity];
        offcialEntity.offcialid = offcialInfo.offcialid;
        offcialEntity.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PUBLIC  toId:offcialInfo.offcialid];
        offcialEntity.fansid = OWNERID;
    }
    offcialEntity.name = offcialInfo.name;
    offcialEntity.avatar = offcialInfo.avatar;
    return offcialEntity;
}



@end
