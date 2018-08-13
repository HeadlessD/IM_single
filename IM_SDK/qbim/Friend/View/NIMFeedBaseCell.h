//
//  NIMFeedBaseCell.h
//  QianbaoIM
//
//  Created by Yun on 14/9/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMTextAttachment.h"
#import "NIMMatchParser.h"
//#import "FeedEntity.h"
//#import "ImageEntity.h"
//#import "TextEntity.h"
//#import "ImageFeedEntity.h"
//#import "TopicEntity.h"
  
//#import <Masonry.h>
#import "NIMPhotoVC.h"
#import "MLEmojiLabel.h"
  

#define kWidthText [UIApplication sharedApplication].keyWindow.bounds.size.width-20
#define KAppWidth [UIApplication sharedApplication].keyWindow.bounds.size.width
#define kHeightReserved 115
#define kHeightReservedComment 90
#define kBottomHeight 38
#define kHeaderGrayHeight 14

#define kTextMaxHeight 140

@class NIMFeedBaseCell;
@protocol NIMFeedBaseCellDelegate <NSObject>
@optional
//- (void)NIMFeedCellPraiseAction:(FeedEntity*)feedEntity;
//- (void)feedMessageAction:(FeedEntity*)feedEntity cell:(NIMFeedBaseCell*)cell;
//- (void)feedMoreAction:(FeedEntity*)feedEntity;
//- (void)feedUserClick:(FeedEntity*)feedEntity;
//- (void)feedShareClick:(FeedEntity*)feedEntity;
//- (void)showOrHiddenMoreTextInfo:(FeedEntity*)feedEntity adIndex:(NIMFeedBaseCell*)cell;
//- (void)emojiLabelClick:(FeedEntity*)feedEntity clickStr:(NSString*)str withType:(MLEmojiLabelLinkType)type;

- (void)feedImageDidClick;
@end

@interface NIMFeedBaseCell : UITableViewCell<MLEmojiLabelDelegate>
//@property (nonatomic, strong) FeedEntity* cellFeedEntity;

@property (nonatomic, assign) BOOL firstLoad;

@property (nonatomic, strong) UIView* vHeader;
@property (nonatomic, strong) UIView* vImages;
@property (nonatomic, strong) UIView* vBottom;

////header
@property (nonatomic, strong) UIImageView* topImageView;//顶部背景
@property (nonatomic, strong) UIImageView* userIcon;//用户图像
@property (nonatomic, strong) UILabel* labUseName;//用户名
@property (nonatomic, strong) UILabel* labTime;//地点时间
//@property (nonatomic, strong) UILabel* labText;//内容
@property (nonatomic) BOOL isShowMoreInfo;//点击全文，隐藏全文
@property (nonatomic) BOOL hiddenShowMore;//全部展示，不显示全文，隐藏按钮，yes直接显示全文，no可以切换显示
@property (nonatomic, strong) UIButton* btnShowMore;
@property (nonatomic, strong) MLEmojiLabel* labText;//内容
@property (nonatomic, strong) UIButton* btnMore;//右上更多按钮
////header end

////images
@property (nonatomic, strong) UIImageView* img1;
@property (nonatomic, strong) UIImageView* img2;
@property (nonatomic, strong) UIImageView* img3;
@property (nonatomic, strong) UIImageView* img4;
@property (nonatomic, strong) UIImageView* img5;
@property (nonatomic, strong) UIImageView* img6;
@property (nonatomic, strong) UIImageView* img7;
@property (nonatomic, strong) UIImageView* img8;
@property (nonatomic, strong) UIImageView* img9;
////images end

////bottom
@property (nonatomic, strong) UIImageView* topLine;//下部view顶部灰色线
@property (nonatomic, strong) UIImageView* centerLine;//中部灰色线
@property (nonatomic, strong) UIButton* btnMessage;//评论按钮
@property (nonatomic, strong) UIButton* btnPraise;//赞按钮
////bottom end

@property (nonatomic,assign) id<NIMFeedBaseCellDelegate>delegate;

//+ (CGFloat)getImageViewHeight:(FeedEntity*)feedEntity;
//
//+ (NSMutableAttributedString *)stringWithString:(NSString *)astring;
//
//+ (CGFloat)getCellHeight:(FeedEntity*)feedEntity andShowFlag:(BOOL)isShow;
//
//- (void)setCellDataSource:(FeedEntity*)feedEntity;
//
//- (void)setBottomViewLayout;
//- (void)setImagesViewLayout:(NSInteger)count;
//- (void)setHeaderViewLayout;
//- (void)setBaseViewLayout:(FeedEntity*)feedEntity;
//
//- (void)setHeaderValue:(FeedEntity*)feedEntity;
//- (void)setImagesValue:(FeedEntity*)feedEntity;
//- (void)setBottomValue:(FeedEntity*)feedEntity;
@end
