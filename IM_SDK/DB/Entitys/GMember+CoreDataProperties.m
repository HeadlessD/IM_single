//
//  GMember+CoreDataProperties.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/8/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "GMember+CoreDataProperties.h"

@implementation GMember (CoreDataProperties)

+ (NSFetchRequest<GMember *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GMember"];
}

@dynamic card;
@dynamic ct;
@dynamic fLitter;
@dynamic fullLitter;
@dynamic groupIndex;
@dynamic groupmembernickname;
@dynamic messageBodyId;
@dynamic role;
@dynamic showName;
@dynamic userid;
@dynamic allFullLitter;
@dynamic group;
@dynamic vcard;


+ (instancetype)instancetypeFindUserid:(int64_t)userid group:(GroupList *)groupEntiy{
    if (userid <= 0 || groupEntiy == nil) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userid = %lld) AND (group = %@)",userid,groupEntiy];
    return [GMember NIM_findFirstWithPredicate:predicate];
}

+(instancetype)instancetypeWithMemberDic:(NSDictionary *)memberDic group:(GroupList *)groupEntiy
{
    int64_t userid                = [[memberDic objectForKey:@"userId"] longLongValue];
    NSString *messageBodyId             = groupEntiy.messageBodyId;
    NSString*nickname             = [memberDic objectForKey:@"memberNickName"];
    int16_t index                 = [[memberDic objectForKey:@"index"] integerValue];
    
    
    VcardEntity *vcard= [VcardEntity instancetypeFindUserid:userid];
    if (vcard==nil) {
        vcard = [VcardEntity NIM_createEntity];
        vcard.userid = userid;
        vcard.nickName = nickname;
        
    }
    GMember *memberEntity = nil;
    if (userid <= 0 || groupEntiy == nil) {
        memberEntity = nil;
    }
    else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userid = %@) AND (messageBodyId = %@)",@(userid),messageBodyId];
        memberEntity = [GMember NIM_findFirstWithPredicate:predicate];
    }
    
    NSString *priorName = nil;
    
    FDListEntity *fd = [FDListEntity instancetypeFindFriendId:userid];
    
    if (!IsStrEmpty(fd.fdRemarkName)) {
        priorName = fd.fdRemarkName;
    }else{
        priorName = IsStrEmpty(nickname)?vcard.defaultName:nickname;
        if (IsStrEmpty(priorName)) {
            priorName = @"用户";
        }
    }
    
    if (!memberEntity) {
        memberEntity = [GMember NIM_createEntity];
        memberEntity.messageBodyId = groupEntiy.messageBodyId;
        memberEntity.userid = userid;
    }
    memberEntity.groupmembernickname=nickname;
    memberEntity.groupIndex = index;
    memberEntity.vcard = vcard;
    memberEntity.showName = priorName;
    memberEntity.fLitter = [PinYinManager getFirstLetter:priorName];
    memberEntity.fullLitter = [PinYinManager getFullPinyinString:priorName];
    memberEntity.allFullLitter = [PinYinManager getAllFullPinyinString:priorName];
    memberEntity.ct = [NIMBaseUtil GetServerTime];
    [memberEntity setGroup:groupEntiy];
    return memberEntity;
}

@end
