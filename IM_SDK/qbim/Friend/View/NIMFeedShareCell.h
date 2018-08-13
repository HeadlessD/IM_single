//
//  NIMFeedShareCell.h
//  QianbaoIM
//
//  Created by Yun on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMFeedBaseCell.h"

#define kNIMFeedShareCell @"NIMFeedShareCell"

@interface NIMFeedShareCell : NIMFeedBaseCell
@property (nonatomic, strong) UIButton* btnShareBg;
@property (nonatomic, strong) UILabel* labShareTitle;
@property (nonatomic, strong) UILabel* labShareContent;
@property (nonatomic, strong) UIView* shareView;
@property (nonatomic, strong) UIImageView* flageView; 
@property (nonatomic, strong) UIImageView* shareHtmlImageView;

//- (void)setShareViewDataSource:(FeedEntity*)feedEntity;
- (void)setAutoLayout;
@end
