//
//  NIMOperationBox.h
//  qbim
//
//  Created by 秦雨 on 17/2/9.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatEntity+CoreDataClass.h"
#import "ChatListEntity+CoreDataClass.h"
typedef void (^CompleteBlock)(id object,NIMResultMeta *result);

@interface NIMOperationBox : NSObject
@property (nonatomic, strong) dispatch_queue_t coredata_queue_t;
@property (nonatomic, strong) dispatch_queue_t download_queue_t;
@property (nonatomic, strong) dispatch_group_t httpRequest_group_t;
@property (nonatomic, strong) dispatch_queue_t httpRequest_queue_t;
@property (nonatomic, strong) NSMutableDictionary *downloadDict;


SingletonInterface(NIMOperationBox);

//聊天相关
- (void)operateChatJsonMessages:(NSArray *)messages isRemind:(BOOL)isRemind;

- (void)downloadAudioRecordEntity:(ChatEntity *)recordEntity success:(void (^)(BOOL success))success;

- (ChatEntity *)getfoldGroupAtLeastTime;

//TODO:将该thread置空
- (void)resetRecordListThread:(NSString *)thread isHomePageShow:(BOOL)isHomePageShow;

- (void)flagReadRecordEntityMsgID:(uint64_t)msgid;
- (void)arrangeTheneworder;
- (void)makeTaskHelper;
- (void)deleteGroupAssistant;
- (void)updateGroupAssistant:(NSString *)preview;
- (NSString *)getPreviewForGroupAssistantBy:(ChatEntity *)chatitem;
- (BOOL)checkIsCanDeleteGroupAssistant;
- (void)makeGroupAssistantPacket:(ChatListEntity *)list withUsePrivew:(BOOL)use;
- (void)makePublicPacketShow:(ChatListEntity *)list;
- (void)makeShopAssistantPacketShow:(ChatListEntity *)chatList isRevMsg:(BOOL)isRevMsg;
- (void)updateShopAssistantWithChatent:(ChatListEntity *)chatlistEnt withPre:(NSString * )preView;

- (void)makeSubscribeHelper;
-(void)checkRecordStatus;
@end
