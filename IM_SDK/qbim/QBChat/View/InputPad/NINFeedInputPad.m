//
//  NINFeedInputPad.m
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NINFeedInputPad.h"
#import "NSString+nimregular.h"
#define  CONTENT_HEIGHT 37

#define RECT_INPUT_BTN_OFF_Y    7
#define FEED_RECT_INPUT_PUTPAD          CGRectMake(15, RECT_INPUT_BTN_OFF_Y, 245, CONTENT_HEIGHT)
#define FEED_RECT_INPUT_BTN             CGRectMake(15+245+14, RECT_INPUT_BTN_OFF_Y, 33, 33)
#define FEED_RECT_INPUT_BTN_MAGIN_GLOBAL(x) CGRectMake(15+245+14, RECT_INPUT_BTN_OFF_Y+x, 33, 33)
// 文本框字符个数限制
#define  TEXT_LENGTH_MAX 100



@interface NINFeedInputPad()<UITextViewDelegate>
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
@property (nonatomic,strong)UIButton *n_emojiBtn;

@end

@interface NFeedInputTextView()
@property (nonatomic, retain)UILabel *uilabel;
@end

@implementation NFeedInputTextView

- (void)dealloc
{
    self.uilabel = nil;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _uilabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 160, 16)];
        _CLEAR_BACKGROUND_COLOR_(_uilabel);
        _uilabel.font = FONT_TITLE(14);
        _uilabel.textColor = [SSIMSpUtil getColor:@"bbbbbb"];
        _uilabel.enabled = NO;//lable必须设置为不可用
        _uilabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_uilabel];
    }
    return self;
}

@end


@implementation NINFeedInputPad

- (void)dealloc
{
    self.n_emojiBtn = nil;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, [[self class] height])];
    
    if (self)
    {
        self.layer.contents = (__bridge id)(IMGGET(@"nfeed_inputbg.png").CGImage);
        
        [self addSubview:self.inputTextView];
        [self addSubview:self.n_emojiBtn];
        self.placeholder = @"评论";
        [self holdPlace:YES];
        self.inputTextView.frame = FEED_RECT_INPUT_PUTPAD;
        self.n_emojiBtn.frame    = FEED_RECT_INPUT_BTN;
        
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
            self.n_emojiBtn.frame = FEED_RECT_INPUT_BTN_MAGIN_GLOBAL(maginGlobal);
            
            self.inputTextView.hidden = NO;
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
            self.n_emojiBtn.frame = FEED_RECT_INPUT_BTN_MAGIN_GLOBAL(maginGlobal);
            
            self.inputTextView.hidden = NO;
            self.n_emojiBtn.hidden = NO;
            
            break;
        case kInputPadModeEmoji:
            if([_inputStr length]>0)
            {
                _inputTextView.text = _inputStr;
                [self textViewDidChange:_inputTextView];
                _inputStr = nil;
            }
            [_inputTextView resignFirstResponder];
  
            self.inputTextView.hidden = NO;
//            self.n_emojiBtn.hidden = YES;
            
            break;
        case kMediaPadHide:
            
            _inputPadFlag.mediaPadShown = NO;
            [_inputTextView resignFirstResponder];
            if([_delegate respondsToSelector:@selector(hideChatMediaPad)])
            {
                [_delegate hideChatMediaPad];
            }
        default:
            break;
    }
    if([_delegate respondsToSelector:@selector(inputPadModeChanged:)])
    {
        [_delegate inputPadModeChanged:self];
    }

    
}

- (void)nEmojiPressed
{
    self.inputPadMode =  kInputPadModeEmoji;
}


+ (NSInteger)height
{
    return 50;
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
        }
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        
        CGRect r = self.inputTextView.frame;
        r.size.height = newSize.height;
        int magin = newSize.height - oldSize.height;
        self.inputTextView.frame = r;
        self.inputTextView.text = self.inputTextView.text;

        
        r = self.n_emojiBtn.frame;
        r.origin.y += magin;
        self.n_emojiBtn.frame = r;
        
        
        r = self.frame;
        r.origin.y -= magin;
        r.size.height += magin;
        self.frame = r;
        
        inPutpadHeight = self.frame.size.height;
        inPutPadH = inPutpadHeight;
        
        
        maginGlobal += magin;
        
        [UIView commitAnimations];
        
        if([_delegate respondsToSelector:@selector(inputPadFrameChanged:textViewMargin:)])
        {
            [_delegate inputPadFrameChanged:self textViewMargin:magin];
        }
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
            self.inputTextView.font = [UIFont systemFontOfSize:17];
            self.inputTextView.contentOffset = CGPointMake(0, 1);
        }
        else
        {
            self.inputTextView.uilabel.text = nil;
            self.inputTextView.font = [UIFont systemFontOfSize:17];
            self.inputTextView.contentOffset = CGPointMake(0, 1);
        }
    }
    
    if (hold)
    {
        if(self.inputTextView.text.length == 0)
        {
            self.inputTextView.uilabel.text = self.placeholder;
        }
        else
        {
            self.inputTextView.uilabel.text = nil;
        }

    }
    else
    {
        self.inputTextView.uilabel.text = nil;
    }
}



- (CGSize)clearText
{
    CGSize size = self.frame.size;
    self.lastTextRange = NSMakeRange(0, [self.inputTextView.text length]);
    [self replaceSelectedTextWith:@""];
    self.placeholder = @"评论";
    [self holdPlace:YES];
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

- (void)sendBtnPressed
{
    if([_delegate respondsToSelector:@selector(inputPadSendTextRequested:)])
        [_delegate inputPadSendTextRequested:self];
}

#pragma mark -delegate textView


- (BOOL)textViewShouldBeginEditing:(UITextView *)tv
{
    self.inputPadMode = kInputPadModeText;
//    [self holdPlace:NO];
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


- (void)textViewDidChange:(UITextView *)tv {
    
    
    int len = tv.text.length;
    if(len >0)
    {
        self.placeholder = @"";
        [self holdPlace:YES];
        _inputPadFlag.hasText = YES;
    }
    [self relayout];
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


#pragma mark - get

- (NFeedInputTextView *)inputTextView
{
    if(!_inputTextView)
    {
        _inputTextView = [[NFeedInputTextView alloc] init];
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
//            _inputTextView.tintColor = [SSIMSpUtil getColor:@"ff3020"];
//        }
//#endif
    }
    return _inputTextView;
}


- (UIButton *)n_emojiBtn
{
    if(!_n_emojiBtn)
    {
        UIImage *img      = IMGGET(@"inputpad_emoji.png");
        _n_emojiBtn = [self makeButtonWithImage:nil highlightImage:nil action:@selector(nEmojiPressed)];
        [_n_emojiBtn setImage:img forState:UIControlStateNormal];
        _n_emojiBtn.exclusiveTouch = YES;
    }
    return _n_emojiBtn;
}

- (UIButton *)makeButtonWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.exclusiveTouch = YES;
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


@end
