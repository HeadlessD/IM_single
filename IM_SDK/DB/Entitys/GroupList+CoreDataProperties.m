//
//  GroupList+CoreDataProperties.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/8/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "GroupList+CoreDataProperties.h"

@implementation GroupList (CoreDataProperties)

+ (NSFetchRequest<GroupList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GroupList"];
}

@dynamic addMax;
@dynamic apnswitch;
@dynamic avatar;
@dynamic capacity;
@dynamic ct;
@dynamic groupId;
@dynamic isModifyName;
@dynamic membercount;
@dynamic memberid;
@dynamic messageBodyId;
@dynamic name;
@dynamic ownerid;
@dynamic relation;
@dynamic remark;
@dynamic savedwitch;
@dynamic selfcard;
@dynamic showname;
@dynamic switchnotify;
@dynamic type;
@dynamic allFullLitter;
@dynamic fullLitter;
@dynamic members;

+ (instancetype)instancetypeFindGroupId:(int64_t)groupId
{
    NSString *messageBodyId = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId = %@",messageBodyId];
    return [self NIM_findFirstWithPredicate:predicate];
}


+ (instancetype)instancetypeFindMessageBodyId:(NSString *)messageBodyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId = %@",messageBodyId];
    return [self NIM_findFirstWithPredicate:predicate];
}



+(instancetype)instancetypeWithJsonDic:(NSDictionary *)responseDic
{
    int64_t groupid = [[responseDic objectForKey:@"groupId"] longLongValue];
    NSString *name = [responseDic objectForKey:@"groupName"];
    
    NSString *messageBodyId = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid];
    
    NSInteger maxCount = [[responseDic objectForKey:@"maxCount"] integerValue];
    NSInteger addMax = [[responseDic objectForKey:@"addMax"] integerValue];
    //添加了群组时间
    int64_t grouptime=[[responseDic objectForKey:@"ct"] longLongValue];
    
    GroupList *groupListEntity = [GroupList NIM_createEntity];
    [groupListEntity setCt:[[NSDate date] timeIntervalSince1970]];
    [groupListEntity setMessageBodyId:messageBodyId];
    [groupListEntity setGroupId:groupid];
    [groupListEntity setMemberid:OWNERID];
    
    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:OWNERID];
    groupListEntity.selfcard = [vcard defaultName];
    
    groupListEntity.apnswitch = NO;
    
    groupListEntity.showname = YES;
    
    groupListEntity.name = name;
    
    groupListEntity.allFullLitter = [PinYinManager getAllFullPinyinString:name];
    
    groupListEntity.ct=grouptime;
    
    groupListEntity.avatar = GROUP_ICON_URL(groupid);
    
    groupListEntity.addMax = addMax;
    
    [groupListEntity setCapacity:maxCount];
    
    return groupListEntity;
}

@end
