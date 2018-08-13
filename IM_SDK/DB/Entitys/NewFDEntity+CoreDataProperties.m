//
//  NewFDEntity+CoreDataProperties.m
//  qbim
//
//  Created by 豆凯强 on 17/3/2.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NewFDEntity+CoreDataProperties.h"

@implementation NewFDEntity (CoreDataProperties)

+ (NSFetchRequest<NewFDEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NewFDEntity"];
}

@dynamic ownId;
@dynamic peerId;
@dynamic ct;
@dynamic isFriendNow;
@dynamic friendShip;
@dynamic extrInfo;

@end
