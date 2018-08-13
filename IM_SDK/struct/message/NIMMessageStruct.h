//
//  NIMMessageStruct.h
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nimplatform.h"


//单聊离线
@interface QBSingleOffline : NIMHeader
@property (nonatomic,assign) uint64 next_message_id;
@end

//群聊离线
@interface QBGroupOffline : NIMHeader
@property (nonatomic,strong) NSMutableArray *groupOfflines;

@end

@interface QBGroupOfflineBody : NIMHeader
@property (nonatomic,assign) uint64 next_message_id;
@property (nonatomic,assign) uint64 group_id;
-(instancetype)initWithNextMsgId:(uint64)next_message_id groupid:(uint64)groupid;
@end


//公众号离线
@interface QBOffcialOffline : NIMHeader
@property (nonatomic,strong) NSMutableArray *offcialOfflines;

@end


@interface QBOffcialOfflineBody : NIMHeader
@property (nonatomic,assign) uint64_t next_message_id;
@property (nonatomic,assign) uint64_t offcial_id;
-(instancetype)initWithNextMsgId:(uint64_t)next_message_id offcialid:(uint64_t)offcialid;
@end

/********************消息子类型****************/
@interface NIMAudioMessage : NSObject
@property (nonatomic) int16_t duration;
@property (nonatomic, copy) NSString *file;
@property (nonatomic) BOOL read;
@property (nonatomic) int16_t state;
@property (nonatomic, copy) NSString *url;
@end

@interface NIMImageMessage : NSObject
@property (nonatomic, copy) NSString *bigFile;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *thumb;
@end

@interface NIMTextMessage : NSObject
@property (nonatomic, copy) NSString *text;
@end

@interface NIMChatMessage : NIMHeader
@property (nonatomic,strong) NSString *msg_content;
@property (nonatomic,assign) int64_t msg_time;
@property (nonatomic,assign) short ap_id;
@property (nonatomic,assign) E_MSG_CHAT_TYPE chat_type;
@property (nonatomic,assign) E_MSG_M_TYPE m_type;
@property (nonatomic,assign) E_MSG_S_TYPE s_type;
@property (nonatomic,assign) E_MSG_E_TYPE ext_type;
@property (nonatomic,assign) int64_t message_id;
@property (nonatomic,assign) int64_t op_user_id;
@property (nonatomic,assign) int64_t b_id;
@property (nonatomic,assign) int64_t w_id;
@property (nonatomic,assign) int64_t c_id;
@property (nonatomic,assign) int64_t group_id;
@property (nonatomic,assign) int16_t status;
@property (nonatomic,assign) BOOL isSender;
@property (nonatomic,assign) BOOL unread;
@property (nonatomic,strong) NIMAudioMessage *audioMessage;
@property (nonatomic,strong) NIMImageMessage *imageMessage;
@property (nonatomic,strong) NIMTextMessage *textMessage;

@end


