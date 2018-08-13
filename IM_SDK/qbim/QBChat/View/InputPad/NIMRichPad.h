//
//  NIMRichPad.h
//  QianbaoIM
//
//  Created by liyan on 14-3-31.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUEmoticonsKeyboardKeyItem.h"
@protocol RichPadDelegate <NSObject>
@optional

- (void)bigEmojiSelected:(WUEmoticonsKeyboardKeyItem *)item;

@required
- (void)emojiSelected:(WUEmoticonsKeyboardKeyItem *)item;

- (void)deleteEmjoi;
- (void)richSendAction;

@end

@interface NIMRichPad : UIView
@property (nonatomic, assign)BOOL canUseBigFace; //默认不支持
@property (nonatomic, assign)id<RichPadDelegate>delegate;
@end
