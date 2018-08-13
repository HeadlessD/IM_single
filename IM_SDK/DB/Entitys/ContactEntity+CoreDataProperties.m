//
//  ContactEntity+CoreDataProperties.m
//  qbim
//
//  Created by 秦雨 on 17/2/21.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "ContactEntity+CoreDataProperties.h"

@implementation ContactEntity (CoreDataProperties)

+ (NSFetchRequest<ContactEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ContactEntity"];
}

@dynamic ct;
@dynamic messageBodyId;
@dynamic userid;
@dynamic vcard;

@end
