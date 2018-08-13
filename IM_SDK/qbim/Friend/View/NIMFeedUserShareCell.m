//
//  NIMFeedUserShareCell.m
//  QianbaoIM
//
//  Created by Yun on 14/10/9.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMFeedUserShareCell.h"
//#import "FeedEntity.h"
@implementation NIMFeedUserShareCell

//+ (CGFloat)getCellHeight:(FeedEntity *)feedEntity andShowFlag:(BOOL)isShow
//{
//    CGFloat ori = [NIMFeedDetailShareCell getCellHeight:feedEntity andShowFlag:isShow];
//    return ori -25;
//}
//
//- (void)setCellDataSource:(FeedEntity*)feedEntity
//{
//    [super setCellDataSource:feedEntity];
//    self.cellFeedEntity = feedEntity;
//    //    if(!self.firstLoad)
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
//    [self setShareViewDataSource:feedEntity];
//    [self setImagesValue:feedEntity];
//    [self setBottomValue:feedEntity];
//}
//
//#pragma mark setHeaderValue
//- (void)setHeaderValue:(FeedEntity*)feedEntity
//{
//    self.labTime.text = [NSString stringWithFormat:@"%@",[SSIMSpUtil parseTime:feedEntity.ct]];
//    NSString* text = feedEntity.textEntity.text;
//    if(feedEntity.topicEntity)
//    {
//        if(text)
//        {
//            text = [NSString stringWithFormat:@"%@ %@",feedEntity.topicEntity.name,text];
//        }
//        else
//        {
//            text = [NSString stringWithFormat:@"%@",feedEntity.topicEntity.name];
//        }
//    }
//    self.labText.text = text;
//    CGSize size = [self.labText preferredSizeWithMaxWidth:kWidthText];
//    if(self.hiddenShowMore){
//        self.labText.numberOfLines = 0;
//        self.btnShowMore.hidden = YES;
//    }
//    else{
//        if(size.height>=kTextMaxHeight && !self.isShowMoreInfo){
//            self.labText.numberOfLines = 6;
//            [self.btnShowMore setTitle:@"全文" forState:UIControlStateNormal];
//        }
//        else{
//            self.labText.numberOfLines = 0;
//            [self.btnShowMore setTitle:@"收起" forState:UIControlStateNormal];
//        }
//        if(size.height<kTextMaxHeight){
//            self.btnShowMore.hidden = YES;
//        }
//        else{
//            self.btnShowMore.hidden = NO;
//        }
//    }
//}
//
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
//    [self.vImages mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vHeader.mas_bottom).with.offset(5);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.bottom.equalTo(self.shareView.mas_top);
//        make.height.with.offset(textHeight);
//    }];
//
//    [self.shareView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.bottom.equalTo(self.vBottom.mas_top).with.offset(-15);
//        make.height.with.offset(70);
//    }];
//
//    [self.vBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.height.with.offset(kBottomHeight);
//    }];
//}
//
//
//- (void)setHeaderViewLayout//设置上部view layout
//{
//    [self.topImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vHeader.mas_top);
//        make.leading.equalTo(self.vHeader.mas_leading);
//        make.trailing.equalTo(self.vHeader.mas_trailing);
//        make.height.with.offset(kHeaderGrayHeight);
//    }];
//
//    [self.labTime mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.vHeader.mas_leading).with.offset(10);
//        make.top.equalTo(self.topImageView.mas_bottom).with.offset(3);
//        make.trailing.equalTo(self.btnMore.mas_leading);
//        make.height.with.offset(25);
//    }];
//    [self.labText mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.vHeader.mas_leading).with.offset(10);
//        make.top.equalTo(self.labTime.mas_bottom);
//        make.trailing.equalTo(self.vHeader.mas_trailing).with.offset(-10);
//        make.height.greaterThanOrEqualTo(@0);
//        make.bottom.equalTo(self.vHeader.mas_bottom).with.offset(-5);
//    }];
//    [self.btnMore mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.vHeader.mas_trailing).with.offset(-5);
//        make.top.equalTo(self.vHeader.mas_top).with.offset(8);
//        make.width.with.offset(40);
//        make.height.with.offset(40);
//    }];
//    [self.btnShowMore mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.vHeader.mas_leading);
//        make.bottom.equalTo(self.vHeader.mas_bottom);
//        make.width.with.offset(60);
//        make.height.with.offset(30);
//    }];
//}


@end
