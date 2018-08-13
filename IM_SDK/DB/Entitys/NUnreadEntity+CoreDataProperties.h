//
//  NUnreadEntity+CoreDataProperties.h
//  SSIMSDK
//
//  Created by 秦雨 on 2017/12/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//
//

#import "NUnreadEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NUnreadEntity (CoreDataProperties)

+ (NSFetchRequest<NUnreadEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nonatomic) int16_t chatType;
@property (nonatomic) int16_t uCount;
@property (nonatomic) int64_t sesssionid;

+(instancetype)findFirstWithMessageBodyId:(NSString *)messageBodyId;
+(instancetype)findFirstWithSessionid:(int64_t)sesssionid;

@end

NS_ASSUME_NONNULL_END
