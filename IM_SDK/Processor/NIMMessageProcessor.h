//
//  NIMMessageProcessor.h
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMBaseProcessor.h"
#import "NetCenter.h"
#import "NIMMessageStruct.h"
@interface NIMMessageProcessor : NIMBaseProcessor


//单聊消息包
-(void)sendSingleMessageRQ:(ChatEntity *)single;

//群聊消息包
-(void)sendGroupMessageRQ:(ChatEntity *)group;

//公众号消息包
-(void)sendFansMessageRQ:(ChatEntity *)offcial;

-(void)offcialSendMessageRQ:(ChatEntity *)offcial;
-(void)offcialSendOneMessageRQ:(ChatEntity *)offcial;
-(void)offcialSendSomeMessageRQ:(ChatEntity *)offcial;
-(void)sysSendMessageRQ:(ChatEntity *)offcial;
-(void)sysSendOneMessageRQ:(ChatEntity *)offcial;
-(void)sysSendSomeMessageRQ:(ChatEntity *)offcial;
@end
