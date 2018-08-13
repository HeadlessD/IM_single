//
//  NIMRChatKeyboardView.m
//  QianbaoIM
//
//  Created by liunian on 14/8/27.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRChatKeyboardView.h"
#import "WUEmoticonsKeyboardKeyItem.h"
#import "NSString+nimregular.h"
#import <AVFoundation/AVFoundation.h>
#import "NIMRecordBezel.h"
#import "NIMCoreDataManager.h"
#import "NIMRKeyboardInputView.h"

#define kTagBegin   12221
#define RECORD_BEZEL_TAG 12121

@interface NIMRChatKeyboardView ()<UITextViewDelegate, QBRKeyboardInputDelegate, AVAudioRecorderDelegate, NIMRecordBezelDelegate,NIMGrowingTextViewDelegate>
{
    struct{
        unsigned int    hasText:1;
        unsigned int    mediaPadShown:1;
        unsigned int    isCancelRecording:1;
        unsigned int    isPushBtn;
        unsigned int    isOriginMove;
    }_inputPadFlag;
    
    CGFloat _preHeight;
    BOOL   isNormalEnd;
}
@property (nonatomic, strong) UIImageView   *headerView;
@property (nonatomic, strong) UILabel   *headerViewLine;
@property (nonatomic, strong) UIButton      *voiceBtn;
@property (nonatomic, strong) UIButton      *faceBtn;
@property (nonatomic, strong) UIButton      *optionBtn;
@property (nonatomic, strong) UIButton      *voiceTouchBtn;
@property (nonatomic, strong) UIButton      *showBtn;
@property (nonatomic, strong) UILabel   *menuLine;

@property (nonatomic) BOOL isFirstRecord;
@property (nonatomic,assign) BOOL isResignActive;
@property (nonatomic,assign) BOOL isKick;

@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic, assign, readwrite) ChatKeyBoardSelectedType keboardSelectedType;
@end

@implementation NIMRChatKeyboardView
- (void)dealloc{
    _recorder = nil;
    [self doEndRecording1];
    _delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.isOtherKeyboard=NO;
        _isFirstRecord = YES;
        [self makeConstraints];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kickme:) name:NC_NET_BEKICK object:nil];
    }
    return self;
}

- (void)makeConstraints
{
    [self.headerViewLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.leading.equalTo(self.mas_leading);
        make.height.equalTo(@(0.49));
        make.trailing.equalTo(self.mas_trailing);
    }];
    
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.leading.equalTo(self.mas_leading);
        make.bottom.equalTo(self.mas_bottom);
        make.trailing.equalTo(self.mas_trailing);
    }];
    if (self.isPersional==YES) {
        [self.showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.headerView.mas_leading).with.offset(7);
            make.bottom.equalTo(self.headerView.mas_bottom).with.offset(-9);
            make.width.equalTo(@32);
            make.height.equalTo(@32);
        }];
        [self.menuLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.showBtn.mas_leading).with.offset(34);
            make.bottom.equalTo(@0);
            make.width.equalTo(@0.5);
            make.top.equalTo(@0);
        }];
        [self.voiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.showBtn.mas_leading).with.offset(43);
            make.bottom.equalTo(self.headerView.mas_bottom).with.offset(-9);
            make.width.equalTo(@32);
            make.height.equalTo(@32);
        }];
        
    }
    else
    {
        [self.voiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.leading.equalTo(self.headerView.mas_leading).with.offset(7);
            make.bottom.equalTo(self.headerView.mas_bottom).with.offset(-9);
            make.width.equalTo(@32);
            make.height.equalTo(@32);
        }];
    }


    [self.optionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceBtn.mas_top);
        make.trailing.equalTo(self.mas_trailing).with.offset(-7);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    
    [self.faceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.optionBtn.mas_leading).with.offset(-8);
        make.bottom.equalTo(self.voiceBtn.mas_bottom);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
       
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_top).with.offset(7);
        make.leading.equalTo(self.voiceBtn.mas_trailing).with.offset(8);
        make.bottom.equalTo(self.headerView.mas_bottom).with.offset(-8);
        make.trailing.equalTo(self.faceBtn.mas_leading).with.offset(-8);
    }];
    
    [self.voiceTouchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_top).with.offset(7);
        make.leading.equalTo(self.textView.mas_leading);
//        make.bottom.equalTo(self.headerView.mas_bottom).with.offset(-8);
        make.trailing.equalTo(self.textView.mas_trailing);
        make.height.equalTo(@35);
        
    }];

}
-(void)kickme:(NSNotification*)noti{
    _isKick = YES;
    isNormalEnd = YES;
    [self cancelRecording];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark public methods
- (void)resetDefault{
    if (_keboardSelectedType == ChatKeyBoardSelectedTypeNone) {
        return;
    }
    self.optionBtn.selected = NO;
    self.faceBtn.selected = NO;
    self.voiceBtn.selected = NO;
    _keboardSelectedType = ChatKeyBoardSelectedTypeNone;
    [self actionNotice];
   self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeNone;
    

    
}
- (void)showTextKeyboard:(ChatKeyBoardSelectedType)type{
    _keboardSelectedType = type;
}
- (void)updateForVoice{

    if (_keboardSelectedType == ChatKeyBoardSelectedTypeVoice) {
        self.voiceTouchBtn.hidden = NO;
        self.textView.hidden = YES;
        [self updateHeaderView];
    }else{
        self.voiceTouchBtn.hidden = YES;
        self.textView.hidden = NO;
        [self updateWithText:self.textView.text];
    }
}
- (void)setRecordBtn:(BOOL)touch
{
    if(touch){
        [self.voiceTouchBtn setHighlighted:YES];
        
    }else{
        [self.voiceTouchBtn setHighlighted:NO];
    }
}


#pragma mark - 切后台，干掉录音
- (void)willResignActive:(NSNotification *)notification
{
    // [self voiceRecordTouchUpInside];
    _isResignActive = YES;
    _inputPadFlag.isCancelRecording = YES;
    
    if (self.recorder.recording)
    {
        [_recorder stop];
    }
    
    NSURL *audioURL = self.recorder.url;

    UIView *bezel = [self.window viewWithTag:RECORD_BEZEL_TAG];
    if (bezel) {
        if ([bezel superview]) {
            
            if([[(NIMRecordBezel *)bezel title] isEqualToString:RECORD_BEZEL_TITLE_CANCEL_TIP])
            {
            }
            [(NIMRecordBezel *)bezel getRidOffSelf];
            [(NIMRecordBezel *)bezel stop];
            [(NIMRecordBezel *)bezel tRemoveSelf];
        }
    }
    
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtURL:audioURL error:&err];

}

-(void)didBecomeActive
{
    _isResignActive = NO;
    if ([self.voiceTouchBtn.currentTitle isEqualToString:@"按住 说话"]) {
        _inputPadFlag.isCancelRecording = NO;
        _recorder = nil;
    }
}

- (void)setUpResignActiveObserver
{
    [self removeResignActiveObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}

- (void)removeResignActiveObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (NSString *)fileNamePath{
    NSDateFormatter *fileNameFormatter = [[NSDateFormatter alloc] init];
    [fileNameFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *fileName = [fileNameFormatter stringFromDate:[NSDate date]];
    fileName = [fileName stringByAppendingString:@".caf"];
    NSString *filePath = [[[NIMCoreDataManager currentCoreDataManager] recordPathCaf] stringByAppendingPathComponent:fileName];
    return filePath;
}

- (void)doBeginRecording {
     DLog(@"liyan===============doBeginRecording");
    if (_inputPadFlag.isPushBtn)
    {
        _inputPadFlag.isCancelRecording = NO;

        DLog(@"liyan===============注备路径");
        NSURL *recordedFile = [NSURL fileURLWithPath:[self fileNamePath]];
        DLog(@"liyan===============注备路径完毕");
        [_delegate chatKeyboardView:self willBeginRecordingAtFilePath:[recordedFile path]];
        if (recordedFile) {
            NSError *err = nil;
            AVAudioRecorder* theRecorder = [[AVAudioRecorder alloc] initWithURL:recordedFile
                                                                       settings:[self recordSettings]
                                                                          error:&err];
            DLog(@"liyan===============AVAudioRecorder alloc");
            [theRecorder recordForDuration:60];
            theRecorder.delegate = self;
            
            if (theRecorder && (err == nil))
            {
                [self setUpResignActiveObserver];
                theRecorder.meteringEnabled = YES;
                 DLog(@"liyan===============NIMRecordBezel alloc");
                
                NIMRecordBezel *bezel = [[NIMRecordBezel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) recorder:theRecorder];
                DLog(@"liyan===============NIMRecordBezel end");
                bezel.delegate = self;
                bezel.tag = RECORD_BEZEL_TAG;
                if ([theRecorder prepareToRecord] == YES){
                    if ([theRecorder record])
                    {
                        DLog(@"liyan===============显示bezel");
                        
                        bezel.alpha = 0.1;
                        
                        //UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
                        //[window addSubview:self];
                        [self.window addSubview:bezel];
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDuration:0.3];
                        
                        bezel.alpha = 1.0;
                        
                        [UIView commitAnimations];
                        [bezel show];

                        self.recorder = theRecorder;
                    }
                    else
                    {
                        if(_isFirstRecord){
                            [self beginRecording];
                            _isFirstRecord = NO;
                        }
                        
                        DBLog(@"AVAudioRecorder settings incorrect");
                    }
                }else {
                    int errorCode = CFSwapInt32HostToBig ((uint32_t)[err code]);
                    NSLog(@"Error: %@ [%4.4s])" , [err localizedDescription], (char*)&errorCode);
                    
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
    
    //UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *bezel = [self.window viewWithTag:RECORD_BEZEL_TAG];
    if (bezel) {
        if ([bezel superview]) {
            
            if([[(NIMRecordBezel *)bezel title] isEqualToString:RECORD_BEZEL_TITLE_CANCEL_TIP] ||
               _isKick)
            {
                isTouchCancel = YES;
            }
            [(NIMRecordBezel *)bezel getRidOffSelf];
            [(NIMRecordBezel *)bezel stop];
            [(NIMRecordBezel *)bezel tRemoveSelf];
        }
    }
    
    NSURL *audioURL = self.recorder.url;
    if (!_isResignActive) {
        self.recorder = nil;
    }

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    CMTime time = asset.duration;
    CGFloat secondss = CMTimeGetSeconds(time);
    NSInteger seconds = roundf(secondss);
    
    if (!_inputPadFlag.isCancelRecording)
    {
        if (seconds < 1.0)
        {
            [self.voiceTouchBtn setEnabled:NO];
            //too short
            NSError *err = nil;
            [[NSFileManager defaultManager] removeItemAtURL:audioURL error:&err];
            [self performSelector:@selector(makeRecordBtnEnable) withObject:nil afterDelay:0.4];
            if (!isNormalEnd) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBTip showTipsView:@"录音时间过短" atView:[[UIApplication  sharedApplication] keyWindow]];
                });
            }
        }
        else
        {
            if(isTouchCancel && seconds < 60.0)
            {
                
                [self setRecordBtn:NO];
                [_delegate chatKeyboardView:self didCancelRecordAtFilePath:[audioURL path]];
            }
            else
            {
                [_delegate chatKeyboardView:self didFinishRecordAtFilePath:[audioURL path]];
            }
            
            
        }
         
    }
    else
    {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtURL:audioURL error:&err];
        _inputPadFlag.isCancelRecording = NO;

    }
    
}

- (void)doCancelRecording
{
    [self removeRecordBezel];
}

- (void)doEndRecording {

    if (_isResignActive) {
        return;
    }

    if (_recorder == nil) {
        if (!isNormalEnd) {
            DLog(@"录音时间过短");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBTip showTipsView:@"录音时间过短" atView:self.window];
            });
            
        }
        return;
    }
    
    [self removeResignActiveObserver];
    [self removeRecordBezel];
}

- (void)doEndRecording1 {
    if (_recorder == nil) {
        return;
    }
    
    [self removeResignActiveObserver];
    [self removeRecordBezel];
}

- (void)makeRecordBtnEnable
{
    [self.voiceTouchBtn setEnabled:YES];
}


#pragma mark private methods
- (void)beginRecording
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RecordBeginning" object:nil];
    DLog(@"liyan===============开始按下");
    DBLog(@"beginRecording");
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    DLog(@"liyan===============sharedInstance");
    if(![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]){
        DLog(@"setCategory AVAudioSessionCategoryRecord error: %@ ",[error debugDescription])
    }
    if(![session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]){
        DLog(@"setActive error %@ ",[error debugDescription])
    }
    
    DLog(@"liyan===============requestRecordPermission");
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // Microphone enabled code
                    DLog(@"liyan===============切换按钮样式");
                    if(self.voiceTouchBtn.highlighted)
                    {
                        [self setRecordBtn:YES];
                        _inputPadFlag.isPushBtn = YES;
                        isNormalEnd = NO;
                        _isResignActive = NO;
                        [self doBeginRecording];
                    }
//                    [self performSelector:@selector(doBeginRecording) withObject:nil afterDelay:0.0];
                }
                else {
                    // Microphone disabled code
                    isNormalEnd = YES;
                    [_delegate chatKeyboardView:self didShowError:@"麦克风被禁用，请检查后再进行录音"];
                }
            });
        }];
    }
}

- (void)endRecording
{
    [self.voiceTouchBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    DBLog(@"endRecording");
    [self setRecordBtn:NO];
    _inputPadFlag.isPushBtn = NO;
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if(![session setCategory:AVAudioSessionCategoryPlayback error:&error]){
        DLog(@"%@",[error debugDescription]);;
    }
    if (![session setActive:YES error:&error]) {
        DLog(@"%@",[error debugDescription]);
    }
    
    [self performSelector:@selector(doEndRecording) withObject:nil afterDelay:0];
}

- (void)startRecordVoiceButtonDragExitClicked:(id)sender
{
    //UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *bezel = [self.window viewWithTag:RECORD_BEZEL_TAG];
    if (bezel) {
        if ([bezel superview]) {
            [(NIMRecordBezel *)bezel setTitle:RECORD_BEZEL_TITLE_CANCEL_TIP];
            [self.voiceTouchBtn setTitle:@"松开 取消" forState:UIControlStateNormal];

        }
    }
}

- (void)startRecordVoiceButtonDragEnterClicked:(id)sender
{
    //UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *bezel = [self.window viewWithTag:RECORD_BEZEL_TAG];
    if (bezel) {
        if ([bezel superview]) {
            [(NIMRecordBezel *)bezel setTitle:RECORD_BEZEL_TITLE_ACTION_TIP];
            [self.voiceTouchBtn setTitle:@"松开 结束" forState:UIControlStateNormal];

        }
    }
}

/*
- (void)draggedOut: (UIControl *) c withEvent: (UIEvent *) ev
{
    
    //UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    CGPoint point = [[[ev allTouches] anyObject] locationInView:self.window];
    CGRect frame = [NIMRecordBezel panelBoundRect];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    CGFloat offset = (bounds.size.height-CGRectGetMaxY(frame))/2.0;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+offset);
    //这里判断是否是在录音框中了
    if(CGRectContainsPoint(frame, point)||
       point.x<frame.origin.x||
       point.x>CGRectGetMaxX(frame)||
       point.y<frame.origin.y)
    {
        //UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView *bezel = [self.window viewWithTag:RECORD_BEZEL_TAG];
        if (bezel) {
            if ([bezel superview]) {
                [(NIMRecordBezel *)bezel setTitle:RECORD_BEZEL_TITLE_CANCEL_TIP];
                
            }
        }
    }
    else
    {
        //UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView *bezel = [self.window viewWithTag:RECORD_BEZEL_TAG];
        if (bezel) {
            if ([bezel superview]) {
                [(NIMRecordBezel *)bezel setTitle:RECORD_BEZEL_TITLE_ACTION_TIP];
            }
        }
    }
}
*/


- (void)cancelRecording
{
    _inputPadFlag.isPushBtn = NO;
    [self performSelector:@selector(doCancelRecording) withObject:nil afterDelay:0];
}
#pragma mark actions
- (void)actionNotice{
    [_delegate chatKeyboardView:self didSelectedAction:_keboardSelectedType];
}

- (void)voiceBtnClick:(UIButton *)sender{

    if (_keboardSelectedType == ChatKeyBoardSelectedTypeVoice) {
      
            _keboardSelectedType = ChatKeyBoardSelectedTypeKeyboard;
            self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeKeyboard;
        sender.selected = NO;
        [self actionNotice];
    }else{
        _keboardSelectedType = ChatKeyBoardSelectedTypeVoice;
         [self actionNotice];
        self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeNone;
        sender.selected = YES;
    }
    self.optionBtn.selected = NO;
    self.faceBtn.selected = NO;
    [self updateForVoice];
}

- (void)faceBtnClick:(UIButton *)sender{
//    [self.textView.internalTextView resignFirstResponder];
    if (_keboardSelectedType == ChatKeyBoardSelectedTypeFace) {
    
        _keboardSelectedType = ChatKeyBoardSelectedTypeKeyboard;
            self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeKeyboard;

        sender.selected = NO;
         [self actionNotice];
    }else{
        _keboardSelectedType = ChatKeyBoardSelectedTypeFace;
      // self.textView.editable=NO;
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        
//        t.delegate = self;
        [self.textView.internalTextView addGestureRecognizer:t];
        [self actionNotice];
        self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeFace;
        sender.selected = YES;
    }
    
    self.optionBtn.selected = NO;
    self.voiceBtn.selected = NO;
    [self updateForVoice];
}
-(void) singleTap:(UITapGestureRecognizer*) tap {
    self.textView.editable=YES;

    [self.textView.internalTextView becomeFirstResponder];
    
        _keboardSelectedType = ChatKeyBoardSelectedTypeKeyboard;
    

}
- (void)optionBtnClick:(UIButton *)sender{
    if (_keboardSelectedType == ChatKeyBoardSelectedTypeOption) {
            _keboardSelectedType = ChatKeyBoardSelectedTypeKeyboard;
            self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeKeyboard;
        

        [self actionNotice];
        
     //   self.textView.editable=YES;
        sender.selected = NO;
    }else{
        _keboardSelectedType = ChatKeyBoardSelectedTypeOption;
      //  self.textView.editable=NO;
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        
        //        t.delegate = self;
        [self.textView.internalTextView addGestureRecognizer:t];

        [self actionNotice];
        self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeOption;
        sender.selected = YES;
    }
    self.voiceBtn.selected = NO;
    self.faceBtn.selected = NO;
    
    [self updateForVoice];
}
- (void)voiceTouchBtnClick:(UIButton *)sender{
    
}

- (void)sendText:(NSString *)text{
    
    
    [_delegate chatKeyboardView:self didSendText:text];

    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([text length] > 0 ) {
//        [_delegate chatKeyboardView:self didSendText:text];
        self.textView.text = @"";
//        self.textView.contentOffset = CGPointZero;
        [self textViewDidChangedWithText:self.textView.text];
    }
}

- (void)textViewDidChangedWithText:(NSString *)text{
    [self updateWithText:text];
}

#pragma mark QBRKeyboardInputDelegate
- (void)deleteEmjoiKeyboardInputView:(NIMRKeyboardInputView *)inputView{
    NSString  *newStr = [NSString nim_emojiDelete:self.textView.text ];
    if(newStr == nil || [newStr isEqualToString:self.textView.text])
    {
        NSString *oldStr = self.textView.text;
        if([oldStr length] >0)
        {
            self.textView.text =  [oldStr substringWithRange:NSMakeRange(0 , [oldStr length] -1)];
        }
    }
    else
    {
        self.textView.text = newStr;
    }
    
    [self updateWithText:self.textView.text];
}
- (void)sendKeyboardInputView:(NIMRKeyboardInputView *)inputView{
    [self sendText:self.textView.text];
}
- (void)keyboardInputView:(NIMRKeyboardInputView *)inputView didSelectedbigEmojiFaceItem:(WUEmoticonsKeyboardKeyItem *)item{
    NSString *text = item.textToInput;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([text length] > 0 ) {
        [_delegate chatKeyboardView:self didSendSmiley:text];
    }
}

- (void)keyboardInputView:(NIMRKeyboardInputView *)inputView didSelectedEmojiFace:(NSString *)faceString{
    
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:self.textView.text];
    [string replaceCharactersInRange:self.textView.selectedRange withString:faceString];
    
//    if(text.length>1000)
//    {
//        self.textView.text = [text substringToIndex:1000];
//        return;
//    }
    self.textView.text = string;
    [self updateWithText:string];
    
}
- (void)keyboardInputView:(NIMRKeyboardInputView *)inputView didSelectedKeyBoardOptionActionType:(ChatKeyBoardOptionActionType)actionType{
    [_delegate chatKeyboardView:self didOptionSelectedAction:actionType];
}

#pragma mark Record Config
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
#pragma mark config
//- (CGRect)rectForText:(NSString *)text{
//    CGRect rect = CGRectZero;
////    CGRect rect = CGRectMake(0, 0,CGRectGetWidth(self.textContainerView.frame), 21);
////    if(!text || text.length == 0){
////        return rect;
////    }
//    
//    UIFont *font = self.textView.font;
//    CGSize size = CGSizeMake(CGRectGetWidth(self.textView.frame) - 0, 85);
////    CGFloat width = self.textView.bounds.size.width - 2.0 * self.textView.textContainer.lineFragmentPadding;
////    size.width = width;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paragraphStyle.lineSpacing = 0.f;
//    paragraphStyle.lineHeightMultiple = 0;
//    paragraphStyle.maximumLineHeight = 0;
//    paragraphStyle.minimumLineHeight = 0;
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    NSDictionary *attributes = @{NSFontAttributeName:font,
//                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
//    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
//    rect = [text boundingRectWithSize:size options:options attributes:attributes context:nil];
//    return rect;
//}
//
#pragma mark update

- (void)updateHeaderView{
    CGRect frame1 = self.voiceBtn.frame;
        if (_keboardSelectedType == ChatKeyBoardSelectedTypeVoice) {
            self.frame = CGRectMake(CGRectGetMinX(self.frame),
                                    CGRectGetMinY(self.frame),
                                    CGRectGetWidth(self.frame),
                                    kHeightBoardHeader);
            frame1.origin = CGPointMake(10, 7);
        }else{
            self.frame = CGRectMake(CGRectGetMinX(self.frame),
                                    CGRectGetMinY(self.frame),
                                    CGRectGetWidth(self.frame),
                                    CGRectGetMaxY(self.headerView.frame));
            frame1.origin = CGPointMake(10, CGRectGetHeight(self.headerView.frame) - CGRectGetHeight(frame1) - 7);
        }
//    [self makeConstraints];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(-self.headerView.frame.origin.y);
        make.leading.equalTo(self.mas_leading);
        make.bottom.equalTo(self.mas_bottom);
        make.trailing.equalTo(self.mas_trailing);
    }];
    if (CGRectGetHeight(self.frame) != _preHeight ) {
        _preHeight = CGRectGetHeight(self.frame);
        [_delegate chatKeyboardView:self didChangedHeight:_preHeight];
    }
}

- (void)updateWithText:(NSString *)text{

    CGRect textFrame = self.textView.internalTextView.frame;
    CGSize s = [self.textView.internalTextView sizeThatFits:textFrame.size];
    textFrame.size.height = s.height;
    if (CGRectGetHeight(textFrame)< 31) {
        textFrame.size.height = 31;
    }
    if (CGRectGetHeight(textFrame) > 65) {
        textFrame.size.height = 65;
    }

    self.textView.frame = textFrame;
   // self.textView.contentSize = textFrame.size;
//    self.textView.contentOffset = CGPointZero;
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.textView.internalTextView.frame) + 15);
   [self updateHeaderView];
}
- (void)growingTextViewDidBeginEditing:(NIMGrowingTextView *)growingTextView
{
   
//        self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeKeyboard;
//        self.isOtherKeyboard=NO;
//
    if(!_keboardSelectedType)
    {
        _keboardSelectedType = ChatKeyBoardSelectedTypeKeyboard;
    }
    
    [_delegate chatKeyboardView:self didSelectedAction:_keboardSelectedType];
    
    self.optionBtn.selected = NO;
    self.faceBtn.selected = NO;
    
}
- (BOOL)growingTextViewShouldReturn:(NIMGrowingTextView *)growingTextView
{

    return YES;
}

- (void)growingTextView:(NIMGrowingTextView *)growingTextView didChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    //    //NSLog(@"%@",NSStringFromCGRect(self.bottomView.frame));
    CGRect r = self.headerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.headerView.frame = r;
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(growingTextView.frame) + 15);
        [self updateHeaderView];

}

- (BOOL)growingTextView:(NIMGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
#pragma mark 11.14
    
    if ([text isEqualToString:@"\n"]) {
        NSString *str = [NSString nim_trim:growingTextView.text];
        if (IsStrEmpty(str)) {
            [MBTip showError:@"不能发送空白信息" toView:nil];
            self.textView.text =@"";
        }
        else
        {
            [self sendText:growingTextView.text];
        }
        return NO;
    }
    
    return YES;

}

-(void)showBtnClick:(id)sender
{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(showPublicBottomView)])
    {
        [self.delegate showPublicBottomView];
    }
}

#pragma mark 11.14
- (void)growingTextViewDidChange:(NIMGrowingTextView *)growingTextView
{
    NSInteger length = growingTextView.text.length;

    long textint = length%500>0 ? length/500+1 :length/500;
    NSString *sendstring;
    if (textint <= 1) {
        sendstring= [growingTextView.text substringFromIndex:0];
        
    }else{
        sendstring= [growingTextView.text substringWithRange:NSMakeRange(0,500)];
    }
    if (length>=501) {
        
        [MBTip showError:@"超过限定长度" toView:nil];
        growingTextView.text = sendstring;
    }
    
    
    
//    NSInteger number = [growingTextView.text length];
//    if (number > 1000) {
//        growingTextView.text = [growingTextView.text substringWithRange:NSMakeRange(0, number)];
//        number = 1000;
//        //        [textView scrollRangeToVisible:NSMakeRange(number, 1)];
//        
//    }
//    self.textView.internalTextView.keyBoardInputType = ChatKeyBoardInputTypeKeyboard;

}

#pragma mark RecordBezelDelegate
- (void)endRecordrecordBezel:(NIMRecordBezel *)recordBezel{
    [self setRecordBtn:NO];
    _inputPadFlag.isPushBtn = NO;
    isNormalEnd = YES;
    [self performSelector:@selector(doEndRecording) withObject:nil afterDelay:0];
}
#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [SSIMSpUtil endAudioSession];
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}
#pragma mark getter
- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerView.clipsToBounds = YES;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.userInteractionEnabled = YES;
        UIImage *img_header = [IMGGET(@"bg_tabbar.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)
                                                                      resizingMode:UIImageResizingModeStretch];
        
        [_headerView setImage:img_header];
//        _headerView.layer.borderWidth = 1;
//        _headerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_headerView];
    }
    return _headerView;
}

-(UILabel *)headerViewLine
{
    if (!_headerViewLine) {
        _headerViewLine = [[UILabel alloc]initWithFrame:CGRectZero];
        _headerViewLine.backgroundColor = [SSIMSpUtil getColor:@"bbbbbb"];
        [self.headerView addSubview:_headerViewLine];
    }
    return _headerViewLine;
}

-(UILabel *)menuLine
{
    if (!_menuLine) {
        _menuLine = [[UILabel alloc]initWithFrame:CGRectZero];
        _menuLine.backgroundColor = [SSIMSpUtil getColor:@"c9c9c9"];
        [self addSubview:_menuLine];
    }
    return _menuLine;
}
- (NIMGrowingTextView *)textView{
    if (!_textView) {
        _textView = [[NIMGrowingTextView alloc] initWithFrame:CGRectZero];
        _textView.isScrollable = NO;
        _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _textView.enablesReturnKeyAutomatically=YES;
        _textView.minNumberOfLines = 1;
        _textView.maxNumberOfLines = 3;
        // you can also set the maximum height in points with maxHeight
        _textView.maxHeight = 65.0f;
        _textView.returnKeyType = UIReturnKeySend; //just as an example
        _textView.font = [UIFont systemFontOfSize:15.0f];
        _textView.delegate=self;
        _textView.internalTextView.keyboardInputView.delegate = self;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4.0;
        _textView.layer.borderWidth = 0.1;
        _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholder = @"请输入发送的信息";
        _textView.translatesAutoresizingMaskIntoConstraints = YES;
        [self addSubview:_textView];
    }
    return _textView;
}

- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_nor = IMGGET(@"icon_dialog_micro");
        UIImage *img_sel = IMGGET(@"icon_dialog_keyboard");
        _voiceBtn.frame = CGRectZero;
        
        [_voiceBtn setImage:img_nor forState:UIControlStateNormal];
        [_voiceBtn setImage:img_sel forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (UIButton *)faceBtn{
    if (!_faceBtn) {
        _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_nor = IMGGET(@"icon_dialog_phiz");
        UIImage *img_sel = IMGGET(@"icon_dialog_keyboard");
        _faceBtn.frame = CGRectZero;
        
        [_faceBtn setImage:img_nor forState:UIControlStateNormal];
        [_faceBtn setImage:img_sel forState:UIControlStateSelected];
        [_faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_faceBtn];
    }
    return _faceBtn;
}

- (UIButton *)optionBtn{
    if (!_optionBtn) {
        _optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_nor = IMGGET(@"icon_dialog_more");
        UIImage *img_sel = IMGGET(@"icon_dialog_keyboard");
        _optionBtn.frame = CGRectZero;
        [_optionBtn setImage:img_nor forState:UIControlStateNormal];
        [_optionBtn setImage:img_sel forState:UIControlStateSelected];
        [_optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_optionBtn];
    }
    return _optionBtn;
}
- (UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showBtn.frame = CGRectZero;
        [_showBtn setImage:IMGGET(@"icon_menu") forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showBtn];
    }
    return _showBtn;
}


- (UIButton *)voiceTouchBtn{
    if (!_voiceTouchBtn) {
        _voiceTouchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_nor = IMGGET(@"bt_n_record_normal");
        UIImage *img_sel = IMGGET(@"bt_n_record_selected");
        _voiceTouchBtn.frame = CGRectZero;
        _voiceTouchBtn.hidden = YES;
        
        UIImage *img_voice_nor = [img_nor resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)
                                                         resizingMode:UIImageResizingModeStretch];
        UIImage *img_voice_hig = [img_sel resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)
                                                         resizingMode:UIImageResizingModeStretch];
        [_voiceTouchBtn setBackgroundImage:img_voice_nor forState:UIControlStateNormal];
        [_voiceTouchBtn setBackgroundImage:img_voice_hig forState:UIControlStateHighlighted];

        [_voiceTouchBtn addTarget:self action:@selector(beginRecording) forControlEvents:UIControlEventTouchDown];
        [_voiceTouchBtn addTarget:self action:@selector(endRecording)   forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        
//        [_voiceTouchBtn addTarget:self action:@selector(draggedOut:withEvent:)
//                 forControlEvents:UIControlEventTouchDragOutside];
        [_voiceTouchBtn addTarget:self action:@selector(cancelRecording)
                 forControlEvents:UIControlEventTouchCancel];
        
        [_voiceTouchBtn addTarget:self action:@selector(startRecordVoiceButtonDragExitClicked:) forControlEvents:UIControlEventTouchDragExit];
        [_voiceTouchBtn addTarget:self action:@selector(startRecordVoiceButtonDragEnterClicked:) forControlEvents:UIControlEventTouchDragEnter];
        
        [_voiceTouchBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceTouchBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        
        [_voiceTouchBtn setTitleColor:[SSIMSpUtil getColor:@"333333"] forState:UIControlStateNormal];
        _voiceTouchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_voiceTouchBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
        _voiceTouchBtn.exclusiveTouch = YES;
        [self addSubview:_voiceTouchBtn];
    }
    return _voiceTouchBtn;
}
@end
