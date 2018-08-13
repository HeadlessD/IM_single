//
//  MomentSetEntity+CoreDataProperties.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/7.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "MomentSetEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MomentSetEntity (CoreDataProperties)

+ (NSFetchRequest<MomentSetEntity *> *)fetchRequest;

@property (nonatomic) int64_t userId;
@property (nonatomic) BOOL listPicFree;
@property (nonatomic) int32_t momentsScope;
@property (nonatomic) BOOL momentsEnable;
@property (nonatomic) BOOL momentsNotice;
@property (nonatomic) int64_t ct;
@property (nullable, nonatomic, copy) NSString *blackList;
@property (nullable, nonatomic, copy) NSString *notCareList;

+(instancetype)instancetypeWithSetItem:(DFSettingItem *)item;

+(instancetype)findSetItemWithUserid:(int64_t)userId;


@end

NS_ASSUME_NONNULL_END
