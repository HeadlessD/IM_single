//
//  NIMChatMediaView.m
//  QianbaoIM
//
//  Created by liyan on 14-3-31.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMChatMediaView.h"
//#import "NIMMessageCenter.h"
//#import "NIMLoginOperationBox.h"

#define kChatMediaIconWH          40
#define kChatMediaBacViewWH       60
#define kChatMediaButtonWH        80

#define kChatMediaButtonWOff     0
#define kChatMediaButtonHOff     0
#define kChatMediaButtonsOneLine 4

#define kEmoji NSLocalizedString(@"表情",         @"emoji")
#define kPhoto NSLocalizedString(@"照相机",       @"capture photo")
#define kLocalPhoto NSLocalizedString(@"图片",    @"local photo")
#define kLocation NSLocalizedString(@"位置",      @"location")
#define kVcard NSLocalizedString(@"名片",         @"vcard")
#define kRedMoney NSLocalizedString(@"红包",      @"redmoney")
#define kFavorite NSLocalizedString(@"我的收藏",   @"Myfavorite")
#define kOrder NSLocalizedString(@"订单",   @"Order")
#define kVideo NSLocalizedString(@"小视频",       @"capture video")


struct ChatMediaData {
    int        tag;
    __unsafe_unretained NSString * title;
    __unsafe_unretained NSString * icon;
};


@interface ChatMediaButton : UIButton
{
    
}
@property (nonatomic, strong) UILabel     * labelTitle;
@property (nonatomic, strong) UIImageView      * imageBacView;
@property (nonatomic, strong) UIImageView * imageIcon;

@end

@implementation ChatMediaButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.exclusiveTouch = YES;
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textColor       = [SSIMSpUtil getColor:@"888888"];
        _labelTitle.textAlignment   = NSTextAlignmentCenter;
        _labelTitle.font            = [UIFont systemFontOfSize:14];
        [self addSubview:_labelTitle];
        
        //        _imageBacView
        
        _imageBacView = [[UIImageView alloc] init];
        _imageBacView.backgroundColor  = [UIColor whiteColor];
        _imageBacView.contentMode = UIViewContentModeScaleAspectFit;
        _imageBacView.layer.cornerRadius = 10.0;
        _imageBacView.layer.masksToBounds = YES;
        //        _imageBacView.userInteractionEnabled = YES;
        
        _imageIcon = [[UIImageView alloc]init];
        _imageIcon.backgroundColor = [UIColor clearColor];
        //        _imageIcon.userInteractionEnabled = YES;
        
        CALayer *layer = [_imageBacView layer];
        layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:0.5] CGColor];
        layer.borderWidth = 1.0f;
        
        [_imageBacView addSubview:_imageIcon];
        [self addSubview:_imageBacView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect superRect = self.bounds;
    
    _imageBacView.frame  = CGRectMake((kChatMediaButtonWH-kChatMediaBacViewWH)/2,(kChatMediaButtonWH-kChatMediaBacViewWH)/2,kChatMediaBacViewWH, kChatMediaBacViewWH);
    _imageIcon.frame = CGRectMake((kChatMediaBacViewWH - kChatMediaIconWH)/2,(kChatMediaBacViewWH - kChatMediaIconWH)/2, kChatMediaIconWH, kChatMediaIconWH);
    _labelTitle.frame = CGRectMake(0, CGRectGetMaxY(_imageBacView.frame)+5, superRect.size.width, 20);
}

@end

@implementation NIMChatMediaView

@synthesize delegate;
@synthesize isSubView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.userInteractionEnabled = YES;
        self.clipsToBounds          = YES;
    }
    return self;
}


-(void)resetUIWithChatUIType:(NSInteger)chatUIType{
    NSMutableArray * chatUIArr = [NSMutableArray array];
  
    [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeImage],kLocalPhoto, @"im_picture",]];
    [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeCamera],kPhoto, @"im_camera",]];
    [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeVideo],kVideo, @"video",]];
    if (chatUIType == NIMChatUIType_NORMAL){//普通聊天
        [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeLocation],kLocation, @"im_location",]];
        [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeVCard],kVcard, @"im_userCard",]];
        [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeRedMoney],kRedMoney, @"im_redPackets",]];
        [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeFavorites],kFavorite, @"im_collect",]];
    }else if (chatUIType == NIMChatUIType_BUSINESS){//个人商家
        [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeLocation],kLocation, @"im_location",]];
        [chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeVCard],kVcard, @"im_userCard",]];
        //[chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeOrder],kOrder, @"im_order",]];

    }else if (chatUIType == NIMChatUIType_OFFCIAL){//企业商家，公众号
        //[chatUIArr addObject:@[[NSString stringWithFormat:@"%d",ChatMediaTypeOrder],kOrder, @"im_order",]];
    }
    [self creatUIwith:chatUIArr];
}

-(void)creatUIwith:(NSArray *)chatmediaArr{
    
    //    UIImage * imageO = nil;
    //    UIImage * image1 = IMGGET(@"bg_on");
    //    CGFloat wsss = ceilf(CGRectGetWidth(self.frame)/4);
    
    for (int i = 0; i < chatmediaArr.count; ++i)
    {
//        int posx = i % kChatMediaButtonsOneLine;
//        int posy = i / kChatMediaButtonsOneLine;
//        int x  = floor(posx * (ceilf(CGRectGetWidth(self.frame)/4) + kChatMediaButtonWOff));
//        int y  = floor(posy * (kChatMediaButtonH + kChatMediaButtonHOff));
//
//        NSArray * singleArr = chatmediaArr[i];
        
        
        int jg = ((SCREEN_WIDTH - 30) - kChatMediaButtonWH * kChatMediaButtonsOneLine)/5;
        
        int posx = i % kChatMediaButtonsOneLine;
        int posy = i / kChatMediaButtonsOneLine;
        
        int x  = floor(posx * kChatMediaButtonWH + ((posx+1) * jg));
        
        int y  = 10 + floor(posy * kChatMediaButtonWH + ((posy) * 15));
        
        NSArray * singleArr = chatmediaArr[i];
        
        ChatMediaButton * button = [[ChatMediaButton alloc] init];
        [button setFrame:CGRectMake(15 + x, y,kChatMediaButtonWH, kChatMediaButtonWH)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setBackgroundImage:IMGGET(@"bg_on") forState:UIControlStateHighlighted];
        [button setTag:[singleArr[0] intValue]];
        button.labelTitle.text = NSLocalizedString(singleArr[1],singleArr[1]);
        button.imageIcon.image = IMGGET(singleArr[2]);
        button.exclusiveTouch = YES;
        [button addTarget:self action:@selector(buttonBeenClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.49)];
    [lineView setBackgroundColor:[SSIMSpUtil getColor:@"dcdcdc"]];
    [self addSubview:lineView];
}

- (void)buttonBeenClicked:(ChatMediaButton *)button
{
    if ([delegate respondsToSelector:@selector(ChatMediaView:buttonBeenClicked:)])
    {
        [delegate ChatMediaView:self buttonBeenClicked:button.tag];
    }
}

@end
