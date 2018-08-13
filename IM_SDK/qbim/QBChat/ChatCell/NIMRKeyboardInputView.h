//
//  NIMRKeyboardInputView.h
//  QianbaoIM
//
//  Created by liunian on 14/9/10.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMChatMediaView.h"


typedef NS_ENUM(NSInteger, ChatKeyBoardOptionActionType) {
    ChatKeyBoardOptionActionTypeNone        = 0,
    ChatKeyBoardOptionActionTypeCamera      = 1,
    ChatKeyBoardOptionActionTypePhoto       = 2,
    ChatKeyBoardOptionActionTypeLocation    = 3,
    ChatKeyBoardOptionActionTypeCard        = 4,
    ChatKeyBoardOptionActionTypeRedMoney    = 5,
    ChatKeyBoardOptionActionTypeFavor       = 6,
    ChatKeyBoardOptionActionTypeOrder       = 7,
    ChatKeyBoardOptionActionTypeVideo       = 8,


};

typedef NS_ENUM(NSInteger, ChatKeyBoardFaceType) {
    ChatKeyBoardFaceTypeNone        = 0,
    ChatKeyBoardFaceTypeFace        = 1,
    ChatKeyBoardFaceTypeSmiley      = 2,
};

typedef NS_ENUM(NSInteger, ChatKeyBoardInputType) {
    ChatKeyBoardInputTypeNone        = 0,
    ChatKeyBoardInputTypeKeyboard    = 1,
    ChatKeyBoardInputTypeFace        = 2,
    ChatKeyBoardInputTypeOption      = 3,
    ChatKeyBoardInputTypeOthers      = 4,
};

@protocol QBRKeyboardInputDelegate;
@interface NIMRKeyboardInputView : UIView
@property (strong, nonatomic) NIMChatMediaView            *chatMediaPad;
@property (nonatomic, weak) id<QBRKeyboardInputDelegate>delegate;
@property (nonatomic, assign) ChatKeyBoardInputType  keyBoardInputType;
@property (nonatomic, assign) ChatKeyBoardFaceType  keyBoardFaceType;
@end

@class WUEmoticonsKeyboardKeyItem;
@protocol QBRKeyboardInputDelegate <NSObject>

@required
- (void)deleteEmjoiKeyboardInputView:(NIMRKeyboardInputView *)inputView;
- (void)sendKeyboardInputView:(NIMRKeyboardInputView *)inputView;
- (void)keyboardInputView:(NIMRKeyboardInputView *)inputView didSelectedbigEmojiFaceItem:(WUEmoticonsKeyboardKeyItem *)item;
- (void)keyboardInputView:(NIMRKeyboardInputView *)inputView didSelectedEmojiFace:(NSString *)faceString;
- (void)keyboardInputView:(NIMRKeyboardInputView *)inputView didSelectedKeyBoardOptionActionType:(ChatKeyBoardOptionActionType)actionType;
@end
