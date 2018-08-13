//
//  RemarkEntity+CoreDataProperties.m
//  qbim
//
//  Created by 秦雨 on 17/5/4.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "RemarkEntity+CoreDataProperties.h"

@implementation RemarkEntity (CoreDataProperties)

+ (NSFetchRequest<RemarkEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RemarkEntity"];
}

@dynamic userid;
@dynamic ct;
@dynamic content;
@dynamic groupid;

+(instancetype)instancetypeFindgroupid:(int64_t)groupid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupid=%lld", groupid];
    return [self NIM_findFirstWithPredicate:predicate];
}

@end
