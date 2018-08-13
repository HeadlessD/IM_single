//
//  NIMRKeyboardInputView.m
//  QianbaoIM
//
//  Created by liunian on 14/9/10.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRKeyboardInputView.h"
#import "NIMRichPad.h"

@interface NIMRKeyboardInputView ()<RichPadDelegate, ChatMediaViewDelegate>
@property (nonatomic, strong) NIMRichPad *richPad;
@end

@implementation NIMRKeyboardInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setUpInit];
}

- (void)setUpInit {
    //CGRect bounds = [UIScreen mainScreen].bounds;
//    CGRect frame = CGRectMake(0, 0,  CGRectGetWidth(bounds), 216);
//    [self richPad];
    [self chatMediaPad];
}

- (void)updateWithKeyBoardInputType:(ChatKeyBoardInputType)keyBoardInputType{
    switch (keyBoardInputType) {
        case ChatKeyBoardInputTypeNone:
        {
            
        }
            break;
        case ChatKeyBoardInputTypeKeyboard:
        {
            self.richPad.hidden = NO;
            self.chatMediaPad.hidden = YES;
        }
            break;
        case ChatKeyBoardInputTypeFace:
        {
            self.richPad.hidden = NO;
            self.chatMediaPad.hidden = YES;
        }
            break;
        case ChatKeyBoardInputTypeOption:
        {
            self.richPad.hidden = YES;
            self.chatMediaPad.hidden = NO;
        }
            break;
        case ChatKeyBoardInputTypeOthers:
        {
            self.richPad.hidden = NO;
            self.chatMediaPad.hidden = YES;
        }
            break;

        default:
            break;
    }
}

#pragma mark 
#pragma mark RichPadDelegate
- (void)bigEmojiSelected:(WUEmoticonsKeyboardKeyItem *)item{

    [_delegate keyboardInputView:self didSelectedbigEmojiFaceItem:item];
}
- (void)emojiSelected:(WUEmoticonsKeyboardKeyItem *)item{
    NSString *text = item.textToInput;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([text length] > 0 ) {
        [_delegate keyboardInputView:self didSelectedEmojiFace:text];
    }
}

- (void)deleteEmjoi{
    [_delegate deleteEmjoiKeyboardInputView:self];
}

- (void)richSendAction{
    [_delegate sendKeyboardInputView:self];
}
#pragma mark ChatMediaViewDelegate
- (void)ChatMediaView:(NIMChatMediaView *)chatView buttonBeenClicked:(ChatMediaType)type{
    ChatKeyBoardOptionActionType actionType = ChatKeyBoardOptionActionTypeNone;
    switch (type) {
        case ChatMediaTypeCamera:
        {
            actionType = ChatKeyBoardOptionActionTypeCamera;
        }
            break;
        case ChatMediaTypeImage:
        {
             actionType = ChatKeyBoardOptionActionTypePhoto;
        }
            break;
            
        case ChatMediaTypeExpression:
        {
        }
            break;
        case ChatMediaTypeLocation:
        {
             actionType = ChatKeyBoardOptionActionTypeLocation;
        }
            break;
        case ChatMediaTypeVCard:
        {
            actionType = ChatKeyBoardOptionActionTypeCard;
        }
            break;
        case ChatMediaTypeFavorites:
        {
            actionType = ChatKeyBoardOptionActionTypeFavor;
        }
            break;
        case ChatMediaTypeRedMoney:
        {
            actionType = ChatKeyBoardOptionActionTypeRedMoney;
        }
            break;
        case ChatMediaTypeOrder:
        {
            actionType = ChatKeyBoardOptionActionTypeOrder;
        }
            break;
        case ChatMediaTypeVideo:
        {
            actionType = ChatKeyBoardOptionActionTypeVideo;
        }
            break;
        default:
            break;
    }
    [_delegate keyboardInputView:self didSelectedKeyBoardOptionActionType:actionType];
}

#pragma mark setter
- (void)setKeyBoardInputType:(ChatKeyBoardInputType)keyBoardInputType{
    if (_keyBoardInputType != keyBoardInputType) {
        _keyBoardInputType = keyBoardInputType;
    }
    [self updateWithKeyBoardInputType:keyBoardInputType];
}
#pragma mark getter
- (NIMRichPad *)richPad
{
    if(!_richPad)
    {
        _richPad                = [[NIMRichPad alloc] init];
        _richPad.canUseBigFace = YES;
        _richPad.frame          = CGRectMake(0, 0, CGRectGetWidth(self.frame), kChatMediaViewH);
        
        _richPad.delegate       = self;
        _richPad.hidden         = NO;
        [self addSubview:_richPad];
    }
    return _richPad;
}

-(NIMChatMediaView *)chatMediaPad{
    if (!_chatMediaPad) {
        _chatMediaPad = [[NIMChatMediaView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), kChatMediaViewH)];
        _chatMediaPad.delegate  = self;
        _chatMediaPad.isSubView = NO;
        _chatMediaPad.hidden    = NO;
        _chatMediaPad.backgroundColor = [SSIMSpUtil getColor:@"f1f1f1"];
        [self addSubview:self.chatMediaPad];
    }
    return _chatMediaPad;
}
@end
