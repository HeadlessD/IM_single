//
//  ChatEntity+CoreDataProperties.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/26.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "ChatEntity+CoreDataClass.h"
#import "TextEntity+CoreDataClass.h"
#import "AudioEntity+CoreDataClass.h"
#import "ImageEntity+CoreDataClass.h"
#import "Location+CoreDataClass.h"
#import "VcardEntity+CoreDataClass.h"
#import "NOffcialEntity+CoreDataClass.h"
#import "VideoEntity+CoreDataClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatEntity (CoreDataProperties)

+ (NSFetchRequest<ChatEntity *> *)fetchRequest;

@property (nonatomic) int64_t apId;
@property (nonatomic) int64_t bId;
@property (nonatomic) int16_t chatType;
@property (nonatomic) int64_t cId;
@property (nonatomic) int64_t ct;
@property (nonatomic) int16_t ext;
@property (nonatomic) int64_t groupId;
@property (nonatomic) BOOL isSender;
@property (nullable, nonatomic, copy) NSString *messageBodyId;
@property (nonatomic) int64_t messageId;
@property (nullable, nonatomic, copy) NSString *msgContent;
@property (nonatomic) int16_t mtype;
@property (nonatomic) int64_t offcialId;
@property (nullable, nonatomic, copy) NSString *oldMessageId;
@property (nonatomic) int64_t opUserId;
@property (nonatomic) int64_t packId;
@property (nullable, nonatomic, copy) NSString *sendUserName;
@property (nonatomic) int32_t sid;
@property (nonatomic) int16_t status;
@property (nonatomic) int16_t stype;
@property (nonatomic) BOOL unread;
@property (nonatomic) int64_t userId;
@property (nonatomic) int64_t wId;
@property (nullable, nonatomic, retain) AudioEntity *audioFile;
@property (nullable, nonatomic, retain) ImageEntity *imageFile;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) NOffcialEntity *offcialEntity;
@property (nullable, nonatomic, retain) TextEntity *textFile;
@property (nullable, nonatomic, retain) VcardEntity *vcard;
@property (nullable, nonatomic, retain) VideoEntity *videoFile;

+ (NSInteger)getRecordEntityCountByPredicate:(NSPredicate*)predicate;
+(instancetype)instancetypeWithJsonDic:(NSDictionary *)jsonDic;
+(instancetype)findFirstWithMessageId:(int64_t)messageId;
@end

NS_ASSUME_NONNULL_END
