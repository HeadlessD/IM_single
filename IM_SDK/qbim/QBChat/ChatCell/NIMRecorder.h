//
//  NIMRecorder.h
//  QianbaoIM
//
//  Created by 孔祥波 on 15/1/3.
//  Copyright (c) 2015年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
@interface NIMRecorder : NSObject{
    AudioFileID					recordFile; // reference to your output file
    SInt64						recordPacket; // current packet index in output file
    Boolean						running; // recording state
    AudioQueueRef queue;
}
@property (nonatomic, readonly) NSString *fileName;
-(void)startRecord;
-(void)stopRecord;
@end
