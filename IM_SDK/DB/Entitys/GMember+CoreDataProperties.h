//
//  GMember+CoreDataProperties.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/8/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "GMember+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GMember (CoreDataProperties)

+ (NSFetchRequest<GMember *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *card;
@property (nonatomic) int64_t ct;
@property (nullable, nonatomic, copy) NSString *fLitter;
@property (nullable, nonatomic, copy) NSString *fullLitter;
@property (nonatomic) int16_t groupIndex;
@property (nullable, nonatomic, copy) NSString *groupmembernickname;
@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nonatomic) int16_t role;
@property (nullable, nonatomic, copy) NSString *showName;
@property (nonatomic) int64_t userid;
@property (nullable, nonatomic, copy) NSString *allFullLitter;
@property (nullable, nonatomic, retain) GroupList *group;
@property (nullable, nonatomic, retain) VcardEntity *vcard;

+ (instancetype)instancetypeFindUserid:(int64_t)userid group:(GroupList *)groupEntiy;
+(instancetype)instancetypeWithMemberDic:(NSDictionary *)memberDic group:(GroupList *)groupEntiy;
@end

NS_ASSUME_NONNULL_END
