//
//  NIMFriendManager.h
//  qbim
//
//  Created by 豆凯强 on 17/3/23.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMFriendManager : NSObject
SingletonInterface(NIMFriendManager)


//发送好友请求
-(void)sendFriendAddRQ:(int64)peer_id opMsg:(NSString *)opMsg sourceType:(int64)sourceType;
-(void)recvFriendAddRS:(NIMFriendPacket *)fdPack;

//删除好友
-(void)sendFriendDelRQ:(int64)user_id;
-(void)recvFriendDelRS:(NIMFriendPacket *)fdPack;

//获取好友列表
-(void)sendFriendListRQ:(int64)user_id;
-(void)recvFriendListRS:(NIMFriendPacket * )fdPack;

//好友备注
-(void)sendFriendRemarkRQ:(int64)user_id remarkName:(NSString *)remarkName;
-(void)recvFriendRemarkRS:(NIMFriendPacket *)fdPack;

//发送确认好友请求
-(void)sendFriendConRQ:(int64)peer_id result:(int)result;
-(void)recvFriendConRS:(NIMFriendPacket *)fdPack;

//收到对方好友确认结果包
-(void)recvServerAddConRQ:(NIMFriendPacket *)fdPack;

//收到好友请求包
-(void)recvServerAddRQ:(NIMFriendPacket *)fdPack;

//收到好友删除
-(void)recvServerDelRQ:(NIMFriendPacket *)fdPack;

//发送黑名单操作
-(void)addBlackListRQ:(int64)peerUser_id blackType:(NIMFDBlackShipType)blackType;
-(void)recvBlackListRQ:(NIMFriendPacket *)fdPack;

//收到黑名单操作
-(void)recvServerBlackRQ:(NIMFriendPacket *)fdPack;

//删除新的朋友通知消息
-(void)sendDelUpdateFriendRQ:(int64)peer_id;
-(void)recvDelUpdateFriendRQ:(NIMFriendPacket *)fdPack;

//收到好友恢复
-(void)recvServerRestorRQ:(NIMFriendPacket *)fdPack;

//发送红包暗文
-(void)createHBTipsWithOpID:(int64_t)opID redID:(int64_t)redID strType:(NSString *)strType;

//搜索通讯录
-(void)searchContent;

@end
