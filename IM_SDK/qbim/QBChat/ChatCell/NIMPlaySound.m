//
//  NIMPlaySound.m
//  QianbaoIM
//
//  Created by Yun on 14/12/23.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMPlaySound.h"
#import "Track.h"
#import <AVFoundation/AVFoundation.h>

static void *kStatusKVOKey = &kStatusKVOKey;

@interface NIMPlaySound ()
@end

@implementation NIMPlaySound


- (void)playSound:(NSURL*)soundURL{
    
//    NSError *error;
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    if (!IsStrEmpty(_status)&&_status!=AVAudioSessionCategoryPlayAndRecord) {
//        NSError *error;
//        if(![session   setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]){
//            DLog(@"AVAudioSession set AVAudioSessionCategoryPlayback error %@",[error debugDescription]);
//        }
//    }
//    if(![session setActive:YES error:&error]){
//        DLog(@"%@",[error debugDescription]);
//    }
    //[session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation  error:nil];
    DLog(@"SoundURL:::::::%@",soundURL);
    [self stopPlay];
    Track* track = [[Track alloc] init];
    track.title = @"";
    track.artist = @"";
    track.audioFileURL = soundURL;
    _stream = [DOUAudioStreamer streamerWithAudioFile:track];
    [_stream addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_stream play];
}

- (void)stopPlay{
    if(_stream){
        [_stream stop];
        [_stream removeObserver:self forKeyPath:@"status"];
        _stream = nil;
    }
}

- (void)pausePlay{
    if(_stream){
        [_stream pause];
    }
}

- (void)playCon
{
    if(_stream){
        [_stream play];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)_updateStatus
{
    if(_delegate && [_delegate respondsToSelector:@selector(playStatusChanged:)]){
        [_delegate playStatusChanged:[_stream status]];
    }
}

-(void)setMode
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    Track* track = [[Track alloc] init];
    track.title = @"";
    track.artist = @"";
    track.audioFileURL = [NSURL fileURLWithPath:path];
    _stream = [DOUAudioStreamer streamerWithAudioFile:track];
    [_stream play];
    [_stream stop];
    _stream = nil;
}

@end
