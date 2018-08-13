//
//  Location+CoreDataProperties.h
//  qbim
//
//  Created by 秦雨 on 17/2/15.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "Location+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nullable, nonatomic, retain) ChatEntity *chatRecord;

@end

NS_ASSUME_NONNULL_END
