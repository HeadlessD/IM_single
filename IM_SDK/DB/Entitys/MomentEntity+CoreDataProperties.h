//
//  MomentEntity+CoreDataProperties.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/5.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "MomentEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MomentEntity (CoreDataProperties)

+ (NSFetchRequest<MomentEntity *> *)fetchRequest;

@property (nonatomic) int64_t mid;
@property (nonatomic) int32_t contentType;
@property (nonatomic) int64_t userId;
@property (nullable, nonatomic, copy) NSString *userNick;
@property (nullable, nonatomic, copy) NSString *location;
@property (nonatomic) int64_t ct;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *text;
@property (nonatomic) int32_t priType;
@property (nullable, nonatomic, copy) NSString *whiteList;
@property (nullable, nonatomic, copy) NSString *blackList;
@property (nonatomic) int64_t ownerId;

+(instancetype)instancetypeWithMomentItem:(DFBaseLineItem *)item;
+(instancetype)findFirstWithMomentId:(int64_t)mid;
+(void)deleteWithMomentId:(int64_t)mid;
+(NSArray *)findMomentsWithUserId:(int64_t)userId offset:(NSInteger)offset;
@end

NS_ASSUME_NONNULL_END
