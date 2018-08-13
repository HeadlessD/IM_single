//
//  PhoneBookEntity+CoreDataProperties.h
//  QBNIMClient
//
//  Created by 豆凯强 on 2017/8/21.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "PhoneBookEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PhoneBookEntity (CoreDataProperties)

+ (NSFetchRequest<PhoneBookEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nonatomic) int64_t ct;
@property (nullable, nonatomic, copy) NSString *firstLitter;
@property (nullable, nonatomic, copy) NSString *fullAllLitter;
@property (nullable, nonatomic, copy) NSString *fullLitter;
@property (nonatomic) BOOL isQbao;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phoneNum;
@property (nullable, nonatomic, copy) NSString *sectionName;
@property (nullable, nonatomic, copy) NSString *sha1;
@property (nullable, nonatomic, copy) NSString *sorted;
@property (nonatomic) int64_t userid;
@property (nullable, nonatomic, copy) NSString *fullCNLitter;
@property (nullable, nonatomic, copy) NSString *spare;
@property (nullable, nonatomic, retain) FDListEntity *fdList;
@property (nullable, nonatomic, retain) VcardEntity *vcard;

+ (instancetype)findFirstWithPredicate:(NSPredicate*)predicate;

@end

NS_ASSUME_NONNULL_END
