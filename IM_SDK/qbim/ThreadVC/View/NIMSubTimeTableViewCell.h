//
//  NIMSubTimeTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSubtitleTableViewCell.h"
#import "ChatListEntity+CoreDataProperties.h"


#define kSubTimeReuseIdentifier @"kSubTimeReuseIdentifier"

@interface NIMSubTimeTableViewCell : NIMSubtitleTableViewCell
@property (nonatomic, strong) UILabel   *timeLablel;
@property (nonatomic, strong) UIImageView * badgeView;
@property (nonatomic, strong) UILabel* badgeLabel;
@property (nonatomic, strong) UIImageView    *noticeImgView;

@property (nonatomic, assign) BOOL isBlue;

//当消息为nil时，只显示logo和群通知
- (void)updateWithGroupNotifyMsg:(NSString *)msg withTimestamp:(NSTimeInterval)timestamp;

- (void)updateWithRecordList:(ChatListEntity *)chatListEntity isRedAnimating:(BOOL)isRedAnimating;

- (void)disAppearRedPointWtihCompletion:(void (^ __nullable)(BOOL finished))completion;;
@end
