//
//  NIMFeedBaseCell.m
//  QianbaoIM
//
//  Created by Yun on 14/9/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMFeedBaseCell.h"
//#import "FeedEntity.h"

//#import "UIView+line.h"

@interface NIMFeedBaseCell()

@end

@implementation NIMFeedBaseCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//
//#pragma mark class method
//+ (NSMutableAttributedString *)stringWithString:(NSString *)astring{
//    if(!astring)
//        return nil;
//    NSMutableAttributedString *rString = [[NSMutableAttributedString alloc ] initWithString:astring attributes:nil ] ;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    paragraphStyle.minimumLineHeight = 21.f;
//    paragraphStyle.maximumLineHeight = 21.f;
//
//    [rString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, astring.length)];
//    [rString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, astring.length)];
//
//    NSString *source = [SSIMSpUtil trimString:astring];
//    NSRegularExpression * regular   = [[NSRegularExpression alloc]initWithPattern:@"\\[[^\\[\\]\\s]+\\]" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
//    NSArray             * array     = [regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
//    int count = [array count];
//    int offset = 0;
//    for(int i = 0 ; i < count ; i++)
//    {
//        NSTextCheckingResult * result   = [array objectAtIndex:i];
//        NSString             * string   = [source substringWithRange:result.range];
//        NSString             * icon     = [NIMMatchParser faceKeyForValue:string map:[NIMMatchParser getFaceMap]];
//        if(icon != nil)
//        {
//            NSMutableString * iconStr=[NSMutableString stringWithFormat:@"%@.png",icon];
//            NIMTextAttachment * textAttachment = [[NIMTextAttachment alloc ] initWithData:nil ofType:nil ] ;
//            UIImage * smileImage = IMGGET(iconStr) ; //my emoticon image named a.jpg
//            textAttachment.image = smileImage;
//            textAttachment.bounds = CGRectMake(0, 0, 16, 16);
//            NSRange range = result.range;
//            range = NSMakeRange(range.location - offset, range.length);
//            NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
//            [rString replaceCharactersInRange:range withAttributedString:textAttachmentString];
//            offset += range.length -1;
//
//        }
//    }
//
//    return rString;
//}
//
//+ (CGFloat)getImageViewHeight:(FeedEntity*)feedEntity{
//    CGFloat textHeight = 0.1;
//
//
//    NSArray* images = feedEntity.imageEntity.allObjects;
//    NSInteger count = feedEntity.imageEntity.count;
//    if(images.count > 0)
//    {
//        NSMutableDictionary* muDic = @{}.mutableCopy;
//        [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            ImageFeedEntity* imgEngity = (ImageFeedEntity*)obj;
//            [muDic setValue:imgEngity.url forKey:[NSString stringWithFormat:@"%d",imgEngity.index]];
//        }];
//        NSArray* allKeys = muDic.allKeys;
//        count = [allKeys count];
//    }
//
//
//    if(count<3 && count>0)
//    {
//        textHeight += KAppWidth/2.0;
//        textHeight -= 5;
//    }
//    else if(count>=3)
//    {
//        if(count<4)
//        {
//            textHeight +=  KAppWidth/3.0;
//        }
//        else if(count<7)
//        {
//            textHeight +=  2*KAppWidth/3.0;
//            textHeight -= 5;
//        }
//        else
//        {
//            textHeight +=  KAppWidth;
//            textHeight -= 10;
//        }
//    }
//    return textHeight;
//}
//
//+ (CGFloat)getCellHeight:(FeedEntity*)feedEntity andShowFlag:(BOOL)isShow
//{
//    NSString* text = feedEntity.textEntity.text;
//    if(feedEntity.topicEntity)
//    {
//        text = [NSString stringWithFormat:@"%@ %@",feedEntity.topicEntity.name,text];
//    }
//    CGFloat textHeight = 75+kHeaderGrayHeight;//上部灰色以及图像占用位置
//    if (text)
//    {
//        MLEmojiLabel* tmpLab =[[MLEmojiLabel alloc]init];
//        tmpLab.font = [UIFont systemFontOfSize:15];
//        tmpLab.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5\\s?]+\\]";
//        tmpLab.customEmojiPlistName = @"faceMapQQNew.plist";
//        tmpLab.isNeedAtAndPoundSign = YES;
//        tmpLab.numberOfLines = 0;
//        [tmpLab sizeToFit];
//        tmpLab.text = text;
//        CGSize size = [tmpLab preferredSizeWithMaxWidth:kWidthText];
//        if(size.height>kTextMaxHeight && !isShow){
//            textHeight += kTextMaxHeight+30;
//        }
//        else{
//            if(size.height>kTextMaxHeight){
//                textHeight += size.height;
//                textHeight += 30;
//            }
//            else{
//                textHeight += size.height;
//            }
//        }
//    }
//    textHeight+=[NIMFeedBaseCell getImageViewHeight:feedEntity];//图片view高度
//    textHeight+=kBottomHeight;//下部高度
//    return textHeight;
//}
//
//- (void)setCellDataSource:(FeedEntity*)feedEntity{
//    _cellFeedEntity = feedEntity;
//    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
//}
//
//#pragma mark setHeaderValue
//- (void)setHeaderValue:(FeedEntity*)feedEntity
//{
//    NSManagedObjectContext *context = feedEntity.managedObjectContext;
//    if(context)
//    {
//    NSString* currenUserId = [NIMManager sharedImManager].loginUserInfo.userId;
//    if (feedEntity.userid == currenUserId.doubleValue) {
//        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        NSString *name=[delegate.userDataInfo.myInfo getNameShown];
//
//        if(self.labUseName.text.length == 0){
//         self.labUseName.text  = [feedEntity.nVcard defaultName];
//        }
//        else
//        {
//            self.labUseName.text=name;
//        }
//        _MYINFO_(info);
//        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:info.base_avatarPic]
//                         placeholderImage:[UIImage imageNamed:@"fclogo"]];
//    }else{
//         VcardEntity *vcard =[NVcardEntity instancetypeFindUserid:feedEntity.userid];
////                VcardEntity *vcard= [NVcardEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userid=%lld",feedEntity.userid]];
//            if (vcard) {
//                self.labUseName.text  = [vcard defaultName];
//                [self.userIcon sd_setImageWithURL:[NSURL URLWithString:vcard.avatar]
//                                 placeholderImage:[UIImage imageNamed:@"fclogo"]];
////                UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:vcard.avatar]]];
////                self.userIcon.image=image;
//            }
////        
//            else
//            {
//                self.labUseName.text=feedEntity.nickName;
//
//                [self.userIcon sd_setImageWithURL:[NSURL URLWithString:feedEntity.avatarPic]
//                                 placeholderImage:[UIImage imageNamed:@"fclogo"]];
//
//            }
//    
//
//
//  }
//    
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
//            self.labText.numberOfLines = 7;
//            [self.btnShowMore setTitle:@"全文" forState:UIControlStateNormal];
//            
//        }
//        else{
//            self.labText.numberOfLines = 0;
//            [self.btnShowMore setTitle:@"收起" forState:UIControlStateNormal];
//        }
//        if(size.height<kTextMaxHeight){
//            self.btnShowMore.hidden = YES;
//        }
//        else{
//                        self.btnShowMore.hidden = NO;
//        }
//    }
//    }
//    else
//    {
//        return;
//    }
//}

#pragma mark setImagesValue
//- (void)setImagesValue:(FeedEntity*)feedEntity{
//    NSArray* subs = self.vImages.subviews;
//    [subs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if([obj isKindOfClass:[UIImageView class]])
//        {
//            UIImageView* v = (UIImageView*)obj;
//            v.image = nil;
//            v.hidden = YES;
//        }
//    }];
//    NSArray* images = feedEntity.imageEntity.allObjects;
//    if(images.count==0)return;
//    NSMutableDictionary* muDic = @{}.mutableCopy;
//    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        ImageFeedEntity* imgEngity = (ImageFeedEntity*)obj;
//        [muDic setValue:imgEngity.url forKey:[NSString stringWithFormat:@"%d",imgEngity.index]];
//    }];
//    NSArray* allKeys = muDic.allKeys;
//    allKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
//    for(NSInteger i=0;i<allKeys.count;i++){
//        UIImageView* img = (UIImageView*)[self.vImages viewWithTag:i+1];
//        img.hidden = NO;
//        NSString* surl = muDic[allKeys[i]];
//        surl = [NSString stringWithFormat:@"%@/200",surl];
//        [img sd_setImageWithURL:[NSURL URLWithString:surl] placeholderImage:[UIImage imageNamed:@"bg_dialog_pictures.png"]];
//    }
//}

#pragma mark setBotterValue
//- (void)setBottomValue:(FeedEntity*)feedEntity{
//    NSInteger likeCount = feedEntity.likecount;
//    NSInteger commentsCount = feedEntity.commentsCount;
//    [self.btnMessage setTitle:[NSString stringWithFormat:@"%d",commentsCount] forState:UIControlStateNormal];
//    [self.btnMessage setImage:IMGGET(@"icon_square_comment") forState:UIControlStateNormal];
//    if(feedEntity.liked)
//    {
//    }
//    else
//    {
//        [self.btnPraise setImage:IMGGET(@"icon_square_praise") forState:UIControlStateNormal];
//    }
//    [self.btnPraise setTitle:[NSString stringWithFormat:@"%d",likeCount] forState:UIControlStateNormal];
//}

#pragma mark layout seter
//- (void)setBaseViewLayout:(FeedEntity*)feedEntity{
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
//        make.bottom.equalTo(self.vBottom.mas_top);
//        make.height.with.offset(textHeight);
//    }];
//
//    [self.vBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.contentView.mas_trailing);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.height.with.offset(kBottomHeight);
//    }];
//}

//- (void)setHeaderViewLayout//设置上部view layout
//{
//    [self.topImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vHeader.mas_top);
//        make.leading.equalTo(self.vHeader.mas_leading);
//        make.trailing.equalTo(self.vHeader.mas_trailing);
//        make.height.with.offset(kHeaderGrayHeight);
//    }];
//    [self.userIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.vHeader.mas_leading).with.offset(10);
//        make.top.equalTo(self.topImageView.mas_bottom).with.offset(10);
//        make.width.with.offset(40);
//        make.height.with.offset(40);
//    }];
//    [self.labUseName mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.userIcon.mas_trailing).with.offset(10);
//        make.top.equalTo(self.userIcon.mas_top);
//        make.trailing.equalTo(self.btnMore.mas_leading);
//        make.height.with.offset(25);
//    }];
//    [self.labTime mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.userIcon.mas_trailing).with.offset(10);
//        make.bottom.equalTo(self.userIcon.mas_bottom);
//        make.trailing.equalTo(self.btnMore.mas_leading);
//        make.height.with.offset(20);
//    }];
//    [self.labText mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.vHeader.mas_leading).with.offset(10);
//        make.top.equalTo(self.userIcon.mas_bottom).with.offset(15);
//        make.trailing.equalTo(self.vHeader.mas_trailing).with.offset(-10);
//        make.height.greaterThanOrEqualTo(@0);
//    }];
//    [self.btnMore mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.vHeader.mas_trailing).with.offset(-5);
//        make.top.equalTo(self.vHeader.mas_top).with.offset(20);
//        make.width.with.offset(40);
//        make.height.with.offset(40);
//    }];
//    [self.btnShowMore mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.vHeader.mas_trailing);
//        make.bottom.equalTo(self.vHeader.mas_bottom);
//        make.width.with.offset(60);
//        make.height.with.offset(30);
//    }];
//}

//- (void)setImagesViewLayout:(NSInteger)count//设置图片layout
//{
//    if(count>=7)//3行
//    {
//        [self.img1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(5);
//            make.leading.equalTo(self.vImages.mas_leading).with.offset(10);
//            make.width.with.offset((KAppWidth-30)/3);
//            make.height.width.offset((KAppWidth-30)/3);
//        }];
//
//        [self.img2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(5);
//            make.leading.equalTo(self.img1.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img3 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(5);
//            make.leading.equalTo(self.img2.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img4 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img1.mas_bottom).with.offset(5);
//            make.leading.equalTo(self.vImages.mas_leading).with.offset(10);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img5 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img4.mas_top);
//            make.leading.equalTo(self.img4.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img6 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img4.mas_top);
//            make.leading.equalTo(self.img5.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img7 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img4.mas_bottom).with.offset(5);
//            make.leading.equalTo(self.vImages.mas_leading).with.offset(10);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img8 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img7.mas_top);
//            make.leading.equalTo(self.img7.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img9 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img7.mas_top);
//            make.leading.equalTo(self.img8.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//    }
//    else if(count>=4 && count<=6)//2行
//    {
//        [self.img1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(5);
//            make.leading.equalTo(self.vImages.mas_leading).with.offset(10);
//            make.width.with.offset((KAppWidth-30)/3);
//            make.height.with.offset((KAppWidth-30)/3);
//        }];
//
//        [self.img2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(5);
//            make.leading.equalTo(self.img1.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img3 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(5);
//            make.leading.equalTo(self.img2.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img4 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img1.mas_bottom).with.offset(5);
//            make.leading.equalTo(self.vImages.mas_leading).with.offset(10);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img5 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img4.mas_top);
//            make.leading.equalTo(self.img4.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img6 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.img4.mas_top);
//            make.leading.equalTo(self.img5.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//    }
//    else if(count>=3)//1行小
//    {
//        [self.img1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(0);
//            make.leading.equalTo(self.vImages.mas_leading).with.offset(10);
//            make.width.with.offset((KAppWidth-30)/3);
//            make.height.with.offset((KAppWidth-30)/3);
//        }];
//
//        [self.img2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(0);
//            make.leading.equalTo(self.img1.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//
//        [self.img3 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(0);
//            make.leading.equalTo(self.img2.mas_trailing).with.offset(5);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//    }
//    else //if(count==2) //2个图片大
//    {
//        [self.img1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(0);
//            make.leading.equalTo(self.vImages.mas_leading).with.offset(10);
//            make.width.with.offset((KAppWidth-30)/2);
//            make.height.with.offset((KAppWidth-30)/2);
//        }];
//
//        [self.img2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.vImages.mas_top).with.offset(0);
//            make.trailing.equalTo(self.vImages.mas_trailing).with.offset(-15);
//            make.width.equalTo(self.img1.mas_width);
//            make.height.equalTo(self.img1.mas_height);
//        }];
//    }
//}

//- (void)setBottomViewLayout//设置底部layout
//{
//    [self.centerLine mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vBottom.mas_top);
//        make.bottom.equalTo(self.vBottom.mas_bottom);
//        make.centerX.equalTo(self.vBottom.mas_centerX);
//        make.width.with.offset(_LINE_HEIGHT_1_PPI);
//    }];
//
//    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vBottom.mas_top);
//        make.leading.equalTo(self.vBottom.mas_leading);
//        make.trailing.equalTo(self.vBottom.mas_trailing);
//        make.height.with.offset(_LINE_HEIGHT_1_PPI);
//    }];
//
//    [self.btnMessage mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.vBottom.mas_leading);
//        make.top.equalTo(self.vBottom.mas_top);
//        make.bottom.equalTo(self.vBottom.mas_bottom);
//        make.width.greaterThanOrEqualTo(@10);
//    }];
//
//    [self.btnPraise mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.vBottom.mas_trailing);
//        make.top.equalTo(self.vBottom.mas_top);
//        make.bottom.equalTo(self.vBottom.mas_bottom);
//        make.leading.equalTo(self.btnMessage.mas_trailing);
//        make.width.equalTo(self.btnMessage.mas_width);
//    }];
//}

//- (void)showMoreInfo:(UIButton*)sender{
//    if(_delegate && [_delegate respondsToSelector:@selector(showOrHiddenMoreTextInfo:adIndex:)]){
//        [_delegate showOrHiddenMoreTextInfo:self.cellFeedEntity adIndex:self];
//    }
//}
//
//#pragma mark settter
//- (UIView*)vHeader
//{
//    if(!_vHeader)
//    {
//        _vHeader = [[UIView alloc] init];
//        [self.contentView addSubview:_vHeader];
//        _vHeader.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _vHeader;
//}
//- (UIView*)vImages
//{
//    if(!_vImages)
//    {
//        _vImages = [[UIView alloc] init];
//        [self.contentView addSubview:_vImages];
//        _vImages.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _vImages;
//}
//- (UIView*)vBottom
//{
//    if(!_vBottom)
//    {
//        _vBottom = [[UIView alloc] init];
//        [self.contentView addSubview:_vBottom];
//        _vBottom.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _vBottom;
//}
//////header
//- (UIImageView*)topImageView
//{
//    if(!_topImageView)
//    {
//        _topImageView = [[UIImageView alloc] init];
//        _topImageView.backgroundColor = [UIColor whiteColor];
//        _topImageView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.vHeader addSubview:_topImageView];
//
////        [_topImageView qb_addBottomLine:0 color:__COLOR_D5D5D5__];
////        [_topImageView qb_addTopLine:0 color:__COLOR_D5D5D5__];
//    }
//    return _topImageView;
//}
//- (UIImageView*)userIcon
//{
//    if(!_userIcon)
//    {
//        _userIcon = [[UIImageView alloc] init];
//        _userIcon.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAction:)];
//        [_userIcon addGestureRecognizer:tap];
//        _userIcon.layer.cornerRadius = 4;
//        _userIcon.layer.masksToBounds = YES;
//        _userIcon.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.vHeader addSubview:_userIcon];
//    }
//    return _userIcon;
//}
//- (UILabel*)labUseName
//{
//    if(!_labUseName)
//    {
//        _labUseName = [[UILabel alloc] init];
//        _labUseName.font = [UIFont boldSystemFontOfSize:16];
//        _labUseName.userInteractionEnabled = YES;
//        _labUseName.textColor = __COLOR_262626__;
////        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAction:)];
////        [_labUseName addGestureRecognizer:tap];
//        _labUseName.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.vHeader addSubview:_labUseName];
//    }
//    return _labUseName;
//}
//- (UILabel*)labTime
//{
//    if(!_labTime)
//    {
//        _labTime = [[UILabel alloc] init];
//        _labTime.font = [UIFont systemFontOfSize:12];
//        _labTime.textColor = __COLOR_888888__;
//        [_vHeader addSubview:_labTime];
//        _labTime.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _labTime;
//}
//- (MLEmojiLabel*)labText
//{
//    if(!_labText)
//    {
//        _labText = [[MLEmojiLabel alloc]init];
//        _labText.numberOfLines = 1;
//        _labText.font =[UIFont systemFontOfSize:15];
//        _labText.textColor = __COLOR_262626__;
//        _labText.emojiDelegate = self;
//        self.vHeader.clipsToBounds = YES;
//        [self.vHeader addSubview:_labText];
//    }
//    _labText.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//    _labText.customEmojiPlistName = @"faceMapQQNew.plist";
//    _labText.isNeedAtAndPoundSign = YES;
//    return _labText;
//}
//
//- (UIButton*)btnShowMore{
//    if(!_btnShowMore){
//        _btnShowMore = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btnShowMore setTitle:@"全文" forState:UIControlStateNormal];
//        [_btnShowMore setTitleColor:[SSIMSpUtil getColor:@"2b93fd"] forState:UIControlStateNormal];
//        _btnShowMore.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_btnShowMore addTarget:self action:@selector(showMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
//        [_btnShowMore setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_btnShowMore setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [self.vHeader addSubview:_btnShowMore];
//    }
//    return _btnShowMore;
//}
//- (UIButton*)btnMore
//{
//    if(!_btnMore)
//    {
//        _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btnMore setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [_btnMore setImage:IMGGET(@"icon_square_more") forState:UIControlStateNormal];
//        [_btnMore addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_vHeader addSubview:_btnMore];
//        _btnMore.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _btnMore;
//}
//
//////header end
//
//////images
//- (UIImageView*)img1
//{
//    if(!_img1)
//    {
//        _img1 = [[UIImageView alloc] init];
//        _img1.tag = 1;
//        _img1.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img1 addGestureRecognizer:tap];
//        _img1.translatesAutoresizingMaskIntoConstraints = NO;
//        _img1.contentMode = UIViewContentModeScaleAspectFill;
//        _img1.clipsToBounds = YES;
//        [self.vImages addSubview:_img1];
//    }
//    return _img1;
//}
//- (UIImageView*)img2
//{
//    if(!_img2)
//    {
//        _img2 = [[UIImageView alloc] init];
//        _img2.tag = 2;
//        _img2.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img2 addGestureRecognizer:tap];
//        _img2.translatesAutoresizingMaskIntoConstraints = NO;
//        _img2.contentMode = UIViewContentModeScaleAspectFill;
//        _img2.clipsToBounds = YES;
//        [self.vImages addSubview:_img2];
//    }
//    return _img2;
//}
//- (UIImageView*)img3
//{
//    if(!_img3)
//    {
//        _img3 = [[UIImageView alloc] init];
//        _img3.tag = 3;
//        _img3.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img3 addGestureRecognizer:tap];
//        _img3.translatesAutoresizingMaskIntoConstraints = NO;
//        _img3.contentMode = UIViewContentModeScaleAspectFill;
//        _img3.clipsToBounds = YES;
//        [self.vImages addSubview:_img3];
//    }
//    return _img3;
//}
//- (UIImageView*)img4
//{
//    if(!_img4)
//    {
//        _img4 = [[UIImageView alloc] init];
//        _img4.tag = 4;
//        _img4.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img4 addGestureRecognizer:tap];
//        _img4.translatesAutoresizingMaskIntoConstraints = NO;
//        _img4.contentMode = UIViewContentModeScaleAspectFill;
//        _img4.clipsToBounds = YES;
//        [self.vImages addSubview:_img4];
//    }
//    return _img4;
//}
//- (UIImageView*)img5
//{
//    if(!_img5)
//    {
//        _img5 = [[UIImageView alloc] init];
//        _img5.tag = 5;
//        _img5.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img5 addGestureRecognizer:tap];
//        _img5.translatesAutoresizingMaskIntoConstraints = NO;
//        _img5.contentMode = UIViewContentModeScaleAspectFill;
//        _img5.clipsToBounds = YES;
//        [self.vImages addSubview:_img5];
//    }
//    return _img5;
//}
//- (UIImageView*)img6
//{
//    if(!_img6)
//    {
//        _img6 = [[UIImageView alloc] init];
//        _img6.tag = 6;
//        _img6.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img6 addGestureRecognizer:tap];
//        _img6.translatesAutoresizingMaskIntoConstraints = NO;
//        _img6.contentMode = UIViewContentModeScaleAspectFill;
//        _img6.clipsToBounds = YES;
//        [self.vImages addSubview:_img6];
//    }
//    return _img6;
//}
//- (UIImageView*)img7
//{
//    if(!_img7)
//    {
//        _img7 = [[UIImageView alloc] init];
//        _img7.tag = 7;
//        _img7.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img7 addGestureRecognizer:tap];
//        _img7.translatesAutoresizingMaskIntoConstraints = NO;
//        _img7.contentMode = UIViewContentModeScaleAspectFill;
//        _img7.clipsToBounds = YES;
//        [self.vImages addSubview:_img7];
//    }
//    return _img7;
//}
//- (UIImageView*)img8
//{
//    if(!_img8)
//    {
//        _img8 = [[UIImageView alloc] init];
//        _img8.tag = 8;
//        _img8.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img8 addGestureRecognizer:tap];
//        _img8.translatesAutoresizingMaskIntoConstraints = NO;
//        _img8.contentMode = UIViewContentModeScaleAspectFill;
//        _img8.clipsToBounds = YES;
//        [self.vImages addSubview:_img8];
//    }
//    return _img8;
//}
//- (UIImageView*)img9
//{
//    if(!_img9)
//    {
//        _img9 = [[UIImageView alloc] init];
//        _img9.tag = 9;
//        _img9.userInteractionEnabled = YES;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
//        [_img9 addGestureRecognizer:tap];
//        _img9.translatesAutoresizingMaskIntoConstraints = NO;
//        _img9.contentMode = UIViewContentModeScaleAspectFill;
//        _img9.clipsToBounds = YES;
//        [self.vImages addSubview:_img9];
//    }
//    return _img9;
//}
//////images end
//
//////bottom
//- (UIImageView*)topLine
//{
//    if(!_topLine)
//    {
//        _topLine = [[UIImageView alloc]init];
////        _topLine.image = IMGGET(@"feed_line");
//        _topLine.backgroundColor=[SSIMSpUtil getColor:@"e6e6e6"];
//
//        _topLine.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.vBottom addSubview:_topLine];
//    }
//    return _topLine;
//}
//- (UIImageView*)centerLine
//{
//    if(!_centerLine)
//    {
//        _centerLine = [[UIImageView alloc] init];
//        _centerLine.image = IMGGET(@"bg_square_line");
//        [self.vBottom addSubview:_centerLine];
//        _centerLine.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _centerLine;
//}
//- (UIButton*)btnMessage
//{
//    if(!_btnMessage)
//    {
//
//        _btnMessage = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btnMessage setTitleColor:[SSIMSpUtil getColor:@"a0a0a0"] forState:UIControlStateNormal];
//        _btnMessage.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_btnMessage addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.vBottom addSubview:_btnMessage];
//        _btnMessage.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _btnMessage;
//}
//- (UIButton*)btnPraise
//{
//    if(!_btnPraise)
//    {
//        _btnPraise = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btnPraise setTitleColor:[SSIMSpUtil getColor:@"a0a0a0"] forState:UIControlStateNormal];
//        _btnPraise.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_btnPraise addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.vBottom addSubview:_btnPraise];
//        _btnPraise.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _btnPraise;
//}
//////bottom end
//
//#pragma mark cellButtonAction
//- (void)praiseAction:(UIButton*)btn
//{
//    if(_delegate&&[_delegate respondsToSelector:@selector(NIMFeedCellPraiseAction:)])
//    {
//        [_delegate NIMFeedCellPraiseAction:_cellFeedEntity];
//    }
//}
//
//- (void)messageAction:(UIButton*)btn{
//    if(_delegate&&[_delegate respondsToSelector:@selector(feedMessageAction:cell:)])
//    {
//        [_delegate feedMessageAction:_cellFeedEntity cell:self];
//    }
//}
//
//- (void)moreAction:(UIButton*)btn
//{
//    if(_delegate&&[_delegate respondsToSelector:@selector(feedMoreAction:)])
//    {
//        [_delegate feedMoreAction:_cellFeedEntity];
//    }
//}
//- (void)userAction:(id)sender
//{
//    if(_delegate&&[_delegate respondsToSelector:@selector(feedUserClick:)])
//    {
//        [_delegate feedUserClick:_cellFeedEntity];
//    }
//}
//- (void)imageClick:(UITapGestureRecognizer*)tap
//{
//    if([_delegate respondsToSelector:@selector(feedImageDidClick)])
//    {
//        [_delegate feedImageDidClick];
//    }
//    UIImageView* curentImageview = (UIImageView*)tap.view;
//
//    NSArray* images = _cellFeedEntity.imageEntity.allObjects;
//    if(images.count==0)return;
//    NSMutableDictionary* muDic = @{}.mutableCopy;
//    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        ImageFeedEntity* imgEngity = (ImageFeedEntity*)obj;
//        [muDic setValue:imgEngity.url forKey:[NSString stringWithFormat:@"%d",imgEngity.index]];
//    }];
//    NSArray* allKeys = muDic.allKeys;
//    allKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
//
//    int count = allKeys.count;
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<allKeys.count; i++) {
//        NSString *url = muDic[allKeys[i]];
//        NIMPhotoObject* obj = [[NIMPhotoObject alloc] init];
//        obj.imageUrl = url;
//        obj.currentImageView = (UIImageView*)[_vImages viewWithTag:i+1];
//        [photos addObject:obj];
//    }
//
//    NIMPhotoVC* vc = [[NIMPhotoVC alloc] init];
//    [vc setPhotoDataSource:photos atIndex:curentImageview.tag-1 showDelete:NO];
//
//}
//
//
//- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type{
//    if(_delegate && [_delegate respondsToSelector:@selector(emojiLabelClick:clickStr:withType:)]){
//        [_delegate emojiLabelClick:self.cellFeedEntity clickStr:link withType:type];
//    }
//}
@end
