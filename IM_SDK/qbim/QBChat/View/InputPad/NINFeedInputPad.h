//
//  NINFeedInputPad.h
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NIMBaseInputPad.h"


@interface NFeedInputTextView : UITextView

@end

@interface NINFeedInputPad : NIMBaseInputPad

@property (nonatomic, copy)NSString *placeholder;

@property (nonatomic, strong)NFeedInputTextView             *inputTextView;

@property (nonatomic)NSRange                                 lastTextRange;


+ (NSInteger)height;

- (void)replaceSelectedTextWith:(NSString *)theText;

- (CGSize)clearText;

- (void)deleteEmojiText;
- (void)sendBtnPressed;
- (void)holdPlace:(BOOL)hold;

@end
