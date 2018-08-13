//
//  TextEntity+CoreDataProperties.m
//  qbim
//
//  Created by 秦雨 on 17/2/15.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "TextEntity+CoreDataProperties.h"

@implementation TextEntity (CoreDataProperties)

+ (NSFetchRequest<TextEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TextEntity"];
}

@dynamic text;
@dynamic chatRecord;

@end
