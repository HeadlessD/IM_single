//
//  NIMRecordBezel.m
//  QianbaoIM
//
//  Created by liunian on 14/9/15.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRecordBezel.h"
#define RECORD_TIME_MAX     60

@implementation NIMRecordBezel

+ (CGRect)panelBoundRect
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    return CGRectMake((CGRectGetWidth(bounds) - 160)/2, (bounds.size.height-64 - 48)/2 - 80 +64, 160, 160);
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
        
        bgView = [[UIImageView alloc] initWithImage:nil];
        bgView.layer.cornerRadius = 8;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.8;
        
        micView = [[UIImageView alloc] initWithImage:IMGGET(@"pic_dialog_audio_record_01.png")];
        micView.contentMode = UIViewContentModeScaleAspectFit;
        
        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        
        //volume = [[HTVolume alloc] initWithFrame:CGRectMake(27.5, 136, 175, 10)];
        lastTenLabel = [[UILabel alloc] init];
        lastTenLabel.font =  [UIFont boldSystemFontOfSize:87];
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
                            @"pic_dialog_audio_record_01",
                            @"pic_dialog_audio_record_02",
                            @"pic_dialog_audio_record_03",
                            @"pic_dialog_audio_record_04",
                            @"pic_dialog_audio_record_05",
                            @"pic_dialog_audio_record_06",
                            @"pic_dialog_audio_record_07",
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
    
    CGRect lastrect = CGRectMake(0, 0, 160, 117);
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
    micView.hidden = NO;
}

- (void)stop
{
    lastTenLabel.text = @"";
    micView.hidden = NO;
    
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
    NSInteger vl = pow(10, 0.05 * [_recorder averagePowerForChannel:0]) * 12;
    NSLog(@"===updateVolume %ld",(long)vl);
    if (vl < 0) {
        vl = 0;
    }
    else if (vl > 6) {
        vl = 6;
    }
    if (vl == volumeLevel) {
        return;
    }
    volumeLevel = vl;
    NSString *imgName = [volumeImageNames objectAtIndex:volumeLevel];
    UIImage *image = IMGGET(imgName);
    micView.image = image;
}


- (void)refresh
{
    [self updateVolume];
    //    DBLog(@"accum time = %d,current = %f",accumTime,recorder.currentTime);
    if (accumTime >= ((RECORD_TIME_MAX - 9) * 10))
    {
        if (accumTime <= RECORD_TIME_MAX * 10)
        {
            int rest = accumTime%10;
            
            if (rest == 0)
            {
                int itext = (RECORD_TIME_MAX - accumTime/10);
                itext++;
                lastTenLabel.text = [NSString stringWithFormat:@"%d",itext];
                
                if(lastTenLabel.text.length > 0)
                {
                    micView.hidden = YES;
                }
                else
                {
                    micView.hidden = NO;
                }
            }
        }
        else
        {
            [self stop];
            lastTenLabel.text = @"1";
            micView.hidden = YES;
            [_delegate endRecordrecordBezel:self];
        }
    }
    accumTime++;
}
- (void)show
{
    [self start];

}

-(void)getRidOffSelf
{
    [self stop];
    
    lastTenLabel.text = @"";
    micView.hidden = NO;
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
