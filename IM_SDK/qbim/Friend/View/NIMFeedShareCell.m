//
//  NIMFeedShareCell.m
//  QianbaoIM
//
//  Created by Yun on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMFeedShareCell.h"
//#import "HtmlFeedEntity.h"
//#import "TaskFeedEntity.h"
//#import "GoodsFeedEntity.h"
//#import "GamesEntity.h"
//#import "SSIMSpUtil.h"
#import "NSAttributedString+Attributes.h"
//#import "GiftEntitly.h"
//#import "FeedEntity.h"

@implementation NIMFeedShareCell

//+ (CGFloat)getCellHeight:(FeedEntity*)feedEntity andShowFlag:(BOOL)isShow
//{
//    CGFloat textHeight = [super getCellHeight:feedEntity andShowFlag:isShow];
//    textHeight+=75;//加上下面分享的view高度
//    return textHeight;
//}

//- (void)setCellDataSource:(FeedEntity*)feedEntity
//{
////    [super setCellDataSource:feedEntity];
//
//    //if(self.firstLoad)
//    {
////        [self setHeaderViewLayout];
////        [self setBottomViewLayout];
//        self.firstLoad = YES;
//    }
//    [self setImagesViewLayout:feedEntity.imageEntity.count];
//    [self setBaseViewLayout:feedEntity];
//    [self setAutoLayout];
//
//    [self setHeaderValue:feedEntity];
//    [self setShareViewDataSource:feedEntity];
//    [self setImagesValue:feedEntity];
//    [self setBottomValue:feedEntity];
//}

-(void)reloadAutoLayout{
    
    [self.shareHtmlImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareView.mas_leading).with.offset(10);
        make.top.equalTo(self.btnShareBg.mas_top);
        make.height.with.offset(55);
        make.width.with.offset(55);
    }];
    
    [self.labShareTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareHtmlImageView.mas_leading).with.offset(70);
        make.trailing.equalTo(self.btnShareBg.mas_trailing).with.offset(-32);
        make.top.equalTo(self.btnShareBg.mas_top).with.offset(2);
        make.height.with.offset(50);
    }];
    [self.flageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.shareView.mas_trailing).with.offset(-15);
        make.bottom.equalTo(self.labShareTitle.mas_bottom).with.offset(2);
        make.height.with.offset(14);
        make.width.with.offset(28);
    }];
}

//- (void)setShareViewDataSource:(FeedEntity*)feedEntity{
//    self.labShareContent.hidden = NO;
//    self.shareHtmlImageView.hidden = YES;
//    IMFeedSubType type = feedEntity.feedSubType;
//    switch (type) {
//        case IMFeedSubTypeHtml:
//        {
//            self.labShareContent.hidden = YES;
//            self.shareHtmlImageView.hidden = NO;
//            HtmlFeedEntity* htmlEntity = feedEntity.htmlEntity;
//            self.labShareTitle.text = htmlEntity.title;
//            self.labShareContent.text = htmlEntity.desc;
//            self.flageView.image = IMGGET(@"net");
//            //[self.shareHtmlImageView sd_setImageWithString:htmlEntity.img_url placeholderImage:IMGGET(@"icon_link")];
//            [self reloadAutoLayout];
//        }
//            break;
//        case IMFeedSubTypeTask:
//        {
//             self.shareHtmlImageView.hidden = NO;
//            TaskFeedEntity* task = feedEntity.taskEntity;
//            //[self.shareHtmlImageView sd_setImageWithString:task.img_url placeholderImage:IMGGET(@"icon_link")];
//            self.labShareTitle.text = task.task_name;
//            if (task.bqReward.integerValue==0) {
//            self.labShareContent.text = [NSString stringWithFormat:@"%@元收益",[SSIMSpUtil toThousand:task.reward]];
//            }
//           else
//           {
//            self.labShareContent.text = [NSString stringWithFormat:@"%@元收益   %@宝券收益",[SSIMSpUtil toThousand:task.reward],[SSIMSpUtil toThousand:task.bqReward]];
//           }
//            self.flageView.image = IMGGET(@"icon_news_task");
//            [self setGoodAutoLayout];
//        }
//            break;
//        case IMFeedSubTypeGoods:
//        {
//             self.shareHtmlImageView.hidden = NO;
//            GoodsFeedEntity* goods = feedEntity.goodsEntity;
//
//            self.labShareTitle.text = goods.title;
//
//             //[self.shareHtmlImageView sd_setImageWithString:_IM_FormatStr(@"%@/60",goods.icon) placeholderImage:IMGGET(@"icon_link")];
//            if(goods.price&&goods.price.doubleValue!=0)
//            {
//                NSString *price = _IM_FormatStr(@"%.0f",goods.price.doubleValue * 100);
////                price = [SSIMSpUtil toThousand:price];
////                price = [SSIMSpUtil removePoint:price];
//                price = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(price.doubleValue)/100]];;
//
//
//
//                NSString *str = _IM_FormatStr(@""__QB_UNIT__"%@" , price);
//                NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
//                [attrStr setTextColor:__COLOR_262626__];
//                [attrStr setFont:FONT_TITLE(12) range:[str rangeOfString:@__QB_UNIT__]];
//                [attrStr setFont:FONT_TITLE(14.0) range:[str rangeOfString:price]];
//                self.labShareContent.attributedText = attrStr;
//                [self setGoodAutoLayout];
//            }
//            else{
//                self.labShareContent.text = @"面议";
//            }
//            self.flageView.image = IMGGET(@"icon_news_shop");
//        }
//            break;
//        case IMFeedSubTypeGames:
//        {
//            GamesEntity* games = feedEntity.gamesEntity;
//            self.labShareTitle.text = games.app_name;
//            self.labShareContent.text = games.desc;
//            if([games.app_type isEqualToString:@"1"])
//            {
//            self.flageView.image = IMGGET(@"icon_software");
//            }
//            else
//            {
//             self.flageView.image = IMGGET(@"icon_game");
//
//            }
//        }
//            break;
//            case IMFeedSubTypeGift:
//        {
//            GiftEntitly* gift = feedEntity.giftEntity;
//            self.labShareTitle.text = gift.title;
//            self.labShareContent.text = gift.shareDesc;
//             self.flageView.image = IMGGET(@"icon_libao");
//
//        }
//            break;
//        default:
//            break;
//    }
//}
-(void)setGoodAutoLayout
{
    [self.shareHtmlImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareView.mas_leading).with.offset(10);
        make.top.equalTo(self.btnShareBg.mas_top);
        make.height.with.offset(55);
        make.width.with.offset(55);
    }];
    [self.btnShareBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareView.mas_leading).with.offset(10);
        make.top.equalTo(self.shareView.mas_top).with.offset(0);
        make.bottom.equalTo(self.shareView.mas_bottom).with.offset(-5);
        make.trailing.equalTo(self.shareView.mas_trailing).with.offset(-10);
    }];
    
    [self.labShareTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareHtmlImageView.mas_leading).with.offset(70);
        make.trailing.equalTo(self.btnShareBg.mas_trailing).with.offset(-32);
        make.top.equalTo(self.btnShareBg.mas_top).with.offset(2);
        make.height.with.offset(30);
    }];
    
    [self.labShareContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareHtmlImageView.mas_leading).with.offset(70);
        make.trailing.equalTo(self.btnShareBg.mas_trailing).with.offset(-30);
        make.top.equalTo(self.labShareTitle.mas_bottom).with.offset(-3);
        make.height.with.offset(15);
    }];

    [self.flageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.shareView.mas_trailing).with.offset(-15);
        make.bottom.equalTo(self.labShareContent.mas_bottom).with.offset(0);
        make.height.with.offset(14);
        make.width.with.offset(28);

    }];

}
#pragma mark setAutoLayout
//- (void)setBaseViewLayout:(FeedEntity*)feedEntity//多出一个分享view
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
//        make.top.equalTo(self.vHeader.mas_bottom);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.bottom.equalTo(self.shareView.mas_top);
//        make.height.with.offset(textHeight);
//    }];
//
//    [self.shareView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vImages.mas_bottom).with.offset(15);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.bottom.equalTo(self.vBottom.mas_top).with.offset(-10);
//
//        make.height.with.offset(60);
//    }];
//
//    [self.vBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.height.with.offset(kBottomHeight);
//    }];
//}


- (void)setAutoLayout
{
    [self.btnShareBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareView.mas_leading).with.offset(10);
        make.top.equalTo(self.shareView.mas_top).with.offset(0);
        make.bottom.equalTo(self.shareView.mas_bottom).with.offset(-5);
        make.trailing.equalTo(self.shareView.mas_trailing).with.offset(-10);
    }];
    
    [self.labShareTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareView.mas_leading).with.offset(15);
        make.trailing.equalTo(self.btnShareBg.mas_trailing).with.offset(-8);
        make.top.equalTo(self.btnShareBg.mas_top).with.offset(2);
        make.height.with.offset(30);
    }];
    
    [self.labShareContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shareView.mas_leading).with.offset(15);
        make.trailing.equalTo(self.btnShareBg.mas_trailing).with.offset(-30);
        make.top.equalTo(self.labShareTitle.mas_bottom).with.offset(-3);
        make.height.with.offset(15);
    }];
    
    [self.flageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.shareView.mas_trailing).with.offset(-15);
        make.bottom.equalTo(self.labShareContent.mas_bottom).with.offset(0);
        make.height.with.offset(14);
        make.width.with.offset(28);
    }];
}

#pragma mark getter
- (UIButton*)btnShareBg
{
    if(!_btnShareBg)
    {
        _btnShareBg = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btnShareBg setBackgroundImage:[IMGGET(@"bg_square_hui") stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_btnShareBg setBackgroundImage:[IMGGET(@"bg_task_cell_hightlight") stretchableImageWithLeftCapWidth:10 topCapHeight:10]forState:UIControlStateHighlighted];
        [_btnShareBg setBackgroundImage:[IMGGET(@"bg_task_cell_hightlight") stretchableImageWithLeftCapWidth:10 topCapHeight:10]forState:UIControlStateSelected];
        [_btnShareBg addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:_btnShareBg];
    }
    return _btnShareBg;
}

- (UILabel*)labShareTitle
{
    if(!_labShareTitle)
    {
        _labShareTitle = [[UILabel alloc] init];
        _labShareTitle.font = FONT_TITLE(14);
        _labShareTitle.textColor = __COLOR_262626__;
        _labShareTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self.shareView addSubview:_labShareTitle];
    }
    return _labShareTitle;
}
- (UILabel*)labShareContent
{
    if(!_labShareContent)
    {
        _labShareContent = [[UILabel alloc] init];
        _labShareContent.font = FONT_TITLE(12);
        _labShareContent.textColor = __COLOR_888888__;
        _labShareContent.translatesAutoresizingMaskIntoConstraints = NO;
        [self.shareView addSubview:_labShareContent];
    }
    return _labShareContent;
}

- (UIImageView*)flageView{
    if(!_flageView){
        _flageView = [[UIImageView alloc] init];
        [self.shareView addSubview:_flageView];
    }
    return _flageView;
}

- (UIImageView*)shareHtmlImageView{
    if(!_shareHtmlImageView){
        _shareHtmlImageView = [[UIImageView alloc] init];
        [self.shareView addSubview:_shareHtmlImageView];
    }
    return _shareHtmlImageView;
}

- (UIView*)shareView
{
    if(!_shareView)
    {
        _shareView = [[UIView alloc] init];
        _shareView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_shareView];
    }
    return _shareView;
}


- (void)shareClick:(id)sender
{
//    if(self.delegate && [self.delegate respondsToSelector:@selector(feedShareClick:)])
//    {
//        [self.delegate feedShareClick:self.cellFeedEntity];
//    }
}
@end
