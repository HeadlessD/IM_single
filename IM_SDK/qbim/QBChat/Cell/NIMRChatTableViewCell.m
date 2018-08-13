//
//  NIMRChatTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRChatTableViewCell.h"
#import "NIMTextAttachment.h"
#import "NIMMatchParseData.h"
#import "TextEntity+CoreDataClass.h"

@interface NIMRChatTableViewCell ()<UIGestureRecognizerDelegate>


@end
@implementation NIMRChatTableViewCell
@synthesize delegate = _delegate;
@synthesize menuItems = _menuItems;
@synthesize image = _image;
@synthesize highlightedImage = _highlightedImage;


static MLEmojiLabel* tmpLab = nil;
#pragma mark actions
- (void)actionCopy:(id)sender{
    
}

- (void)actionForward:(id)sender{
    
}

-(void)actionVoice:(id)sender
{
    
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(actionCopy:) || action == @selector(actionForward:) || action == @selector(actionVoice:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([[otherGestureRecognizer.view class] isSubclassOfClass:[UIButton class]]) {
        return YES;
    }
    return NO;
}
#pragma mark getter
- (UILongPressGestureRecognizer *)longPressRecognizer{
    if (!_longPressRecognizer) {
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recognizerHandler:)];
        _longPressRecognizer.numberOfTouchesRequired = 1;
        _longPressRecognizer.cancelsTouchesInView =  NO;
        _longPressRecognizer.minimumPressDuration = 0.75f;
    }
    return _longPressRecognizer;
}

- (UITapGestureRecognizer *)tapGestureRecognizer{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerHandler:)];
        _tapGestureRecognizer.numberOfTapsRequired = 1;
        _tapGestureRecognizer.cancelsTouchesInView =  NO;
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    self.recordEntity = recordEntity;
    self.showName = NO;
    E_MSG_CHAT_TYPE chatType = recordEntity.chatType;
    if (chatType == GROUP) {
//        GroupList* group = [GroupList NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",recordEntity.messageBodyId]];
//        self.showName = group.showname;
        int64_t groupid = [NIMStringComponents getOpuseridWithMsgBodyId:recordEntity.messageBodyId];
        self.showName = [[[NIMSysManager sharedInstance].groupShowDict objectForKey:@(groupid)] boolValue];
    }
    if (recordEntity.isSender) {
        self.showName = NO;
    }

}
- (void)updateWithRecordEntity:(ChatEntity *)recordEntity previousRecordEntity:(ChatEntity *)preRecordEntity{
    BOOL showTimeline = NO;
    if (recordEntity.ct - preRecordEntity.ct >= kIntervalTime) {
        showTimeline = YES;
    }
    self.enableClick = YES;
    self.showTimeline = showTimeline;
    [self updateWithRecordEntity:recordEntity];
}

#pragma mark actions
- (IBAction)recognizerHandler:(UILongPressGestureRecognizer*)gesture
{

}

- (IBAction)tapRecognizerHandler:(UITapGestureRecognizer*)gesture
{
    
}
#pragma mark Menu Notification
- (void)menuControllerDidHideMenuNotification:(NSNotification *)notification{
}
#pragma public method
+ (NSMutableAttributedString *)stringWithString:(NSString *)astring{
    NSString *source = [SSIMSpUtil trimString:astring];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.minimumLineHeight = 10.f;
    paragraphStyle.maximumLineHeight = 20.f;

    NSDictionary *attribs = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14],
                              NSParagraphStyleAttributeName:paragraphStyle};
    
    NSMutableAttributedString *rString = [[NSMutableAttributedString alloc] initWithString:source attributes:attribs];
    NSRegularExpression * regular   = [[NSRegularExpression alloc]initWithPattern:@"\\[[^\\[\\]\\s]+\\]"
                                                                          options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive
                                                                            error:nil];
    
    NSArray             * array     = [regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    NSUInteger count = [array count];
    int offset = 0;
    for(int i = 0 ; i < count ; i++)
    {
        NSTextCheckingResult * result   = [array objectAtIndex:i];
        NSString             * string   = [source substringWithRange:result.range];
        NSString             * icon     = [NIMMatchParser faceKeyForValue:string map:[NIMMatchParser getFaceMap]];
        if(icon != nil)
        {
            NSMutableString * iconStr=[NSMutableString stringWithFormat:@"%@.png",icon];
            
            
            NIMTextAttachment * textAttachment = [[NIMTextAttachment alloc] initWithData:nil ofType:nil] ;
            UIImage * smileImage = IMGGET(iconStr) ; //emoticon image
            textAttachment.image = smileImage;
            textAttachment.bounds = CGRectMake(0, 0, 8, 8);
            NSRange range = result.range;
            range = NSMakeRange(range.location - offset, range.length);
//            NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
//            [rString replaceCharactersInRange:range withAttributedString:textAttachmentString];
            
            NSString *imageName = iconStr;
            NSFileWrapper *imageFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:UIImagePNGRepresentation(IMGGET(imageName))];
            imageFileWrapper.filename = imageName;
            imageFileWrapper.preferredFilename = imageName;
            
            NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
            imageAttachment.fileWrapper = imageFileWrapper;
            imageAttachment.bounds = CGRectMake(0, 0, 18, 18);
            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
            [rString replaceCharactersInRange:range withAttributedString:imageAttributedString];
            
            offset += range.length -1;
        }
    }
    return rString;
}


+ (NSArray*)parseUrl:(NSString*)oriStr{
    NSString * http = @"(http(s)?://)?";
    
    NSString * center = @"((([\\w-]+\\.)+)|(http(s)?://))([\\w-])+(.com|.net|.cn|.gov.cn|.org|.name|.info|.biz|.cc|.tv|.me|.co|.so|.tel|.mobi|.asia)";
    
    NSString *pram = @"+([a-zA-Z0-9;,./?%&-_=]*)?";
    
    NSString *strRegular = _IM_FormatStr(@"%@%@%@",http,center,pram);
    
    NSRegularExpression*regular = [[NSRegularExpression alloc]initWithPattern:strRegular
                                                                      options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array = [regular matchesInString:oriStr options:0 range:NSMakeRange(0, [oriStr length])];
    return array;
}




+ (CGRect )rectWithPlainText:(NSString *)text targetRange:(NSRange)range{
    NSMutableAttributedString *attributedText = [self stringWithString:text];
    CGRect paragraphRect =
    [attributedText boundingRectWithSize:CGSizeMake(kMaxWidthContent, CGFLOAT_MAX)
                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 context:nil];
    return paragraphRect;
}

+ (CGRect)rectWithPlainTextWithTextEntity:(TextEntity *)textEntity{
    NSString *textToMeasure = textEntity.text;
    CGRect paragraphRect = [NIMRChatTableViewCell rectWithPlainText:textToMeasure targetRange:NSMakeRange(0, 0)];
    return paragraphRect;
}

+ (CGFloat)heightWithNRecordEntity:(ChatEntity *)recordEntity previousRecordEntity:(ChatEntity *)preRecordEntity{
    E_MSG_CHAT_TYPE chatType = recordEntity.chatType;
    E_MSG_M_TYPE contentType = recordEntity.mtype;
    E_MSG_S_TYPE contentSubType = recordEntity.stype;
    CGFloat heightCell = 0;
    BOOL showTimeline = NO;
    
    if (recordEntity.ct - preRecordEntity.ct >= kIntervalTime) {
        showTimeline = YES;
    }
    
    BOOL showName = NO;
    if (recordEntity.isSender) {
        showName = NO;
    }else{
        if (chatType == GROUP) {
            int64_t groupid = [NIMStringComponents getOpuseridWithMsgBodyId:recordEntity.messageBodyId];
            showName = [[[NIMSysManager sharedInstance].groupShowDict objectForKey:@(groupid)] boolValue];
        }
    }
    
    if (showTimeline) {
        heightCell += kHeightTimeline;
    }
    
    if (showName) {
        heightCell += kHeightName;
    }
    
    switch (contentType) {
        case TEXT:
        {
            TextEntity *textEntity = recordEntity.textFile;
            if (!tmpLab) {
                tmpLab =[[MLEmojiLabel alloc]initWithFrame:CGRectZero];
                tmpLab.font = [UIFont systemFontOfSize:16];
                tmpLab.customEmojiPlistName = @"faceMapQQNew.plist";
                tmpLab.isNeedAtAndPoundSign = YES;
            }
            tmpLab.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            tmpLab.numberOfLines = 0;
            [tmpLab sizeToFit];
            tmpLab.text = textEntity.text;
            CGSize size = [tmpLab preferredSizeWithMaxWidth:kMaxWidthContent];
            heightCell += size.height;
            heightCell += 30;
        }
            
            break;
        case ITEM:
        {
            NSString* sbody = recordEntity.msgContent;
            NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
            NSString *titleStr = [htmDic objectForKey:@"product_title"];
            titleStr = titleStr?:[htmDic objectForKey:@"product_name"];
            CGSize size =[NSString nim_getSizeFromString:titleStr withFont:[UIFont boldSystemFontOfSize:15] andLabelSize:CGSizeMake(kMaxWidthContent-21, 40)];
            heightCell+=115+size.height;
        }
            break;
        case IMAGE:
        {
            UIImage *image = nil;
            ImageEntity *imageEntity = recordEntity.imageFile;
            if (imageEntity.file) {
                
                NSString *fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
                NSString *filePath = [NSString stringWithFormat:@"%@%@",fullPath,imageEntity.file];
                image = [UIImage imageWithContentsOfFile:filePath];
                
            }else if (imageEntity.bigFile){
                NSString *fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
                NSString *filePath = [NSString stringWithFormat:@"%@%@",fullPath,imageEntity.bigFile];
                UIImage *orimage = [UIImage imageWithContentsOfFile:filePath];
                [NIMBaseUtil cacheImage:orimage mid:recordEntity.messageId];
                CGSize chatSize = [SSIMSpUtil getChatImageSize:orimage];
                image = [SSIMSpUtil imageCompressForSize:orimage targetSize:chatSize];
            }
            E_MSG_E_TYPE imgType = recordEntity.ext;
            CGFloat bgH;
            if (image == nil) {
                if (imgType == WIDE_PICTURE) {//宽图
                    bgH = SCREEN_WIDTH*0.2;
                }else if (imgType == LONG_PICTURE){
                    bgH = SCREEN_WIDTH*0.4;
                }else{
                    bgH = SCREEN_WIDTH*0.4;
                }
            }else{
                bgH = image.size.height;
            }

            heightCell += bgH;
            heightCell += 10;

        }
            break;
        case VOICE:
        {
            heightCell += 50;
        }
            break;
        case SMILEY:
            heightCell += 70;
            break;
        case MAP:
            heightCell += 130;
            break;
        case VIDEO:
            heightCell += SCREEN_HEIGHT*0.4+10;
            break;
        case JSON:
        {
            switch (contentSubType) {
                
                case TIP:
                {
                    TextEntity *textEntity = recordEntity.textFile;
                    NSString* sbody = textEntity.text;
//                    NSDictionary *jsonDic = [NIMUtility jsonWithJsonString:sbody];
//                    NSString *desc = PUGetObjFromDict(@"desc", jsonDic, [NSString class]);
                   CGSize size =[NSString nim_getSizeFromString:sbody withFont:[UIFont systemFontOfSize:14] andLabelSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-kMarginTipText, CGFLOAT_MAX)];
                    CGFloat height = size.height;
//                    if (size.height<20) {
//                        //height = 20;
//                        heightCell += 10;
//
//                    }else{
//                        heightCell += 15;
//                    }
                    heightCell += 15;
                    heightCell += height;

                }
                    break;
                case VCARD:
                    heightCell += 90;
                    break;
                
                case ORDER:
                {
                    NSString* sbody = recordEntity.msgContent;
                    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
                    NSString *titleStr = [htmDic objectForKey:@"title"];
                    CGSize size =[NSString nim_getSizeFromString:titleStr withFont:[UIFont boldSystemFontOfSize:14] andLabelSize:CGSizeMake(kMaxWidthContent-21, 40)];
                    heightCell+=110+size.height;
                }
                    break;
                case ARTICLE:
                {
                    NSString* sbody = recordEntity.msgContent;;
                    NSDictionary *jsonDic = [NIMUtility jsonWithJsonString:sbody];
                    NSArray *items = [jsonDic objectForKey:@"items"];
                    heightCell+=200+(items.count-1)*60;

                }
                    break;
                    
                
                case GROUP_NEED_AGREE:
                case GROUP_ADD_AGREE:
                {
                    TextEntity *textEntity = recordEntity.textFile;

                    NSString* sbody = textEntity.text;
                    //                    NSDictionary *jsonDic = [NIMUtility jsonWithJsonString:sbody];
                    //                    NSString *desc = PUGetObjFromDict(@"desc", jsonDic, [NSString class]);
                    CGSize size =[NSString nim_getSizeFromString:sbody withFont:[UIFont systemFontOfSize:14] andLabelSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-kMarginTipText, CGFLOAT_MAX)];
                    CGFloat height = size.height;

                    heightCell += 15;
                    heightCell += height;


                }
                    break;
                    
                case RED_PACKET:
                {
                    heightCell += 110;
                }
                    break;
                case PRODUCT_TIP:
                {
                    heightCell += 80;
                }
                    break;
                case ORDER_TIP:
                {
                    heightCell += 170;
                }
                    break;

                
                default:
                    break;
            }
        }
            break;
        default:
            heightCell += 60;
            break;
    }
    
    return heightCell;
    
    
}
@end
