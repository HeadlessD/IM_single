//
//  ChatListEntity+CoreDataProperties.h
//  qbnimclient
//
//  Created by 秦雨 on 17/11/23.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "ChatListEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChatListEntity (CoreDataProperties)

+ (NSFetchRequest<ChatListEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *actualThread;
@property (nonatomic) BOOL apnswitch;
@property (nonatomic) int16_t badge;
@property (nonatomic) int16_t chatType;
@property (nonatomic) int64_t ct;
@property (nonatomic) int16_t groupAssistantRead;
@property (nonatomic) BOOL isflod;
@property (nonatomic) BOOL isPublic;
@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nonatomic) int16_t messageBodyIdType;
@property (nullable, nonatomic, copy) NSString *preview;
@property (nonatomic) BOOL showRedPublic;
@property (nonatomic) int16_t sType;
@property (nonatomic) BOOL topAlign;
@property (nonatomic) int64_t userId;
@property (nonatomic) int16_t shopAssistantRead;

+ (instancetype)findFirstWithMessageBodyId:(NSString*)messageBodyId;
+(instancetype)instancetypeWithMessageBodyId:(ChatEntity *)chatEntity isRemind:(BOOL)isRemind;
+ (instancetype)instancetypeForTaskHelper;
+ (instancetype)instancetypeForSubscribeHelper;
+ (instancetype)instancetypeForGroupAssistantPacket:(ChatListEntity*)list;
+ (instancetype)instancetypeForPublicPacket:(ChatListEntity *)list;
+ (instancetype)instancetypeForShopAssistantPacket:(ChatListEntity*)list;
+ (BOOL)clearRecordWithMessageBodyId:(NSString *)mbd;
@end

NS_ASSUME_NONNULL_END
