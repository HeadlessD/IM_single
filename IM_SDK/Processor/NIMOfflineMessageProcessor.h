//
//  NIMOfflineMessageProcessor.h
//  qbim
//
//  Created by 秦雨 on 17/2/7.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMBaseProcessor.h"
#import "NetCenter.h"
#import "NIMMessageStruct.h"
@interface NIMOfflineMessageProcessor : NIMBaseProcessor
//单聊离线消息
-(void)sendSingleOfflineMessageRQ:(QBSingleOffline *)offline;

//群组离线消息
-(void)sendGroupOfflineMessageRQ:(QBGroupOffline *)offline;

//公众号离线消息
-(void)sendOffcialOfflineMessageRQ:(QBOffcialOffline *)offline;
-(void)sendFansOfflineMessageRQ;
-(void)fetchSysOfflineMessage;
@end
