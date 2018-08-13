//
//  NIMFriendProcessor.h
//  qbim
//
//  Created by 豆凯强 on 17/3/23.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMBaseProcessor.h"
#import "NetCenter.h"

@interface NIMFriendProcessor : NIMBaseProcessor

//发送好友请求包
-(void)sendFriendAddRQ:(int64)peer_id opMsg:(NSString *)opMsg sourceType:(int64)sourceType;

//删除好友包
-(void)sendFriendDelRQ:(int64)user_id;

//好友列表获取
-(void)sendFriendListRQ:(int64)user_id withToken:(int64)userToken;

//好友备注
-(void)sendFriendRemarkRQ:(int64)user_id remarkName:(NSString *)remarkName;

//发送确认好友请求
-(void)sendFriendConRQ:(int64)peer_id result:(int)result;

//发送黑名单操作
-(void)addBlackListRQ:(int64)peerUser_id blackType:(NIMFDBlackShipType)blackType;

//删除新的朋友通知消息通知
-(void)sendDelUpdateFriendRQ:(int64)peer_id;



@property (nonatomic,assign) int fdListOffset;

@property (nonatomic,assign) int fdListMaxcnt;

@end
