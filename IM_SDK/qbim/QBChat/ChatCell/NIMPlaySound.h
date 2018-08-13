//
//  NIMPlaySound.h
//  QianbaoIM
//
//  Created by Yun on 14/12/23.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NIMPlaySoundDelegate <NSObject>
@optional
- (void)playStatusChanged:(DOUAudioStreamerStatus)status;

@end
@interface NIMPlaySound : NSObject

@property (nonatomic, assign) id<NIMPlaySoundDelegate>delegate;
@property (nonatomic, strong) DOUAudioStreamer* stream;

- (void)playSound:(NSURL*)soundURL;
- (void)stopPlay;
- (void)pausePlay;
- (void)playCon;

//从后台进入前台不调用该方法无法设置模式
-(void)setMode;
@end
