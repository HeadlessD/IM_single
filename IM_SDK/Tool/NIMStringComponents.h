//
//  StringComponents.h
//  qbim
//
//  Created by 豆凯强 on 17/2/8.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMStringComponents : NSObject

+(NSString *)createMsgBodyIdWithType:(E_MSG_CHAT_TYPE)chatType toId:(int64_t)toId;

+(NSString *)createMsgBodyIdWithType:(E_MSG_CHAT_TYPE)chatType fromId:(int64_t)fromId toId:(int64_t)toId;

+ (int64_t)getOpuseridWithMsgBodyId:(NSString *)msgBodyId;
+ (E_MSG_CHAT_TYPE)chatTypeWithMsgBodyId:(NSString *)msgBodyId;
+ (int64_t)createMessageid:(E_MSG_CHAT_TYPE)chatType;

+(NSString *)finFristNameWithID:(int64)userID;



+ (void)createTipsWithMbd:(NSString *)mbd stype:(E_MSG_S_TYPE)stype friends:(NSArray *)friends;
+(void)createProductTipsWithMbd:(NSString *)mbd stype:(E_MSG_S_TYPE)stype content:(id)content;
+(void)deleteProductTipsWithMbd:(NSString *)mbd stype:(E_MSG_S_TYPE)stype;
+(NIM_SEARCH_TYPE)getSearchTypeWithFriends:(NSArray *)friends groups:(NSArray *)groups;
@end
