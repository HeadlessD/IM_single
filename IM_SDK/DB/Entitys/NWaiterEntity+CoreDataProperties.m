//
//  NWaiterEntity+CoreDataProperties.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/12.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NWaiterEntity+CoreDataProperties.h"

@implementation NWaiterEntity (CoreDataProperties)

+ (NSFetchRequest<NWaiterEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NWaiterEntity"];
}

@dynamic avatar;
@dynamic bid;
@dynamic cid;
@dynamic name;
@dynamic wid;

+ (instancetype)findFirstWithBid:(int64_t)bid wid:(int64_t)wid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bid=%lld AND wid = %lld",bid,wid];
    return [self NIM_findFirstWithPredicate:predicate];
}

@end
