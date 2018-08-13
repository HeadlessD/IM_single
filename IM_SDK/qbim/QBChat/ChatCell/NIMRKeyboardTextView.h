//
//  NIMRKeyboardTextView.h
//  QianbaoIM
//
//  Created by liunian on 14/9/10.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMRKeyboardInputView.h"

@interface NIMRKeyboardTextView : UITextView
@property (nonatomic, assign) ChatKeyBoardInputType  keyBoardInputType;
@property (nonatomic, strong) NIMRKeyboardInputView *keyboardInputView;
@end
