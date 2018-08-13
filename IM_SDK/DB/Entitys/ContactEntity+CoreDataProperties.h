//
//  ContactEntity+CoreDataProperties.h
//  qbim
//
//  Created by 秦雨 on 17/2/21.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "ContactEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ContactEntity (CoreDataProperties)

+ (NSFetchRequest<ContactEntity *> *)fetchRequest;

@property (nonatomic) int64_t ct;
@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nonatomic) int64_t userid;
@property (nullable, nonatomic, retain) VcardEntity *vcard;

@end

NS_ASSUME_NONNULL_END
