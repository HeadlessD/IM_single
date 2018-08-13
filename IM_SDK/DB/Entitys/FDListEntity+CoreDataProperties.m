//
//  FDListEntity+CoreDataProperties.m
//  QBNIMClient
//
//  Created by 豆凯强 on 2017/8/21.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "FDListEntity+CoreDataProperties.h"

@implementation FDListEntity (CoreDataProperties)

+ (NSFetchRequest<FDListEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FDListEntity"];
}

@dynamic addToken;
@dynamic apnswitch;
@dynamic ct;
@dynamic fdAddInfo;
@dynamic fdAvatar;
@dynamic fdBlackShip;
@dynamic fdConsent;
@dynamic fdFriendShip;
@dynamic fdNickName;
@dynamic fdOwnId;
@dynamic fdPeerId;
@dynamic fdRemarkName;
@dynamic fdUnread;
@dynamic firstLitter;
@dynamic fullAllLitter;
@dynamic fullLitter;
@dynamic isInNewFriend;
@dynamic messageBodyId;
@dynamic fullCNLitter;
@dynamic spare;
@dynamic phoneBook;
@dynamic vcard;


- (NSString *)defaultName
{
    if(self.fdRemarkName.length > 0){
        return self.fdRemarkName;
    }else if(self.fdNickName.length > 0){
        return self.fdNickName;
    }else{
        return nil;
    }
}

+ (instancetype)instancetypeFindFriendId:(int64_t)friendId
{
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and (fdFriendShip = %d || fdFriendShip = %d) and (fdBlackShip = %d || fdBlackShip = %d)",OWNERID,friendId,FriendShip_Friended,FriendShip_UnilateralFriended,FD_BLACK_NOT_BLACK,FD_BLACK_PASSIVE_BLACK];
    
    return [self NIM_findFirstWithPredicate:pre];
}


+ (instancetype)instancetypeFindMUTUALFriendId:(int64_t)friendId
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and fdFriendShip = %d",OWNERID,friendId,FriendShip_Friended];
    
    return [self NIM_findFirstWithPredicate:pre];
}


+ (instancetype)instancetypeFindAbsoluteFriendId:(int64_t)friendId
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,friendId];
    
    return [self NIM_findFirstWithPredicate:pre];
}





@end
