//
//  MomentSetEntity+CoreDataProperties.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/7.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "MomentSetEntity+CoreDataProperties.h"

@implementation MomentSetEntity (CoreDataProperties)

+ (NSFetchRequest<MomentSetEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MomentSetEntity"];
}

@dynamic userId;
@dynamic listPicFree;
@dynamic momentsScope;
@dynamic momentsEnable;
@dynamic momentsNotice;
@dynamic ct;
@dynamic blackList;
@dynamic notCareList;

+(instancetype)findSetItemWithUserid:(int64_t)userId
{
    return [self NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId = %lld",userId]];

}

+(instancetype)instancetypeWithSetItem:(DFSettingItem *)item
{
    MomentSetEntity* setEntity = [MomentSetEntity findSetItemWithUserid:item.userId];
    if (!setEntity) {
        setEntity = [MomentSetEntity NIM_createEntity];
        setEntity.userId = item.userId;
    }
    setEntity.listPicFree = item.listPicFree;
    setEntity.momentsScope = item.momentsScope;
    setEntity.momentsEnable = item.momentsEnable;
    setEntity.momentsNotice = item.momentsNotice;
    setEntity.ct = item.updateTime;
    setEntity.blackList = item.blackList;
    setEntity.notCareList = item.notCareList;
    return setEntity;
    
}

@end
