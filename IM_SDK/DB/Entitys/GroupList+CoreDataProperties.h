//
//  GroupList+CoreDataProperties.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/8/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "GroupList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GroupList (CoreDataProperties)

+ (NSFetchRequest<GroupList *> *)fetchRequest;

@property (nonatomic) int16_t addMax;
@property (nonatomic) BOOL apnswitch;
@property (nullable, nonatomic, copy) NSString *avatar;
@property (nonatomic) int16_t capacity;
@property (nonatomic) int64_t ct;
@property (nonatomic) int64_t groupId;
@property (nonatomic) BOOL isModifyName;
@property (nonatomic) int16_t membercount;
@property (nonatomic) int64_t memberid;
@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t ownerid;
@property (nonatomic) BOOL relation;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nonatomic) BOOL savedwitch;
@property (nullable, nonatomic, copy) NSString *selfcard;
@property (nonatomic) BOOL showname;
@property (nonatomic) int16_t switchnotify;
@property (nonatomic) int16_t type;
@property (nullable, nonatomic, copy) NSString *allFullLitter;
@property (nullable, nonatomic, copy) NSString *fullLitter;
@property (nullable, nonatomic, retain) NSSet<GMember *> *members;

+ (instancetype)instancetypeFindGroupId:(int64_t)groupId;
+ (instancetype)instancetypeFindMessageBodyId:(NSString *)messageBodyId;
+(instancetype)instancetypeWithJsonDic:(NSDictionary *)responseDic;
@end

@interface GroupList (CoreDataGeneratedAccessors)

- (void)addMembersObject:(GMember *)value;
- (void)removeMembersObject:(GMember *)value;
- (void)addMembers:(NSSet<GMember *> *)values;
- (void)removeMembers:(NSSet<GMember *> *)values;

@end

NS_ASSUME_NONNULL_END
