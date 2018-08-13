//
//  RecordBezel.h
//  HoTalk
//
//  Created by  caobaolin on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioPlayer.h>

#import "NIMInputPad.h"

#define RECORD_BEZEL_TITLE_ACTION_TIP @"移到这里取消"
#define RECORD_BEZEL_TITLE_CANCEL_TIP @"松开取消发送"


@interface NRecordBezel : UIView
{
    UIView          *transparent;
    UIImageView     *bgView;
    UIImageView     *micView;
    UILabel         *label;
    UILabel         *lastTenLabel;
    
    int              accumTime;
    
    NSTimer         *timer;

    
    NSInteger        volumeLevel;
    NSArray         *volumeImageNames;
}
@property(nonatomic,strong) NIMInputPad        *inputPad;
@property(nonatomic,strong) NSString        *title;
@property(nonatomic,strong) AVAudioRecorder *recorder;

- (id)initWithFrame:(CGRect)frame recorder:(AVAudioRecorder *)rec;

- (void)show;
- (void)tRemoveSelf;
- (void)getRidOffSelf;

- (void)start;
- (void)stop;

- (void)setupTimer;
- (void)clearTimer;

+ (CGRect)panelBoundRect;


@end
