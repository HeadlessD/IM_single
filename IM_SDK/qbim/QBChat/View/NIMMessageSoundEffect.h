//
//  NIMMessageSoundEffect.h
//  QianbaoIM
//
//  Created by liunian on 14/10/9.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMMessageSoundEffect : NSObject
+ (void)playMessageReceivedSound;
+ (void)playMessageSentSound;
+ (void)playMessageNoticeSound;
+ (void)playMessageVoiceEndSound;
@end
