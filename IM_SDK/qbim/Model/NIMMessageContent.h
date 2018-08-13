//
//  NIMMessageContent.h
//  QBIM
//
//  Created by liunian on 14-3-17.
//  Copyright (c) 2014年 liunian. All rights reserved.
//

//#import "SHModelObject.h"

@interface NIMMessageContent : NSObject
+ (double)captureGroupidWithThread:(NSString *)thread;
+ (E_MSG_CHAT_TYPE)chatTypeWithThread:(NSString *)thread;
+ (NSString *)combineThreadWithE_MSG_CHAT_TYPE:(E_MSG_CHAT_TYPE)MT fromID:(double)fromid toID:(double)toid;
+ (double)getPrivateReceiveIdWithThread:(NSString*)thread;
+ (double)getPrivateSenderIdWithThread:(NSString*)thread;

@end
