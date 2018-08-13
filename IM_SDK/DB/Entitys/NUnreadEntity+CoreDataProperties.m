//
//  NUnreadEntity+CoreDataProperties.m
//  SSIMSDK
//
//  Created by 秦雨 on 2017/12/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//
//

#import "NUnreadEntity+CoreDataProperties.h"

@implementation NUnreadEntity (CoreDataProperties)

+ (NSFetchRequest<NUnreadEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NUnreadEntity"];
}

@dynamic messageBodyId;
@dynamic chatType;
@dynamic uCount;
@dynamic sesssionid;

+(instancetype)findFirstWithMessageBodyId:(NSString *)messageBodyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId=%@", messageBodyId];
    return [self NIM_findFirstWithPredicate:predicate];
}

+(instancetype)findFirstWithSessionid:(int64_t)sesssionid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sesssionid=%@", sesssionid];
    return [self NIM_findFirstWithPredicate:predicate];
}

@end
