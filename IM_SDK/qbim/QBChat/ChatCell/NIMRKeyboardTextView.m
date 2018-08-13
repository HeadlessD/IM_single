//
//  NIMRKeyboardTextView.m
//  QianbaoIM
//
//  Created by liunian on 14/9/10.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRKeyboardTextView.h"
#import "NIMRKeyboardInputView.h"
#import "NIMRChatKeyboardView.h"

@interface NIMRKeyboardTextView ()

@end

@implementation NIMRKeyboardTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self setUpInit];
}

- (void)setUpInit {
    self.inputView = nil;
    [self keyboardInputView];
}

- (void)updateWithKeyBoardInputType:(ChatKeyBoardInputType)keyBoardInputType{
    switch (keyBoardInputType) {
        case ChatKeyBoardInputTypeNone:
        {
            self.keyboardInputView.keyBoardInputType = keyBoardInputType;
            self.inputView = nil;
            [self resignFirstResponder];
        }
            break;
        case ChatKeyBoardInputTypeKeyboard:
        {
            self.keyboardInputView.keyBoardInputType = keyBoardInputType;
            self.inputView = nil;
            [self becomeFirstResponder];
        }
            break;
        case ChatKeyBoardInputTypeFace:
        {
            self.keyboardInputView.keyBoardInputType = keyBoardInputType;
            self.inputView = self.keyboardInputView;
            [self becomeFirstResponder];
        }
            break;
        case ChatKeyBoardInputTypeOption:
        {
            self.keyboardInputView.keyBoardInputType = keyBoardInputType;
            self.inputView = self.keyboardInputView;
            [self becomeFirstResponder];
        }
            break;
        default:
            break;
    }
     [self reloadInputViews];
}



#pragma mark setter
-(void)setContentOffset:(CGPoint)s
{
    if(self.tracking || self.decelerating){
        //initiated by user...
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        
        float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
        if(s.y < bottomOffset && self.scrollEnabled){
            self.contentInset = UIEdgeInsetsMake(0, 0, 8, 0); //maybe use scrollRangeToVisible?
        }
        
    }
    
    [super setContentOffset:s];
}
- (void)setKeyBoardInputType:(ChatKeyBoardInputType)keyBoardInputType{
    if (_keyBoardInputType != keyBoardInputType) {
        _keyBoardInputType = keyBoardInputType;
    }
    [self updateWithKeyBoardInputType:keyBoardInputType];
}
#pragma mark getter
- (NIMRKeyboardInputView *)keyboardInputView{
    if (!_keyboardInputView) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGRect frame = CGRectMake(0, 0,  CGRectGetWidth(bounds), 216);
        _keyboardInputView = [[NIMRKeyboardInputView alloc] initWithFrame:frame];
    }
    return _keyboardInputView;
}
@end
