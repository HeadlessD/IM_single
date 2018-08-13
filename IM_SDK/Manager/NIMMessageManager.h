//
//  NIMMessageManager.h
//  qbnimclient
//
//  Created by 秦雨 on 17/12/9.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMMessageStruct.h"
@interface NIMMessageManager : NSObject

@property(nonatomic,strong)NSMutableDictionary *chatDict;
@property(nonatomic,strong)NSMutableDictionary *chatListDict;


SingletonInterface(NIMMessageManager)

-(NSInteger)addMessage:(ChatEntity *)message;
-(void)insertMessageList:(NSArray *)messageList messageBodyId:(NSString *)messageBodyId;
-(void)addMessageList:(NSArray *)messageList messageBodyId:(NSString *)messageBodyId;
-(BOOL)addChatList:(NSArray *)chatList;
-(NSArray *)getMessagesBySessionId:(NSString *)messageBodyId;
-(void)removeAllMessageBy:(NSString *)messageBodyId;
-(ChatEntity *)searchMessageWithMsgId:(int64_t)msgid messageBodyId:(NSString *)messageBodyId;
-(void)updateMessage:(ChatEntity *)message isPost:(BOOL)isPost isChange:(BOOL)isChange;
-(NSArray *)getMessageWithSessionid:(NSString *)messageBodyId Offset:(NSInteger)offset limit:(NSInteger)limit;
-(NSInteger)indexOfMessage:(ChatEntity *)message;
-(void)removeMessageByMsgId:(int64_t)msgid messageBodyId:(NSString *)messageBodyId;
@end
