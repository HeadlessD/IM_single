//
//  NewFDEntity+CoreDataProperties.h
//  qbim
//
//  Created by 豆凯强 on 17/3/2.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NewFDEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NewFDEntity (CoreDataProperties)

+ (NSFetchRequest<NewFDEntity *> *)fetchRequest;

@property (nonatomic) int64_t ownId;
@property (nonatomic) int64_t peerId;
@property (nonatomic) int64_t ct;
@property (nonatomic) BOOL isFriendNow;
@property (nonatomic) int64_t friendShip;
@property (nullable, nonatomic, copy) NSString *extrInfo;

@end

NS_ASSUME_NONNULL_END
