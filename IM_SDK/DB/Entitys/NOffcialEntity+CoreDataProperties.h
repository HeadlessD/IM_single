//
//  NOffcialEntity+CoreDataProperties.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/7/14.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NOffcialEntity+CoreDataClass.h"
#import "NIMOffcialInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NOffcialEntity (CoreDataProperties)

+ (NSFetchRequest<NOffcialEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t offcialid;
@property (nonatomic) int64_t fansid;
@property (nullable, nonatomic, retain) ChatEntity *chatRecord;

+ (instancetype)findFirstWithOffcialid:(int64_t)offcialid;
+ (instancetype)findFirstWithMsgBodyId:(NSString *)msgBodyId;
+ (instancetype)instancetypeWithOffcialInfo:(NIMOffcialInfo *)offcialInfo;

@end

NS_ASSUME_NONNULL_END
