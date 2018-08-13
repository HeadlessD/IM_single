//
//  VcardEntity+CoreDataProperties.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "VcardEntity+CoreDataProperties.h"

@implementation VcardEntity (CoreDataProperties)

+ (NSFetchRequest<VcardEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VcardEntity"];
}

@dynamic age;
@dynamic apnswitch;
@dynamic avatar;
@dynamic avatar300;
@dynamic birthday;
@dynamic city;
@dynamic ct;
@dynamic fdExtrInfo;
@dynamic fLitter;
@dynamic fullLitter;
@dynamic localtionCity;
@dynamic locationPro;
@dynamic mail;
@dynamic messageBodyId;
@dynamic mobile;
@dynamic nickName;
@dynamic requestShip;
@dynamic sex;
@dynamic signature;
@dynamic user_sex;
@dynamic userid;
@dynamic userName;
@dynamic userToken;
@dynamic chatRecord;
@dynamic fdlist;
@dynamic member;
@dynamic phoneBook;

+ (instancetype)instancetypeFindUserid:(int64_t)userid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid=%lld", userid];
    return [self NIM_findFirstWithPredicate:predicate];
}

+ (instancetype)instancetypeWithMsgBodyId:(NSString *)msgBodyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId=%@", msgBodyId];
    return [self NIM_findFirstWithPredicate:predicate];
}

//千万别加remarkname
- (NSString *)defaultName
{
    if(self.nickName.length > 0){
        return self.nickName;
    }else if(self.userName.length>0){
        return self.userName;
    }else{
        return _IM_FormatStr(@"%lld",self.userid);
    }
}

- (NSString *)defaultNickName
{
    if(self.nickName.length > 0)
    {
        return self.nickName;
    }
    else if(self.userName.length>0)
    {
        return self.userName;
    }
    return nil;
}
@end
