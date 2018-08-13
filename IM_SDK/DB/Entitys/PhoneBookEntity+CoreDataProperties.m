//
//  PhoneBookEntity+CoreDataProperties.m
//  QBNIMClient
//
//  Created by 豆凯强 on 2017/8/21.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "PhoneBookEntity+CoreDataProperties.h"

@implementation PhoneBookEntity (CoreDataProperties)

+ (NSFetchRequest<PhoneBookEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PhoneBookEntity"];
}

@dynamic avatar;
@dynamic ct;
@dynamic firstLitter;
@dynamic fullAllLitter;
@dynamic fullLitter;
@dynamic isQbao;
@dynamic name;
@dynamic phoneNum;
@dynamic sectionName;
@dynamic sha1;
@dynamic sorted;
@dynamic userid;
@dynamic fullCNLitter;
@dynamic spare;
@dynamic fdList;
@dynamic vcard;


+ (instancetype)findFirstWithPredicate:(NSPredicate*)predicate
{
    NSManagedObjectContext* content = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:[[self class] description] inManagedObjectContext:content];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *objs = [content executeFetchRequest:request error:&error];
    if (error) {
        DBLog(@"%@",error);
    }
    for (NSManagedObject *obj in objs) {
        DBLog(@"%@",obj);
    }
    if(objs.count)
    {
        PhoneBookEntity* entity = (PhoneBookEntity*)[objs firstObject];
        return entity;
    }
    return nil;
}

@end
