//
//  NIMRecordBezel.h
//  QianbaoIM
//
//  Created by liunian on 14/9/15.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioPlayer.h>

#define RECORD_BEZEL_TITLE_ACTION_TIP @"手指上滑取消发送"
#define RECORD_BEZEL_TITLE_CANCEL_TIP @"手指松开取消发送"

@protocol NIMRecordBezelDelegate;
@interface NIMRecordBezel : UIView
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
@property(nonatomic,assign) id<NIMRecordBezelDelegate>delegate;
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

@protocol NIMRecordBezelDelegate <NSObject>

@required
- (void)endRecordrecordBezel:(NIMRecordBezel *)recordBezel;
@end


