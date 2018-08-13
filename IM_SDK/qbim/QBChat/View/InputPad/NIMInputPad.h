//
//  IMInputView.h
//  QianbaoIM
//
//  Created by liyan on 14-3-31.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMBaseInputPad.h"

// 文本框字符个数限制
#define  TEXT_LENGTH_MAX 200

#define RECORD_BEZEL_TAG 12121

#import "NIMInputPadHeader.h"

static NSString *const kTGRecordingFilePath = @"audioFiles";
static NSString *const kTGRecordingFileExtension = @"mp3";
static NSTimeInterval const kTGRecordingMaxTime = 60.0;

@interface InputTextView : UITextView

@end

@interface NIMInputPad : NIMBaseInputPad

@property (nonatomic, copy)NSString *placeholder;

@property (nonatomic, strong)InputTextView          *inputTextView;

+ (NSInteger)height;

- (void)endRecording;

- (void)replaceSelectedTextWith:(NSString *)theText;
- (CGSize)clearText;

- (void)deleteEmojiText;
- (void)sendBtnPressed;
@end
