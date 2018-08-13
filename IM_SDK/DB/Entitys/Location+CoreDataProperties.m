//
//  Location+CoreDataProperties.m
//  qbim
//
//  Created by 秦雨 on 17/2/15.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "Location+CoreDataProperties.h"

@implementation Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Location"];
}

@dynamic address;
@dynamic lat;
@dynamic lng;
@dynamic chatRecord;

@end
