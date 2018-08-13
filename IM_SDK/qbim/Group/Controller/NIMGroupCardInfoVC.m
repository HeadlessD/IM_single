//
//  NNIMGroupCardInfoVC.m
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-12.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMGroupCardInfoVC.h"
#import "NIMMessageCenter.h"
#import "VcardEntity+CoreDataClass.h"
#import "NIMGroupUserIcon.h"
#import "GroupList+CoreDataClass.h"
#import "NIMGroupOperationBox.h"
#import "GMember+CoreDataClass.h"
#import "SDWebImageManager.h"

@interface NIMGroupCardInfoVC ()

@property (nonatomic,copy) NSString *groupName;

@property (nonatomic,assign) int64_t groupId;


@property (nonatomic, strong)UIImageView     *cardImageView;

@property (nonatomic, strong)UIView          *cardImageViewPanel;
@property (nonatomic, strong)NIMGroupUserIcon     *avatarView;
@property (nonatomic, strong)UILabel         *nickNameLabel;


@end

@implementation NIMGroupCardInfoVC

- (id)initWithGroupName:(NSString *)groupName groupIp:(int64_t)groupId
{
    self = [super init];
    
    if(self)
    {
        self.groupName  = groupName;
        self.groupId    = groupId;
    }
    
    return self;
}


- (void)dealloc
{
    _IM_RELEASE_SAFELY(_groupName);
    _IM_RELEASE_SAFELY(_groupId);
    _IM_RELEASE_SAFELY(_cardImageViewPanel);
    _IM_RELEASE_SAFELY(_nickNameLabel);
    _IM_RELEASE_SAFELY(_cardImageView);
    _IM_SUPER_DEALLOC();
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self qb_setTitleText:@"二维码名片"];
    self.view.backgroundColor = [SSIMSpUtil getColor:@"EEEEEE"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self drawView];
}

- (void)drawView{
//    self.cardImageViewPanel.hidden = YES;
    [self.view addSubview:self.cardImageViewPanel];
    self.cardImageViewPanel.center = _CGP(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds) - 10);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.cardImageViewPanel.frame), CGRectGetWidth(self.cardImageViewPanel.frame))];
    [bgView setBackgroundColor:[SSIMSpUtil getColor:@"f0f0f0"]];
    [self.cardImageViewPanel addSubview:bgView];
    
    [self.cardImageViewPanel addSubview:self.cardImageView];
    
    UILabel * nicknameLabel = [[UILabel alloc]initWithFrame:_CGR(70, CGRectGetMinY(self.avatarView.frame), CGRectGetWidth(self.cardImageView.frame) - 70, 25)];
    _CLEAR_BACKGROUND_COLOR_(nicknameLabel);
    nicknameLabel.font = FONT_TITLE(15);
    nicknameLabel.textAlignment = NSTextAlignmentLeft;
    nicknameLabel.textColor = [UIColor blackColor];
    self.nickNameLabel = nicknameLabel;
    self.nickNameLabel.text = self.groupName;
    [self.cardImageViewPanel addSubview:self.nickNameLabel];
    
    [self.cardImageViewPanel addSubview:self.avatarView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:_CGR(CGRectGetMinX(nicknameLabel.frame), CGRectGetMaxY(nicknameLabel.frame), CGRectGetWidth(nicknameLabel.frame), 25)];
    _CLEAR_BACKGROUND_COLOR_(label);
    label.font = FONT_TITLE(12);
    label.textColor = [SSIMSpUtil getColor:@"252527"];
    label.text = @"扫一扫二维码，加入该群";
    label.textAlignment = NSTextAlignmentLeft;
    [self.cardImageViewPanel addSubview:label];
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    logoView.image = IMGGET(@"icon_2d.png");
    [self.cardImageViewPanel addSubview:logoView];
    logoView.center = self.cardImageView.center;
//    logoView.alpha = 0.1;
//    self.cardImageView.image = img;
    [self loadQRImageWithString:_IM_FormatStr(@"http://t.iqr.cc/JjuAJ3?group=%lld_%lld",self.groupId,OWNERID)];
    
    //http://www.qbao.com/appdownload.html
    //https://itunes.apple.com/cn/app/id635137456
    [self.avatarView setViewDataSourceFromUrlString:GROUP_ICON_URL(self.groupId)];
    self.cardImageViewPanel.layer.borderColor = [SSIMSpUtil getColor:@"cccccc"].CGColor;
    self.cardImageViewPanel.layer.borderWidth = 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });}

- (void)loadQRImageWithString:(NSString *)qrString{
    
    CGFloat size = CGRectGetWidth(self.cardImageViewPanel.frame) - 44;
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGRect extent = CGRectIntegral(qrFilter.outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:qrFilter.outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    self.cardImageView.image = [UIImage imageWithCGImage:scaledImage];
}



- (UIImage *)createQRForString:(NSString *)qrString withSize:(CGFloat) size {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGRect extent = CGRectIntegral(qrFilter.outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:qrFilter.outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (void)backPop
{
    [SSIMSpUtil popVC:self animated:YES];
}

- (void)copyGroupURL
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = [NSString stringWithFormat:@"im.qbao.com://group:%lld",self.groupId];
    [MBTip showTipsView:@"已复制到粘贴板" atView:self.view];
}


_GETTER_BEGIN(UIImageView, cardImageView)
{
    _cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 22, CGRectGetWidth(self.cardImageViewPanel.frame) - 44, CGRectGetWidth(self.cardImageViewPanel.frame) - 44)];
    _cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    _cardImageView.backgroundColor = [UIColor whiteColor];
//    _cardImageView.alpha = 0.1;
    
}
_GETTER_END(cardImageView)


_GETTER_BEGIN(NIMGroupUserIcon, avatarView)
{
    _avatarView = [[NIMGroupUserIcon alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cardImageView.frame)+ 32, 50, 50)];
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarView.layer.cornerRadius = 2;
    _avatarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _avatarView.clipsToBounds = YES;

}
_GETTER_END(avatarView)

_GETTER_BEGIN(UIView, cardImageViewPanel)
{
    CGRect frame = CGRectZero;
    
    
    
    int w = CGRectGetWidth(self.view.bounds) - 50;
    int h = w + 70;
    frame.size = CGSizeMake(w, h);
    
    _cardImageViewPanel = [[UIView alloc]initWithFrame:frame];
    _cardImageViewPanel.backgroundColor = [UIColor whiteColor];
}
_GETTER_END(cardImageViewPanel)

@end
