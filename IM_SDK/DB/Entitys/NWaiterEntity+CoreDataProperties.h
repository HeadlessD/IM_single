//
//  NWaiterEntity+CoreDataProperties.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/12.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NWaiterEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NWaiterEntity (CoreDataProperties)

+ (NSFetchRequest<NWaiterEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nonatomic) int64_t bid;
@property (nonatomic) int64_t cid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t wid;

+ (instancetype)findFirstWithBid:(int64_t)bid wid:(int64_t)wid;
@end

NS_ASSUME_NONNULL_END
