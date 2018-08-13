//
//  NIMFeedTableViewCell.h
//  QianbaoIM
//
//  Created by iln on 14/8/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FeedEntity.h"

#define kWidthText [UIApplication sharedApplication].keyWindow.bounds.size.width-16
#define kHeightReserved 115
#define kHeightReservedComment 90

typedef NS_ENUM(NSInteger, NIMFeedCellActionType) {
    NIMFeedCellActionTypeTypeNone          = 0,
    NIMFeedCellActionTypeTypeName          = 1,
    NIMFeedCellActionTypeTypeAvatar        = 2,
    NIMFeedCellActionTypeTypeOption        = 3,
    NIMFeedCellActionTypeTypeImage         = 4,
    NIMFeedCellActionTypeTypeComment       = 5,
    NIMFeedCellActionTypeTypePraise        = 6,
    NIMFeedCellActionTypeTypeTextClick     = 7,
    NIMFeedCellActionTypeTypeReport        = 8,
    NIMFeedCellActionTypeTypeDelete        = 9,
};

@class NIMFeedTableViewCell;
@protocol FeedTableViewCellDelegate <NSObject>

@required
//- (void)NIMFeedCell:(NIMFeedTableViewCell *)cell actionDidWithFeedEntity:(FeedEntity *)feedEntity actionType:(NIMFeedCellActionType)actionType object:(id)object;

-(void)pushClickTargetNameWithID:(double)targetId;

@end

@interface NIMFeedTableViewCell : UITableViewCell
{
    __weak id<FeedTableViewCellDelegate> _delegate;
}
@property (weak, nonatomic) id<FeedTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIButton     *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton   *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel     *timeLabel;
@property (weak, nonatomic) IBOutlet UIView     *cellContentView;
//@property (strong, nonatomic) FeedEntity *feedEntity;
//@property (strong, nonatomic) Comment *commentEntity;
//
//
//- (void)updateWithFeedEntity:(FeedEntity *)feedEntity;
//- (void)updateWithCommentEntity:(Comment *)commentEntity;
//+ (NSMutableAttributedString *)stringWithString:(NSString *)astring;
//
//+ (CGFloat)heightWithFeedEntity:(FeedEntity *)feedEntity;
//+ (CGFloat)heightWithCommentEntity:(Comment *)commentEntity;
//
//+ (CGFloat)heightWithPlainTextWithTextEntity:(FeedEntity *)textEntity;
//+ (CGFloat)heightWithContainerWithImageEntitys:(NSSet *)imageEntitys;
//
//+ (CGFloat)heightWithPlainText:(NSString *)text targetRange:(NSRange)range;
@end
