//
//  NIMFeedDetailShareCell.m
//  QianbaoIM
//
//  Created by Yun on 14/10/9.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMFeedDetailShareCell.h"

@implementation NIMFeedDetailShareCell

//+ (CGFloat)getCellHeight:(FeedEntity *)feedEntity andShowFlag:(BOOL)isShow{
//    CGFloat ori = [NIMFeedShareCell getCellHeight:feedEntity andShowFlag:YES];
//    return ori - kBottomHeight;
//}
//
//- (void)setCellDataSource:(FeedEntity*)feedEntity
//{
//    [super setCellDataSource:feedEntity];
//    
//    if(!self.firstLoad)
//    {
//        [self setHeaderViewLayout];
//        [self setBottomViewLayout];
//        self.firstLoad = YES;
//    }
//    [self setBaseViewLayout:feedEntity];
//    [self setImagesViewLayout:feedEntity.imageEntity.count];
//    [self setAutoLayout];
//    
//    [self setHeaderValue:feedEntity];
//    [self setImagesValue:feedEntity];
//    [self setShareViewDataSource:feedEntity];
//    self.topImageView.image = IMGGET(@"bg_square_hui01");
//}
//
//#pragma mark layout seter
//- (void)setBaseViewLayout:(FeedEntity*)feedEntity//布局3个基础view layout
//{
//    CGFloat textHeight = [NIMFeedBaseCell getImageViewHeight:feedEntity];
//    
//    [self.vHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.bottom.equalTo(self.vImages.mas_top);
//    }];
//    
//    [self.shareView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vImages.mas_bottom).with.offset(10);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.height.with.offset(70);
//    }];
//    
//    [self.vImages mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vHeader.mas_bottom);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.bottom.equalTo(self.shareView.mas_top);
//        make.height.with.offset(textHeight);
//    }];
//    
//    self.vBottom.hidden = YES;
//}


@end
