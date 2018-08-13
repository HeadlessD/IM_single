//
//  SSIMMessage.h
//  test1
//
//  Created by 秦雨 on 17/4/26.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSIMAppTypeDefines.h"
@interface SSIMMessage : NSObject
//发送者id(只能为当前登陆用户)
@property (nonatomic,assign) int64_t userid;

//接收者id(单聊时为好友id，群聊时为群组id，公众号时为公众号id)
//分享时可不填
@property (nonatomic,assign) int64_t toid;

//消息类型枚举（可见SSIMAppTypeDefines）
@property (nonatomic,assign) E_MSG_CHAT_TYPE chatType;

//消息内容类型枚举（可见SSIMAppTypeDefines）
@property (nonatomic,assign) E_MSG_M_TYPE mtype;

//消息内容子类型枚举（可见SSIMAppTypeDefines）
@property (nonatomic,assign) E_MSG_S_TYPE stype;

//消息内容扩展类型枚举（可见SSIMAppTypeDefines）
@property (nonatomic,assign) E_MSG_E_TYPE etype;

//消息内容（根据消息类型枚举定义格式）
@property (nonatomic,strong) id msgContent;

//消息唯一标识，只读类型
@property (nonatomic,assign,readonly) int64_t messageId;

//仅用于商家聊天-商家ID
@property (nonatomic,assign) int64_t bid;
//仅用于商家聊天-小二ID
@property (nonatomic,assign) int64_t wid;
//仅用于商家聊天-客户ID
@property (nonatomic,assign) int64_t cid;

@end
