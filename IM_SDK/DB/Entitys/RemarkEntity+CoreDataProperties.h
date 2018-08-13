//
//  RemarkEntity+CoreDataProperties.h
//  qbim
//
//  Created by 秦雨 on 17/5/4.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "RemarkEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RemarkEntity (CoreDataProperties)

+ (NSFetchRequest<RemarkEntity *> *)fetchRequest;

@property (nonatomic) int64_t userid;
@property (nonatomic) int64_t ct;
@property (nullable, nonatomic, copy) NSString *content;
@property (nonatomic) int64_t groupid;
+ (instancetype)instancetypeFindgroupid:(int64_t)groupid;

@end

NS_ASSUME_NONNULL_END
