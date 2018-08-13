//
//  VcardEntity+CoreDataProperties.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "VcardEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VcardEntity (CoreDataProperties)

+ (NSFetchRequest<VcardEntity *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nonatomic) BOOL apnswitch;
@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSString *avatar300;
@property (nullable, nonatomic, copy) NSString *birthday;
@property (nullable, nonatomic, copy) NSString *city;
@property (nonatomic) int64_t ct;
@property (nullable, nonatomic, copy) NSString *fdExtrInfo;
@property (nullable, nonatomic, copy) NSString *fLitter;
@property (nullable, nonatomic, copy) NSString *fullLitter;
@property (nullable, nonatomic, copy) NSString *localtionCity;
@property (nullable, nonatomic, copy) NSString *locationPro;
@property (nullable, nonatomic, copy) NSString *mail;
@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *nickName;
@property (nonatomic) int16_t requestShip;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSString *signature;
@property (nullable, nonatomic, copy) NSString *user_sex;
@property (nonatomic) int64_t userid;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userToken;
@property (nullable, nonatomic, retain) ChatEntity *chatRecord;
@property (nullable, nonatomic, retain) FDListEntity *fdlist;
@property (nullable, nonatomic, retain) GMember *member;
@property (nullable, nonatomic, retain) PhoneBookEntity *phoneBook;

+ (instancetype)instancetypeFindUserid:(int64_t)userid;
+ (instancetype)instancetypeWithMsgBodyId:(NSString *)msgBodyId;
- (NSString *)defaultName;
- (NSString *)defaultNickName;

@end

NS_ASSUME_NONNULL_END
