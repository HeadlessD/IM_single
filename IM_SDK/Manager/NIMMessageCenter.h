//
//  NIMMessageCenter.h
//  qbim
//
//  Created by ssQINYU on 17/1/26.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "ChatEntity+CoreDataProperties.h"

@interface NIMMessageCenter : NSObject
SingletonInterface(NIMMessageCenter)

-(void)sendMessageWithObject:(NSObject *)object mType:(E_MSG_M_TYPE)mType sType:(E_MSG_S_TYPE)sType eType:(E_MSG_E_TYPE)eType messageBodyId:(NSString *)messageBodyId msgid:(int64_t)msgid;
-(void)sendMessage:(ChatEntity *)chatEntity;
- (void)reSendRecordEntity:(ChatEntity *)recordEntity;
-(void)forwardRecordEntity:(ChatEntity *)recordEntity toMsgBodyId:(NSString *)msgBodyId;
- (void)deleteRecordsThread:(NSString *)messageBodyId completeBlock:(CompleteBlock)completeBlock;
-(void)sendSDKMessage:(SSIMMessage *)message messageid:(int64_t)messageid;
@end
