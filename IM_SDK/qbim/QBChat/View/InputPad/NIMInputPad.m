//
//  IMInputView.m
//  QianbaoIM
//
//  Created by liyan on 14-3-31.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMInputPad.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "NRecordBezel.h"
#import "NSString+nimregular.h"
#import "NIMQBLabel.h"

#define RECT_INPUT_BTN_OFF_Y    6
#define RECT_INPUT_BTN1 CGRectMake(5, RECT_INPUT_BTN_OFF_Y, 31, 31)
#define RECT_INPUT_BTN2 CGRectMake(249, RECT_INPUT_BTN_OFF_Y, 31, 31)
#define RECT_INPUT_BTN3 CGRectMake(285, RECT_INPUT_BTN_OFF_Y, 31, 31)

#define RECT_INPUT_BTN1_MAGIN_GLOBAL(x) CGRectMake(5, RECT_INPUT_BTN_OFF_Y+x, 31, 31)

#define RECT_INPUT_BTN2_MAGIN_GLOBAL(x) CGRectMake(249, RECT_INPUT_BTN_OFF_Y+x, 31, 31)

#define RECT_INPUT_PUTPAD CGRectMake(42, 5, 202, 35)

// 输入面板基础高度，输入面板的高度随内容变化，此为最小高度
#define INPUTPAD_HEIGHT_MIN  45
// 输入面板最大高度
#define INPUTPAD_HEIGHT_MAX  103.5


#define CONTENT_HEIGHT   35
#define CONTENT_TOP      ((INPUTPAD_HEIGHT_MIN - CONTENT_HEIGHT)/2)
#define VIEW_GAP         10
#define RIGHT_BTN_WIDTH  62


@implementation InputTextView
@end


@interface NIMInputPad()<AVAudioRecorderDelegate,UITextViewDelegate>
{
    struct{
        unsigned int    hasText:1;
        unsigned int    mediaPadShown:1;
        unsigned int    isCancelRecording:1;
        unsigned int    isPushBtn;
        unsigned int    isOriginMove;
    }_inputPadFlag;
    
    NSTimer             *timer;
    
    int                 inPutpadHeight;
    int                 inPutPadH;
    int                 maginGlobal;
    int                 richBtnY;
    
    NSString            *_inputStr;
    
}

@property (nonatomic, strong)UIButton      *n_recordBtn;
@property (nonatomic, strong)UIButton      *n_audioBtn;
@property (nonatomic, strong)UIButton      *n_emojiBtn;
@property (nonatomic, strong)UIButton      *n_padBtn;
@property (nonatomic, strong)UIButton      *n_addBtn;

@property (nonatomic)NSRange                 lastTextRange;
@property (nonatomic,strong) AVAudioRecorder *recorder;
@end

@implementation NIMInputPad

- (void)dealloc
{
    _inputStr               = nil;
    self.n_recordBtn          = nil;
    self.recorder.delegate  = nil;
    self.recorder           = nil;
    
    self.n_audioBtn         = nil;
    self.n_emojiBtn         = nil;
    self.n_padBtn           = nil;
    self.n_addBtn           = nil;
}

+ (NSInteger)height
{
    return 45;
}

- (UIButton *)makeButtonWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    if(![image isEqual:highlightImage])
    {
        [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    }
    else
    {
        [btn setHighlighted:YES];
    }
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, [[self class] height])];
    
    if (self)
    {
//        self.layer.contents = (__bridge id)(IMGGET(@"bg_chat_input"].CGImage);
        
        [self addSubview:self.n_audioBtn];
        [self addSubview:self.n_recordBtn];
        [self addSubview:self.inputTextView];
        [self addSubview:self.n_emojiBtn];
        [self addSubview:self.n_addBtn];
        [self addSubview:self.n_padBtn];
        
        self.n_audioBtn.frame    = RECT_INPUT_BTN1;
        self.inputTextView.frame = RECT_INPUT_PUTPAD;
        self.n_recordBtn.frame     = RECT_INPUT_PUTPAD;
        self.n_emojiBtn.frame    = RECT_INPUT_BTN2;
        self.n_addBtn.frame      = RECT_INPUT_BTN3;
        
        self.inputPadMode = kInputPadModeDefault;
        
    }
    return self;
}

- (void)setInputPadMode:(NIMInputPadMode)mode
{
    if (_inputPadMode == mode)
    {
        if (_inputPadMode == kMediaPadHide)
        {
            return;
        }
        else if (_inputPadMode == kInputPadModeText)
        {
            return;
        }
        else
        {
            self.inputPadMode = kInputPadModeText;
            return;
        }
    }
    _inputPadMode = mode;
    switch (mode) {
        case kInputPadModeDefault:
            [_inputTextView resignFirstResponder];
            self.n_audioBtn.frame = RECT_INPUT_BTN1_MAGIN_GLOBAL(maginGlobal);
            self.n_emojiBtn.frame = RECT_INPUT_BTN2_MAGIN_GLOBAL(maginGlobal);
            
            self.inputTextView.hidden = NO;
            self.n_recordBtn.hidden = YES;
            
            self.n_padBtn.hidden = YES;
            self.n_audioBtn.hidden = NO;
            self.n_emojiBtn.hidden = NO;
            break;
            
        case kInputPadModeText:
            if([_inputStr length]>0)
            {
                _inputTextView.text = _inputStr;
                [self textViewDidChange:_inputTextView];
                _inputStr = nil;
            }
            [_inputTextView becomeFirstResponder];
            self.n_audioBtn.frame = RECT_INPUT_BTN1_MAGIN_GLOBAL(maginGlobal);
            self.n_emojiBtn.frame = RECT_INPUT_BTN2_MAGIN_GLOBAL(maginGlobal);
            
            self.inputTextView.hidden = NO;
            self.n_recordBtn.hidden = YES;
            
            self.n_padBtn.hidden = YES;
            self.n_audioBtn.hidden = NO;
            self.n_emojiBtn.hidden = NO;
            
            break;
            
        case kInputPadModeAudio:
        {
            _inputStr = _inputTextView.text;
            _inputTextView.text = nil;
            [self textViewDidChange:_inputTextView];
            [_inputTextView resignFirstResponder];
            
            self.n_padBtn.frame = RECT_INPUT_BTN1_MAGIN_GLOBAL(maginGlobal);
            self.n_emojiBtn.frame = RECT_INPUT_BTN2_MAGIN_GLOBAL(maginGlobal);
            
            self.inputTextView.hidden = YES;
            self.n_recordBtn.hidden = NO;
            self.n_recordBtn.frame = self.inputTextView.frame;
            
            self.n_padBtn.hidden = NO;
            self.n_audioBtn.hidden = YES;
            self.n_emojiBtn.hidden = NO;
            
            [_delegate hideChatMediaPad];
            
        }
            break;
        case kInputPadModeEmoji:
            if([_inputStr length]>0)
            {
                _inputTextView.text = _inputStr;
                [self textViewDidChange:_inputTextView];
                _inputStr = nil;
            }
            [_inputTextView resignFirstResponder];
            
            self.n_audioBtn.frame = RECT_INPUT_BTN1_MAGIN_GLOBAL(maginGlobal);
            self.n_padBtn.frame = RECT_INPUT_BTN2_MAGIN_GLOBAL(maginGlobal);
            
            self.inputTextView.hidden = NO;
            self.n_recordBtn.hidden = YES;
            
            self.n_padBtn.hidden = NO;
            self.n_audioBtn.hidden = NO;
            self.n_emojiBtn.hidden = YES;
            
            break;
        case kInputPadModeAdd:
            if([_inputStr length]>0)
            {
                _inputTextView.text = _inputStr;
                [self textViewDidChange:_inputTextView];
                _inputStr = nil;
            }
            [_inputTextView resignFirstResponder];
            
            self.n_audioBtn.frame = RECT_INPUT_BTN1_MAGIN_GLOBAL(maginGlobal);
            self.n_emojiBtn.frame = RECT_INPUT_BTN2_MAGIN_GLOBAL(maginGlobal);
            
            self.inputTextView.hidden = NO;
            self.n_recordBtn.hidden = YES;
            
            self.n_padBtn.hidden = YES;
            self.n_audioBtn.hidden = NO;
            self.n_emojiBtn.hidden = NO;
            
            break;
            
        case kMediaPadHide:
            
            _inputPadFlag.mediaPadShown = NO;
            [_inputTextView resignFirstResponder];
            [_delegate hideChatMediaPad];
        default:
            break;
    }
    [_delegate inputPadModeChanged:self];
}

#pragma mark - 切后台，干掉录音
- (void)willResignActive:(NSNotification *)notification
{
    // [self voiceRecordTouchUpInside];
    _inputPadFlag.isCancelRecording = YES;
    [self cancelRecording];
}

- (void)setUpResignActiveObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)removeResignActiveObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
}


#pragma mark - action


- (void)nAddBtnPressed
{
    self.inputPadMode =  kInputPadModeAdd;
}

- (void)nAudioPressed
{
    self.inputPadMode =  kInputPadModeAudio;
}

- (void)nEmojiPressed
{
    self.inputPadMode =  kInputPadModeEmoji;
}

- (void)nPadPressed
{
    self.inputPadMode =  kInputPadModeText;
}

- (void)richBtnPressed
{
    if (_inputPadFlag.mediaPadShown)
    {
        if ([_delegate richPadIsShown])
        {
            return;
        }
        else
        {
            self.inputPadMode = kMediaPadHide;
            _inputPadFlag.mediaPadShown = NO;
        }
    }
    else
    {
        _inputPadFlag.mediaPadShown = YES;
        //        self.inputPadMode = kInputPadModeRich;
    }
}

- (void)sendBtnPressed
{
    if([_delegate respondsToSelector:@selector(inputPadSendTextRequested:)])
        [_delegate inputPadSendTextRequested:self];
}

- (void)beginRecording
{
    [self setRecordBtn:YES];
    _inputPadFlag.isPushBtn = YES;
    [self performSelector:@selector(doBeginRecording) withObject:nil afterDelay:0];
}


- (void)endRecording
{
    [self setRecordBtn:NO];
    _inputPadFlag.isPushBtn = NO;
    [self performSelector:@selector(doEndRecording) withObject:nil afterDelay:0];
}


- (void)draggedOut: (UIControl *) c withEvent: (UIEvent *) ev
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    CGPoint point = [[[ev allTouches] anyObject] locationInView:window];
    
    CGRect frame = [NRecordBezel panelBoundRect];
    
    //这里判断是否是在录音框中了
    if(CGRectContainsPoint(frame, point))
    {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView *bezel = [window viewWithTag:RECORD_BEZEL_TAG];
        if (bezel) {
            if ([bezel superview]) {
                [(NRecordBezel *)bezel setTitle:RECORD_BEZEL_TITLE_CANCEL_TIP];
                
            }
        }
    }
    else
    {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView *bezel = [window viewWithTag:RECORD_BEZEL_TAG];
        if (bezel) {
            if ([bezel superview]) {
                [(NRecordBezel *)bezel setTitle:RECORD_BEZEL_TITLE_ACTION_TIP];
            }
        }
    }
}

- (void)cancelRecording
{
    _inputPadFlag.isPushBtn = NO;
    [self performSelector:@selector(doCancelRecording) withObject:nil afterDelay:0];
}

- (void)replaceSelectedTextWith:(NSString *)theText
{
    // HTLog(@"=== theText in replace is: %@===", theText);
    if (theText == nil)
    {
        theText = @"";
    }
    if ([_inputTextView isFirstResponder])
    {
        [self replaceTextInRange:self.lastTextRange withText:theText];
    }
    else
    {
        [self holdPlace:NO];
        [self replaceTextInRange:self.lastTextRange withText:theText];
        [self holdPlace:YES];
    }
}

- (CGSize)clearText
{
    CGSize size = self.frame.size;
    self.lastTextRange = NSMakeRange(0, [self.inputTextView.text length]);
    [self replaceSelectedTextWith:@""];
    
    return size;
}

- (void)deleteEmojiText
{

    NSString  *newStr = [NSString nim_emojiDelete:self.inputTextView.text ];
    if(newStr == nil || [newStr isEqualToString:self.inputTextView.text])
    {
        NSString *oldStr = self.inputTextView.text;
        if([oldStr length] >0)
        {
            self.inputTextView.text =  [oldStr substringWithRange:NSMakeRange(0 , [oldStr length] -1)];
        }
        
    }
    else
    {
        self.inputTextView.text = newStr;
    }
    
    
    [self textViewDidChange:_inputTextView];

}

#pragma mark

/*
 * 置空请求
 */
- (void)holdPlace:(BOOL)hold
{
    // textView实际文本长度为空时响应请求
    if (_inputPadFlag.hasText == NO)
    {
        if (hold)
        {
            self.inputTextView.textColor = [UIColor grayColor];
            self.inputTextView.text = self.placeholder;
            self.inputTextView.font = [UIFont systemFontOfSize:17];
            self.inputTextView.contentOffset = CGPointMake(0, 1);
        }
        else
        {
            self.inputTextView.textColor = [UIColor blackColor];
            self.inputTextView.font = [UIFont systemFontOfSize:17];
            self.inputTextView.contentOffset = CGPointMake(0, 1);
        }
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)tv
{
    self.inputPadMode = kInputPadModeText;
    [self holdPlace:NO];
    return YES;
}

/*
 * 注意textView.selectedRange失去焦点时会失效
 */
- (BOOL)textViewShouldEndEditing:(UITextView *)tv
{
    //self.inputPadMode = kInputPadModeText;
    // 失去焦点前保存
    self.lastTextRange = self.inputTextView.selectedRange;
    //    [self becomeFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)tv
{
    //    [self updateButtons];
}

- (void)textViewDidEndEditing:(UITextView *)tv
{
    //    [self updateButtons];
    // 失去焦点后恢复
    //textView.selectedRange = lastTextRange;
    //[self holdPlace:YES];
}

- (void)replaceTextInRange:(NSRange)range withText:(NSString *)theText {
    NSString *oldText = self.inputTextView.text;
    //HTLog(@"=== oldText in replace is: %@, and the range is: %@===", oldText, NSStringFromRange(range));
    
    NSInteger len = TEXT_LENGTH_MAX - ([oldText length] - range.length);
    if (len > 0) {
        if (len < [theText length]) {
            theText = [theText substringToIndex:len];
        }
        //HTLog(@"=== oldText in replace is: %@, and the range is: %@===", oldText, NSStringFromRange(range));
        if (range.location > [oldText length]) {
            range.location = [oldText length];
        }
        self.inputTextView.text = [oldText stringByReplacingCharactersInRange:range withString:theText];
        //HTLog(@"text = %@",textView.text);
        self.inputTextView.selectedRange = NSMakeRange(range.location + [theText length], 0);
        self.lastTextRange = self.inputTextView.selectedRange;
        //        hasText = self.inputTextView.hasText;
        [self.inputTextView.delegate textViewDidChange:self.inputTextView];
    }
}


- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)theText {
    

    if([theText length] == 0)
    {
        if([self.inputTextView.text length]==0)
        {
            return YES;
            
        }
        
        NSString *str = [self.inputTextView.text substringWithRange:NSMakeRange(0, range.location +1)];
        NSString  *newStr = [NSString nim_emojiDelete:str];
        
        if(newStr == nil || [newStr isEqualToString:str])
        {
            
            return YES;
        }
        else
        {
            if([self.inputTextView.text length] != range.location +1)
            {
                NSMutableString *newEmojiStr = [NSMutableString stringWithString:newStr];
                NSString *laststr = [self.inputTextView.text substringWithRange:NSMakeRange(range.location + range.length, [self.inputTextView.text length] - range.location- range.length)];
                if(laststr)
                {
                    [newEmojiStr appendString:laststr];
                }
                //                NSRange rang =  self.inputTextView.selectedRange;
                range.location = range.location - (str.length - newStr.length ) +1;
                range.length = 0;
                self.inputTextView.text = newEmojiStr;
                self.inputTextView.selectedRange = range;
            }
            else
            {
                NSRange rang =  self.inputTextView.selectedRange;
                self.inputTextView.text = newStr;
                self.inputTextView.selectedRange = rang;
            }
            
            return NO;
        }
        
    }
    else
    {
        if ([theText isEqualToString:@"\n"]) {
            [self sendBtnPressed];
            return NO;
        }
        
        
    }
    
    if([tv.text length] + [theText length]>= TEXT_LENGTH_MAX)
    {
        return NO;
    }
    return YES;
    

}


- (void)textViewDidChange:(UITextView *)tv {
    
    //    NSString *txt = tv.text;
    //    txt = [txt stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    //    txt = [txt stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    tv.text = txt;
    
    int len = tv.text.length;
    if(len >0)
    {
        _inputPadFlag.hasText = YES;
    }
    if ( len > TEXT_LENGTH_MAX)
    {
        tv.text = [tv.text substringToIndex:TEXT_LENGTH_MAX];
    }
    [self relayout];
    
}

- (void)relayout
{
    CGSize oldSize = self.inputTextView.frame.size;
    CGSize newSize = [self.inputTextView sizeThatFits:CGSizeMake(oldSize.width, INT_MAX)];
    
    if (newSize.height == 37)
    {
        newSize.height = CONTENT_HEIGHT;
    }
    
    if (newSize.height > 85)
    {
        newSize.height = 85;
        self.inputTextView.scrollEnabled = YES;
    }
    else
    {
        self.inputTextView.scrollEnabled = NO;
    }
    
    if (newSize.height < CONTENT_HEIGHT) {
        newSize.height = CONTENT_HEIGHT;
    }
    
    if (fabsf(newSize.height - oldSize.height) > 5)
    {
        if (newSize.height != CONTENT_HEIGHT)
        {
            //            isSendCallInputPadFrameChanged = NO;
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        
        CGRect r = self.inputTextView.frame;
        r.size.height = newSize.height;
        int magin = newSize.height - oldSize.height;
        self.inputTextView.frame = r;
        NSRange rang =  self.inputTextView.selectedRange;
        
        self.inputTextView.text = self.inputTextView.text;
        
        self.inputTextView.selectedRange = rang;
        r = self.n_audioBtn.frame;
        r.origin.y += magin;
        richBtnY = r.origin.y;
        self.n_audioBtn.frame = r;
        
        r = self.n_emojiBtn.frame;
        r.origin.y += magin;
        self.n_emojiBtn.frame = r;
        
        r = self.n_padBtn.frame;
        r.origin.y += magin;
        self.n_padBtn.frame = r;
        
        r = self.n_addBtn.frame;
        r.origin.y += magin;
        self.n_addBtn.frame = r;
        
        r = self.frame;
        r.origin.y -= magin;
        r.size.height += magin;
        self.frame = r;
        
        inPutpadHeight = self.frame.size.height;
        inPutPadH = inPutpadHeight;
        
        
        maginGlobal += magin;
        
        [UIView commitAnimations];
        
        
        [_delegate inputPadFrameChanged:self textViewMargin:magin];
    }
    else
    {
        CGRect line = [self.inputTextView caretRectForPosition:self.inputTextView.selectedTextRange.start];
        
        CGFloat overflow = line.origin.y + line.size.height - ( self.inputTextView.contentOffset.y + self.inputTextView.bounds.size.height - self.inputTextView.contentInset.bottom - self.inputTextView.contentInset.top );
        
        if ( overflow > 0 )
        {
            CGPoint offset = self.inputTextView.contentOffset;
            
            offset.y += overflow + 7; // leave 7 pixels margin
            
            // Cannot animate with setContentOffset:animated: or caret will not appear
            
            [UIView animateWithDuration:.2 animations:^{
                
                [self.inputTextView setContentOffset:offset];
                
            }];
            
        }
        
    }
    
    
}



- (void)textViewDidChangeSelection:(UITextView *)textView {
    
}


#pragma mark recording
- (NSDictionary *)recordSettings {
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];

    // aac
    /*
     [settings setObject:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
     [settings setObject:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
     [settings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
     [settings setObject:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
     [settings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
     [settings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
     [settings setObject:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
     [settings setObject:[NSNumber numberWithInt:8000] forKey:AVEncoderBitRateKey];
     [settings setObject:[NSNumber numberWithInt:8] forKey:AVEncoderBitDepthHintKey];
     [settings setObject:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVSampleRateConverterAudioQualityKey];
    */
    
//    [settings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];//音乐格式
//    [settings setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];//音乐采样率
//    [settings setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];//音乐通道数
//    [settings setValue:[NSNumber numberWithInt:8000] forKey:AVEncoderBitRateKey];//音频比特率
//    [settings setValue:[NSNumber numberWithInt:1] forKey:AVEncoderBitRatePerChannelKey];//标识每通道的音频比特率
    
    /*
     // wav
     [settings setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
     [settings setObject:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
     [settings setObject:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
     [settings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
     [settings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
     [settings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
     */
    
    //mp3
    [settings setObject:[NSNumber numberWithFloat:RATE_SAMPLE] forKey:AVSampleRateKey];
    [settings setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [settings setObject:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    return settings;
}

- (void)doBeginRecording {
    
    if (_inputPadFlag.isPushBtn)
    {
        _inputPadFlag.isCancelRecording = NO;
        [_delegate inputPadWillRecord:self];
        NSURL *recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedTempFile"]];
        if (recordedFile) {
            NSError *err = nil;
            AVAudioRecorder* theRecorder = [[AVAudioRecorder alloc] initWithURL:recordedFile
                                                                       settings:[self recordSettings]
                                                                          error:&err];
            [theRecorder recordForDuration:60];
            theRecorder.delegate = self;
            if (theRecorder && (err == nil))
            {
                [self setUpResignActiveObserver];
                theRecorder.meteringEnabled = YES;
                NRecordBezel *bezel = [[NRecordBezel alloc] initWithFrame:CGRectMake(0, 0, 320, 480) recorder:theRecorder];
                bezel.inputPad = self;
                bezel.tag = RECORD_BEZEL_TAG;
                
                [theRecorder prepareToRecord];
                if ([theRecorder record])
                {
                    [bezel show];
                    self.recorder = theRecorder;
                }
                else
                {
                    DBLog(@"AVAudioRecorder settings incorrect");
                }
                
            }else{
                DBLog(@"err:%@",err);
            }
        }
    }
}

- (void)removeRecordBezel
{
    BOOL isTouchCancel = NO;
    if (self.recorder.recording)
    {
        //        recordCurrentTime = recorder.currentTime;
        [_recorder stop];
    }
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *bezel = [window viewWithTag:RECORD_BEZEL_TAG];
    if (bezel) {
        if ([bezel superview]) {
            
            if([[(NRecordBezel *)bezel title] isEqualToString:RECORD_BEZEL_TITLE_ACTION_TIP])
            {
                isTouchCancel = YES;
            }
            [(NRecordBezel *)bezel getRidOffSelf];
            [(NRecordBezel *)bezel stop];
            [(NRecordBezel *)bezel tRemoveSelf];
        }
    }
    
    NSURL *audioURL = self.recorder.url;
    self.recorder = nil;
    
    NSError *err = nil;
    CGFloat total = 0;
    AVAudioPlayer *thePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL
                                                                      error:&err];
    if (thePlayer && (err == nil)) {
        total = thePlayer.duration;
    }
    
    if (!_inputPadFlag.isCancelRecording)
    {
        if (total < 1.0)
        {
            [self.n_recordBtn setEnabled:NO];
            //too short
            err = nil;
            [[NSFileManager defaultManager] removeItemAtURL:audioURL error:&err];
            [self performSelector:@selector(makeRecordBtnEnable) withObject:nil afterDelay:0.8];
            
        }
        else
        {
            if(isTouchCancel)
            {
                
                [self setRecordBtn:NO];
                if([_delegate respondsToSelector:@selector(inputPadCancelRecord:)])
                {
                    [_delegate inputPadCancelRecord:self];
                }
            }
            else
            {
                [_delegate inputPadDidRecord:self audioPath:[audioURL path]];
            }
            
            
        }
        
    }
    else
    {
        err = nil;
        [[NSFileManager defaultManager] removeItemAtURL:audioURL error:&err];
        _inputPadFlag.isCancelRecording = NO;
    }
    
}

- (void)doCancelRecording
{
    [self removeRecordBezel];
}

- (void)doEndRecording {
    if (_recorder == nil) {
        return;
    }
    
    [self removeResignActiveObserver];
    [self removeRecordBezel];
}

- (void)makeRecordBtnEnable
{
    [self.n_recordBtn setEnabled:YES];
}


#pragma mark ActiveObserving


#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    //    NSError * error = nil;
    //    if (![[AVAudioSession sharedInstance] setActive:NO withFlags:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error])
    //        {
    //        DBLog(@"------->setActive %@", error);
    //        }
    
    [SSIMSpUtil endAudioSession];
}

#pragma mark - getter

- (InputTextView *)inputTextView
{
    if(!_inputTextView)
    {
        _inputTextView = [[InputTextView alloc] init];
        _inputTextView.multipleTouchEnabled = NO;
        _inputTextView.font = [UIFont systemFontOfSize:15];
        _inputTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.textAlignment = NSTextAlignmentLeft;
        _inputTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTextView.bounces = NO;
        _inputTextView.contentInset = UIEdgeInsetsZero;
        _inputTextView.layer.cornerRadius = 8;
        _inputTextView.layer.borderColor = UIColorOfHex(0x949494).CGColor;
        _inputTextView.layer.borderWidth = 1;
        _inputTextView.scrollEnabled = NO;
        _inputTextView.inputView.backgroundColor = [UIColor redColor];
        _inputTextView.inputAccessoryView.backgroundColor = [UIColor greenColor];
        _inputTextView.delegate = self;
        _inputTextView.scrollsToTop = NO;
        //#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
        //
        //#else
        //        float systemName = [[[UIDevice currentDevice] systemVersion] floatValue];
        //        if(systemName >= 7.0)
        //        {
        //           _inputTextView.tintColor = [SSIMSpUtil getColor:@"ff3020"];
        //        }
        //#endif
        
    }
    return _inputTextView;
}


- (UIButton *)n_addBtn
{
    if(!_n_addBtn)
    {
        UIImage *img      = IMGGET(@"inputpad_add");
        _n_addBtn = [self makeButtonWithImage:nil highlightImage:nil action:@selector(nAddBtnPressed)];
        [_n_addBtn setImage:img forState:UIControlStateNormal];
        _n_addBtn.exclusiveTouch = YES;
    }
    return _n_addBtn;
}

- (UIButton *)n_audioBtn
{
    if(!_n_audioBtn)
    {
        UIImage *img      = IMGGET(@"inputpad_audio");
        _n_audioBtn = [self makeButtonWithImage:nil highlightImage:nil action:@selector(nAudioPressed)];
        [_n_audioBtn setImage:img forState:UIControlStateNormal];
        _n_audioBtn.exclusiveTouch = YES;
    }
    return _n_audioBtn;
}

- (UIButton *)n_emojiBtn
{
    if(!_n_emojiBtn)
    {
        UIImage *img      = IMGGET(@"inputpad_emoji");
        _n_emojiBtn = [self makeButtonWithImage:nil highlightImage:nil action:@selector(nEmojiPressed)];
        [_n_emojiBtn setImage:img forState:UIControlStateNormal];
        _n_emojiBtn.exclusiveTouch = YES;
    }
    return _n_emojiBtn;
}

- (UIButton *)n_padBtn
{
    if(!_n_padBtn)
    {
        UIImage *img      = IMGGET(@"inputpad_pad");
        _n_padBtn = [self makeButtonWithImage:nil highlightImage:nil action:@selector(nPadPressed)];
        [_n_padBtn setImage:img forState:UIControlStateNormal];
        _n_padBtn.exclusiveTouch = YES;
    }
    return _n_padBtn;
}


- (UIButton *)n_recordBtn
{
    if(!_n_recordBtn)
    {
        _n_recordBtn = [self makeButtonWithImage:IMGGET(@"input_speech") highlightImage:IMGGET(@"input_speech_on") action:@selector(endRecording)];
        
        [_n_recordBtn addTarget:self action:@selector(beginRecording) forControlEvents:UIControlEventTouchDown];
        [_n_recordBtn addTarget:self action:@selector(endRecording) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [_n_recordBtn addTarget:self action:@selector(draggedOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [_n_recordBtn addTarget:self action:@selector(cancelRecording) forControlEvents:UIControlEventTouchCancel];
        
        [_n_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_n_recordBtn setTitle:@"按住说话" forState:UIControlStateHighlighted];
        
        [_n_recordBtn setTitleColor:[SSIMSpUtil getColor:@"333333"] forState:UIControlStateNormal];
        _n_recordBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _n_recordBtn.exclusiveTouch = YES;
        
    }
    return _n_recordBtn;
}

- (void)setRecordBtn:(BOOL)touch
{
    if(touch)
    {
        [self.n_recordBtn setBackgroundImage:IMGGET(@"input_speech_on") forState:UIControlStateNormal];
        [self.n_recordBtn setBackgroundImage:IMGGET(@"input_speech_on") forState:UIControlStateHighlighted];
        
        [self.n_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [self.n_recordBtn setTitle:@"按住说话" forState:UIControlStateHighlighted];
    }
    else
    {
        [self.n_recordBtn setBackgroundImage:IMGGET(@"input_speech") forState:UIControlStateNormal];
        [self.n_recordBtn setBackgroundImage:IMGGET(@"input_speech") forState:UIControlStateHighlighted];
        
        [self.n_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [self.n_recordBtn setTitle:@"按住说话" forState:UIControlStateHighlighted];
    }
}

@end
