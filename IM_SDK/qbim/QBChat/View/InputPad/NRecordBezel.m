//
//  RecordBezel.m
//  HoTalk
//
//  Created by  caobaolin on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#define RECORD_TIME_MAX     60

#import "NRecordBezel.h"

@implementation NRecordBezel

+ (CGRect)panelBoundRect
{
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if(iPhone5)
    {
        return CGRectMake((CGRectGetWidth(bounds) - 160)/2, 150, 160, 160);
    }
    else
    {
        return CGRectMake((CGRectGetWidth(bounds) - 160)/2, 150+44, 160, 160);
    }
}


- (id)initWithFrame:(CGRect)frame recorder:(AVAudioRecorder *)rec
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        volumeLevel = -1;
        
        self.recorder = rec;
        
        self.backgroundColor = [UIColor clearColor];
        
        transparent = [[UIView alloc] initWithFrame:[[self class] panelBoundRect]];
        transparent.backgroundColor = [UIColor clearColor];
        
        bgView = [[UIImageView alloc] initWithImage:IMGGET(@"audio_bg.png")];
        
        micView = [[UIImageView alloc] initWithImage:IMGGET(@"new_icon_voice_chat_01.png")];
        micView.contentMode = UIViewContentModeScaleAspectFit;
        
        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        
        //volume = [[HTVolume alloc] initWithFrame:CGRectMake(27.5, 136, 175, 10)];
        
        lastTenLabel = [[UILabel alloc] init];
        lastTenLabel.font = [UIFont boldSystemFontOfSize:18];
        lastTenLabel.textColor = [UIColor whiteColor];
        lastTenLabel.backgroundColor = [UIColor clearColor];
        lastTenLabel.textAlignment = NSTextAlignmentCenter;
        lastTenLabel.text = @"11";
        
        [transparent addSubview:bgView];
        [transparent addSubview:lastTenLabel];
        [transparent addSubview:micView];
        [transparent addSubview:label];
        //[transparent addSubview:volume];
        [self addSubview:transparent];
        
        volumeImageNames = [[NSArray alloc] initWithObjects:
                            @"new_icon_voice_chat_01.png",
                            @"new_icon_voice_chat_02.png",
                            @"new_icon_voice_chat_03.png",
                            @"new_icon_voice_chat_04.png",
                            @"new_icon_voice_chat_05.png",
                            @"new_icon_voice_chat_06.png",
                            @"new_icon_voice_chat_07.png",
                            @"new_icon_voice_chat_08.png",
                            @"new_icon_voice_chat_09.png",
                            nil];
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if(_title != title)
    {
        _title = title;
    }
    
    label.text = self.title;

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.title = RECORD_BEZEL_TITLE_ACTION_TIP;
    
    CGRect bgrect = CGRectMake(0, 0, 160, 160);
    bgView.frame = bgrect;
    
    CGRect lastrect = CGRectMake(55, 45, 50, 20);
    lastTenLabel.frame = lastrect;
    
    CGRect micrect = CGRectMake(45, 29, 70, 70);
    micView.frame = micrect;
    
    CGRect labrect = CGRectMake(0, 117, 160, 18);
    label.frame = labrect;
    
    label.text = self.title;
    
}
#pragma mark begin monitor volume
- (void)start
{
    DBLog(@"start recording");
    
    accumTime = 0;
    
    [self setupTimer];
        
    //[timer fire];
    
    lastTenLabel.text = @"";
}

- (void)stop
{
    lastTenLabel.text = @"";
    
    [self clearTimer];
}

#pragma mark timer
- (void)setupTimer
{
    [self clearTimer];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(refresh) 
                                            userInfo:nil
                                             repeats:YES];
}

- (void)clearTimer
{
    if (timer) 
    {
        if ([timer isValid]) 
        {
            [timer invalidate];
        }
        timer = nil;
    }
}

- (void)updateVolume {
    [_recorder updateMeters];
    
    NSInteger vl = pow(10, 0.05 * [_recorder averagePowerForChannel:0]) * 9;
    
//    DBLog(@"volume level : %d",vl);
    
    if (vl < 0) {
        vl = 0;
    }
    else if (vl > 8) {
        vl = 8;
    }
    if (vl == volumeLevel) {
        return;
    }
    volumeLevel = vl;
    NSString *imgName = [volumeImageNames objectAtIndex:volumeLevel];
    UIImage *image = IMGGET(imgName);
    micView.image = image;
//    [image release];
}


- (void)refresh
{
    [self updateVolume];
    
//    DBLog(@"accum time = %d,current = %f",accumTime,recorder.currentTime);
    
    if (accumTime >= ((RECORD_TIME_MAX - 10) * 10)) 
    {
        if (accumTime <= RECORD_TIME_MAX * 10) 
        {
            int rest = accumTime%10;
            
            if (rest == 0) 
            {
                lastTenLabel.text = [NSString stringWithFormat:@"%d",(RECORD_TIME_MAX - accumTime/10)];
            }
        }
        else
        {
            [self stop];
            
            [_inputPad endRecording];
//            if ([self.inputField respondsToSelector:@selector(recordReachMaxTime)]) 
//            {
//                [self.inputField recordReachMaxTime];
//            }
        }
    }
    accumTime++;
}
- (void)show
{
    self.alpha = 0.1;
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    
    [self start];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    self.alpha = 1.0;
    
    [UIView commitAnimations];
}

-(void)getRidOffSelf
{
    [self stop];
    
    lastTenLabel.text = @"";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(tRemoveSelf)];
    [UIView setAnimationDelegate:self];
    
    self.alpha = 0.1;
    
    [UIView commitAnimations];
    
}
-(void)tRemoveSelf
{
    [self removeFromSuperview];
}

@end
