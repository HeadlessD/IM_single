//
//  NIMMessageErrorManager.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/6/7.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMMessageErrorManager : NSObject

SingletonInterface(NIMMessageErrorManager)

-(SDK_MESSAGE_RESULT)getMessageStatus:(SSIMMessage *)message;

-(SSIMMessage *)transChatEntity:(int64_t)msgid;

-(NSDictionary *)getMyFavorJsonByContent:(id)content;
@end
