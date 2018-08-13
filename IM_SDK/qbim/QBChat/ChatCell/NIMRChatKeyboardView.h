//
//  NIMRChatKeyboardView.h
//  QianbaoIM
//
//  Created by liunian on 14/8/27.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMGrowingTextView.h"
#import "NIMRKeyboardInputView.h"

#define kHeightKeyboard         kHeightContainer + kHeightBoardHeader
#define kHeightBoardHeader      50



#define kHeightContainer        216
typedef NS_ENUM(NSInteger, ChatKeyBoardSelectedType) {
    ChatKeyBoardSelectedTypeNone      = 0,
    ChatKeyBoardSelectedTypeKeyboard  = 1,
    ChatKeyBoardSelectedTypeVoice     = 2,
    ChatKeyBoardSelectedTypeFace      = 3,
    ChatKeyBoardSelectedTypeOption    = 4,
    ChatKeyBoardSelectedTypeOthers    = 5,
};

@protocol ChatKeyboardDelegate;

@interface NIMRChatKeyboardView : UIView

@property (nonatomic, assign) id<ChatKeyboardDelegate>          delegate;
@property (nonatomic, assign, readonly)ChatKeyBoardSelectedType keboardSelectedType;
@property (nonatomic, strong) NIMGrowingTextView                 *textView;
@property (nonatomic, assign) BOOL                              isOtherKeyboard;
@property (nonatomic, assign) BOOL                              isPersional;

-(void)makeConstraints;
- (void)resetDefault;
- (void)showTextKeyboard:(ChatKeyBoardSelectedType)type;
@end

@protocol ChatKeyboardDelegate <NSObject>
@required
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didSelectedAction:(ChatKeyBoardSelectedType)actionType;
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didOptionSelectedAction:(ChatKeyBoardOptionActionType)actionType;
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didChangedHeight:(CGFloat)height;
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didSendText:(NSString *)text;
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didSendSmiley:(NSString *)text;
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didShowError:(NSString *)text;
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView willBeginRecordingAtFilePath:(NSString *)filePath;
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didCancelRecordAtFilePath:(NSString *)filePath;
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didFinishRecordAtFilePath:(NSString *)filePath;
-(void)showPublicBottomView;
@end



