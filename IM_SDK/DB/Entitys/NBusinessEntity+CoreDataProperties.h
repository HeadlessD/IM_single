//
//  NBusinessEntity+CoreDataProperties.h
//  qbnimclient
//
//  Created by 秦雨 on 17/11/23.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NBusinessEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NBusinessEntity (CoreDataProperties)

+ (NSFetchRequest<NBusinessEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nonatomic) int64_t bid;
@property (nonatomic) int64_t cid;
@property (nonatomic) BOOL isPersonal;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSObject *wids;

+ (instancetype)instancetypeFindBid:(int64_t)bid;
@end

NS_ASSUME_NONNULL_END
