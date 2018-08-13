//
//  NIMMessageSoundEffect.m
//  QianbaoIM
//
//  Created by liunian on 14/10/9.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMMessageSoundEffect.h"
#import <AudioToolbox/AudioToolbox.h>

@interface NIMMessageSoundEffect ()

+ (void)playSoundWithName:(NSString *)name type:(NSString *)type;

@end



@implementation NIMMessageSoundEffect

+ (void)playSoundWithName:(NSString *)name type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
        AudioServicesPlaySystemSound(sound);
    }
    else {
        DBLog(@"Error: audio file not found at path: %@", path);
    }
}

+ (void)playMessageReceivedSound
{
    [NIMMessageSoundEffect playSoundWithName:@"alarm" type:@"caf"];
}

+ (void)playMessageSentSound
{
    [NIMMessageSoundEffect playSoundWithName:@"messageSent" type:@"aiff"];
}

+ (void)playMessageNoticeSound{
    [NIMMessageSoundEffect playSoundWithName:@"pushmsg" type:@"caf"];
}

+ (void)playMessageVoiceEndSound{
    [NIMMessageSoundEffect playSoundWithName:@"playEnd" type:@"caf"];
}

@end
