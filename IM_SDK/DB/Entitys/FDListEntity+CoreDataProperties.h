//
//  FDListEntity+CoreDataProperties.h
//  QBNIMClient
//
//  Created by 豆凯强 on 2017/8/21.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "FDListEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FDListEntity (CoreDataProperties)

+ (NSFetchRequest<FDListEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *addToken;
@property (nonatomic) BOOL apnswitch;
@property (nonatomic) int64_t ct;
@property (nullable, nonatomic, copy) NSString *fdAddInfo;
@property (nullable, nonatomic, copy) NSString *fdAvatar;
@property (nonatomic) int64_t fdBlackShip;
@property (nonatomic) int64_t fdConsent;
@property (nonatomic) int64_t fdFriendShip;
@property (nullable, nonatomic, copy) NSString *fdNickName;
@property (nonatomic) int64_t fdOwnId;
@property (nonatomic) int64_t fdPeerId;
@property (nullable, nonatomic, copy) NSString *fdRemarkName;
@property (nonatomic) int64_t fdUnread;
@property (nullable, nonatomic, copy) NSString *firstLitter;
@property (nullable, nonatomic, copy) NSString *fullAllLitter;
@property (nullable, nonatomic, copy) NSString *fullLitter;
@property (nonatomic) BOOL isInNewFriend;
@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nullable, nonatomic, copy) NSString *fullCNLitter;
@property (nullable, nonatomic, copy) NSString *spare;
@property (nullable, nonatomic, retain) PhoneBookEntity *phoneBook;
@property (nullable, nonatomic, retain) VcardEntity *vcard;


- (NSString *)defaultName;


+ (instancetype)instancetypeFindFriendId:(int64_t)friendId;

+ (instancetype)instancetypeFindMUTUALFriendId:(int64_t)friendId;

+ (instancetype)instancetypeFindAbsoluteFriendId:(int64_t)friendId;


@end

NS_ASSUME_NONNULL_END
