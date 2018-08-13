//
//  NIMFeedTableViewCell.m
//  QianbaoIM
//
//  Created by iln on 14/8/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "NIMFeedImgFlowLayout.h"
#import "NIMFeedTableViewCell.h"
//#import "TextEntity.h"
//#import "TopicEntity.h"
//#import "ImageFeedEntity.h"
  
//#import "Comment.h"
#import "NIMMatchParseData.h"
#import "NIMTextAttachment.h"

@implementation NIMFeedTableViewCell
@synthesize delegate = _delegate;
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark config
- (void)updateWithVcardEntity:( VcardEntity *)vcardEntity{
    NSString *name = [vcardEntity defaultName];
    NSString *avatar = vcardEntity.avatar;
    [self.nameBtn setTitle:name forState:UIControlStateNormal];

    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:[NSString nim_forIMIcon:avatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];

}
//
//- (void)updateWithFeedEntity:(FeedEntity *)feedEntity{
//       VcardEntity *vcard = [VcardEntity instancetypeFindUserid:feedEntity.userid];
//    [self updateWithVcardEntity:vcard];
//    NSString *timeStr = [NSString stringWithFormat:@"江苏 南京 %@",[SSIMSpUtil timeString:feedEntity.ct]];
//    [self.timeLabel setText:timeStr];
//}
//
//- (void)updateWithCommentEntity:(Comment *)commentEntity{
//       VcardEntity *vcard = [VcardEntity instancetypeFindUserid:commentEntity.userid];
//    [self updateWithVcardEntity:vcard];
//    NSString *timeStr = [NSString stringWithFormat:@"江苏 南京 %@",[SSIMSpUtil timeString:commentEntity.ct]];
//    [self.timeLabel setText:timeStr];
//}
//
//#pragma mark action
//- (IBAction)avatarClick:(id)sender{
//    [_delegate NIMFeedCell:self actionDidWithFeedEntity:self.feedEntity actionType:NIMFeedCellActionTypeTypeAvatar object:nil];
//}
//- (IBAction)nameClick:(id)sender{
//    [_delegate NIMFeedCell:self actionDidWithFeedEntity:self.feedEntity actionType:NIMFeedCellActionTypeTypeName object:nil];
//}
//
//- (IBAction)optionClick:(id)sender{
//    [_delegate NIMFeedCell:self actionDidWithFeedEntity:self.feedEntity actionType:NIMFeedCellActionTypeTypeOption object:nil];
//}
//
//- (void)imageBtnClick:(UIButton *)button{
//    int tag = button.tag;
//
//    if (tag < self.feedEntity.imageEntity.count) {
//        NSArray *imageArray = [self.feedEntity.imageEntity allObjects];
//        ImageFeedEntity *imageEntity = [imageArray objectAtIndex:tag];
//        [_delegate NIMFeedCell:self actionDidWithFeedEntity:self.feedEntity actionType:NIMFeedCellActionTypeTypeImage object:imageEntity];
//    }
//}

#pragma mark class method
+ (NSMutableAttributedString *)stringWithString:(NSString *)astring{
    if(!astring)
        return nil;
    NSMutableAttributedString *rString = [[NSMutableAttributedString alloc ] initWithString:astring attributes:nil ] ;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.minimumLineHeight = 21.f;
    paragraphStyle.maximumLineHeight = 21.f;
    
    [rString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, astring.length)];
    [rString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, astring.length)];
    
    NSString *source = [SSIMSpUtil trimString:astring];
    NSRegularExpression * regular   = [[NSRegularExpression alloc]initWithPattern:@"\\[[^\\[\\]\\s]+\\]" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray             * array     = [regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    int count = [array count];
    int offset = 0;
    for(int i = 0 ; i < count ; i++)
    {
        NSTextCheckingResult * result   = [array objectAtIndex:i];
        NSString             * string   = [source substringWithRange:result.range];
        NSString             * icon     = [NIMMatchParser faceKeyForValue:string map:[NIMMatchParser getFaceMap]];
        if(icon != nil)
        {
            NSMutableString * iconStr=[NSMutableString stringWithFormat:@"%@.png",icon];
            NIMTextAttachment * textAttachment = [[NIMTextAttachment alloc ] initWithData:nil ofType:nil ] ;
            UIImage * smileImage = IMGGET(iconStr); //my emoticon image named a.jpg
            textAttachment.image = smileImage;
            textAttachment.bounds = CGRectMake(0, 0, 16, 16);
            NSRange range = result.range;
            range = NSMakeRange(range.location - offset, range.length);
            NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [rString replaceCharactersInRange:range withAttributedString:textAttachmentString];
            offset += range.length -1;
            
        }
    }
    
    return rString;
}

+ (CGFloat)heightWithPlainText:(NSString *)text targetRange:(NSRange)range{
    CGFloat textHeight = 21;
    if (text ) {
        NSMutableAttributedString *attributedText = [self stringWithString:text];


        CGRect paragraphRect =
        [attributedText boundingRectWithSize:CGSizeMake(kWidthText, CGFLOAT_MAX)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     context:nil];
        
        CGFloat height = 21;
        if (ceilf(paragraphRect.size.height) > 21) {
            height = ceilf(paragraphRect.size.height);
        }
        
        textHeight = height + 0;
    }
    return textHeight;
}

//+ (CGFloat)heightWithPlainTextWithTextEntity:(FeedEntity *)feedEntity{
//    CGFloat textHeight= 21;
//    if (feedEntity.textEntity ) {
//        NSString *textToMeasure = feedEntity.textEntity.text;
//        if(feedEntity.topicEntity)
//        {
//            NSString* topicName = feedEntity.topicEntity.name;
//            textToMeasure = [NSString stringWithFormat:@"#%@# %@",topicName,textToMeasure];
//        }
//        textHeight = [NIMFeedTableViewCell heightWithPlainText:textToMeasure targetRange:NSMakeRange(0, 0)];
//    }
//    return textHeight+21;
//}

+ (CGFloat)heightWithContainerWithImageEntitys:(NSSet *)imageEntitys{
    CGFloat imageHeight= 0;
    NSInteger count = imageEntitys.count;
    imageHeight = [NIMFeedImgFlowLayout CollectionBubbleSizeWithCount:count].height;
    return imageHeight + 0;
}

//+ (CGFloat)heightWithFeedEntity:(FeedEntity *)feedEntity{
//
//    IMFeedContentType feedType = feedEntity.feedContentType;
//    CGFloat textHeight = 0;
//    CGFloat imageHeight = 0;
//    if (feedType == IMFeedContentTypeText) {
//        textHeight = [[self class] heightWithPlainTextWithTextEntity:feedEntity];
//    }else if (feedType == IMFeedContentTypeImage){
//        imageHeight = [[self class] heightWithContainerWithImageEntitys:feedEntity.imageEntity];
//    }else if (feedType == IMFeedContentTypeJson) {
//        textHeight = [[self class] heightWithPlainTextWithTextEntity:feedEntity];
//        imageHeight = [[self class] heightWithContainerWithImageEntitys:feedEntity.imageEntity];
//    }
//
//    return imageHeight + textHeight + kHeightReserved;
//}

//+ (CGFloat)heightWithCommentEntity:(Comment *)commentEntity{
//    if (!commentEntity) {
//        return 0;
//    }
//    
//    NSMutableString *text = [[NSMutableString alloc] init];
//    if (commentEntity.targetid || commentEntity.targetName) {
//         VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:commentEntity.userid];
//        if (vcardEntity) {
//            [text appendFormat:@"回复%@:",[vcardEntity defaultName]];
//        }
//    }
//    NSRange targetRange = NSMakeRange(0, text.length);
//    [text appendString:commentEntity.textEntity.text];
//    CGFloat textHeight = 0;
//    textHeight = [NIMFeedTableViewCell heightWithPlainText:text targetRange:targetRange];;
//    return textHeight + kHeightReservedComment;
//}


@end
