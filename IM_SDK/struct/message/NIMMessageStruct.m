//
//  NIMMessageStruct.m
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMMessageStruct.h"

@implementation NIMChatMessage

@end

@implementation QBSingleOffline

@end

@implementation QBGroupOffline

@end

@implementation QBGroupOfflineBody

-(instancetype)initWithNextMsgId:(uint64)next_message_id groupid:(uint64)groupid
{
    self = [super init];
    if (self) {
        self.next_message_id = next_message_id;
        self.group_id = groupid;
    }
    return self;
}

@end


@implementation QBOffcialOffline


@end


@implementation QBOffcialOfflineBody

-(instancetype)initWithNextMsgId:(uint64)next_message_id offcialid:(uint64_t)offcialid
{
    self = [super init];
    if (self) {
        self.next_message_id = next_message_id;
        self.offcial_id = offcialid;
    }
    return self;
}

@end

@implementation NIMAudioMessage


@end

@implementation NIMImageMessage


@end


@implementation NIMTextMessage


@end

