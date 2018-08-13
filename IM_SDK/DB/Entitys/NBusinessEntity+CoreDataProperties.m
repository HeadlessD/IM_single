//
//  NBusinessEntity+CoreDataProperties.m
//  qbnimclient
//
//  Created by 秦雨 on 17/11/23.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NBusinessEntity+CoreDataProperties.h"

@implementation NBusinessEntity (CoreDataProperties)

+ (NSFetchRequest<NBusinessEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NBusinessEntity"];
}

@dynamic avatar;
@dynamic bid;
@dynamic cid;
@dynamic isPersonal;
@dynamic url;
@dynamic name;
@dynamic wids;

+ (instancetype)instancetypeFindBid:(int64_t)bid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bid=%lld",bid];
    return [self NIM_findFirstWithPredicate:predicate];
}

@end
