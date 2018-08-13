//
//  NIMRChatTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MLEmojiLabel.h"
#import "ChatEntity+CoreDataProperties.h"
#define kMarginTipText  70
#define kMarginText  150
#define kMaxWidthContent CGRectGetWidth([UIScreen mainScreen].bounds) - kMarginText

#define kMarginPaoPaoWidth (kMaxWidthContent + 50) //供商品 任务 订单使用

#define makeMenuItem(theTitle,theAction) \
[[UIMenuItem alloc] initWithTitle:theTitle action:theAction]
#define kCopyAll        @"复制"
#define kFwd            @"转发"
#define kFwdBySMS       @"短信转发"
#define kDetails        @"详情"
#define kUseReceiver    @"听筒播放"
#define kUseSpeaker     @"扬声器播放"
#define kDelete         @"删除"

#define kMenuItemCopy               makeMenuItem(kCopyAll,@selector(actionCopy:))
#define kMenuItemForward            makeMenuItem(kFwd,@selector(actionForward:))
#define kMenuItemForwardBySMS       makeMenuItem(kFwdBySMS,@selector(actionForwardBySMS:))
#define kMenuItemShowDetails        makeMenuItem(kDetails,@selector(showDetails:))
#define kMenuItemReceiver           makeMenuItem(kUseReceiver,@selector(actionVoice:))
#define kMenuItemSpeaker            makeMenuItem(kUseSpeaker,@selector(actionVoice:))
#define kMenuItemDelete             makeMenuItem(kDelete,@selector(actionDelete:))

#define kHeightMarginTopName    2
#define kHeightTimeline         30
#define kHeightName             15
#define kWithMarginAvatarToPao  10
#define kHeightMarginBotton     11
#define kHeightMarginTop        11
#define kWidthMarginAvatar      10

#define kDefaultWidth 75

#define kIntervalTime       5*60*1000
#define kTipColor           [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.4 ]


typedef NS_ENUM(NSInteger, ChatMenuActionType){
    ChatMenuActionTypeNone      = 0,
    ChatMenuActionTypeAvatar    = 1,
    ChatMenuActionTypeCopy      = 2,
    ChatMenuActionTypeForward   = 3,
    ChatMenuActionTypeVoice     = 4,

};

@protocol ChatTableViewCellDelegate;
@interface NIMRChatTableViewCell : UITableViewCell{
   __unsafe_unretained id<ChatTableViewCellDelegate>_delegate;
    NSArray     *_menuItems;
    UIImage     *_image;
    UIImage     *_highlightedImage;
}
@property (nonatomic, strong) ChatEntity *recordEntity;
@property (nonatomic, strong) ChatEntity *preRecordEntity;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) id<ChatTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, assign) BOOL  showName;
@property (nonatomic, assign) BOOL  showTimeline;
@property (nonatomic, assign, getter=isEnableClick) BOOL enableClick;
@property (nonatomic , assign) BOOL isNoLongPress;
@property (nonatomic) BOOL isBuyer;

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity;
- (void)updateWithRecordEntity:(ChatEntity *)recordEntity previousRecordEntity:(ChatEntity *)preRecordEntity;
#pragma mark public
- (void)actionCopy:(id)sender;
- (void)actionForward:(id)sender;
- (void)actionVoice:(id)sender;
#pragma mark Menu Notification
- (void)menuControllerDidHideMenuNotification:(NSNotification *)notification;

+ (NSMutableAttributedString *)stringWithString:(NSString *)astring;
+ (CGRect)rectWithPlainTextWithTextEntity:(TextEntity *)textEntity;
+ (CGFloat)heightWithNRecordEntity:(ChatEntity *)recordEntity previousRecordEntity:(ChatEntity *)preRecordEntity;
@end

@protocol ChatTableViewCellDelegate <NSObject>

@optional
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectedWithRecordEntity:(ChatEntity *)recordEntity;
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectedWithRecordEntity:(ChatEntity *)recordEntity atIndex:(NSInteger)index;

- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSendProductWithRecordEntity:(ChatEntity *)recordEntity;
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSendBGProductWithRecordEntity:(ChatEntity *)recordEntity;
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSendOrderWithRecordEntity:(ChatEntity *)recordEntity;
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectedWithRecordEntity:(ChatEntity *)recordEntity action:(ChatMenuActionType )actionType;
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell infoButtonDidSelectedWithRecordEntity:(ChatEntity *)recordEntity;
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectStr:(NSString*)str withType:(MLEmojiLabelLinkType)type;
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectUser:(int64_t)userid;

@end
