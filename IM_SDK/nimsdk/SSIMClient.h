//
//  SSIMClient.h
//  SSIMClient
//
//  Created by 秦雨 on 17/5/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSIMModel.h"
#import "SSIMMessage.h"
#import "SSIMDelegate.h"
#import "SSIMModel.h"

typedef void (^SSIMCallBack)(id object ,SDK_MESSAGE_RESULT result);

@interface SSIMClient : NSObject
@property(nonatomic,assign,readonly)int64_t owerid;
@property(nonatomic,assign,readonly)int appid;
@property(nonatomic,weak)id<SSIMDelegate> delegate;
@property(nonatomic,assign)BOOL isQbaoLoginSuccess;

//单例初始化
+ (instancetype)sharedInstance;

//登陆信息
-(void)setLoginInfo:(SSIMLogin *)loginInfo;

//连接指定服务器
-(void)Connect:(NSString *)host port:(unsigned int) port;

//重连
-(void)reConnect;

//断开连接
-(void)disConnect;

//进入前台检测连接
-(void)checkConnect;

//发送消息
-(void)sendMessage:(SSIMMessage *)message callBackBlock:(SSIMCallBack)callBackBlock;

//分享消息
-(void)shareMessage:(SSIMShareModel *)message;

//我的收藏（图文消息为数组）
-(void)sendMyFavorMessage:(id)myMessage messageBodyId:(NSString *)messageBodyId;

//发送红包之后返回model
-(void)sendRedBagComeBack:(SSIMRedbagModel *)redBagModel;

//拆开红包之后返回model
-(void)openRedBagComeBack:(SSIMRedbagModel *)redBagModel;


//消息设置
-(void)setNewMessageSetting;


@end
