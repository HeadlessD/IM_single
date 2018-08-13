//
//  NIMRRightImageCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightImageCell.h"
#import "ImageEntity+CoreDataClass.h"

@implementation NIMRRightImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView addGestureRecognizer:self.longPressRecognizer];
    [self.iconView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    ImageEntity *imageEntity = recordEntity.imageFile;
    UIImage *image = nil;
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
        imageEntity.file = [NIMBaseUtil thumbImageDocMsgId:recordEntity.messageId];
        [[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] MR_saveToPersistentStoreAndWait];
        
    }else{
        NSString *imageUrl = [SSIMSpUtil holderImgURL:imageEntity.img];
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMGGET(@"bg_dialog_pictures") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [NIMBaseUtil cacheImage:image mid:recordEntity.messageId];

            CGSize chatSize = [SSIMSpUtil getChatImageSize:image];
            image = [SSIMSpUtil imageCompressForSize:image targetSize:chatSize];
            self.iconView.image = image;
            UIImage *img = IMGGET(@"image_mask_sender");
            img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(50,50, 50, 50) resizingMode:UIImageResizingModeStretch];
            UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            maskView.image = img;
            self.iconView.maskView = maskView;
            imageEntity.file = [NIMBaseUtil thumbImageDocMsgId:recordEntity.messageId];
            imageEntity.bigFile = [NIMBaseUtil bigImageDocMsgId:recordEntity.messageId];
            [[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] MR_saveToPersistentStoreAndWait];
        }];
    }
    
    
//    NSString *pro = [[NIMSysManager sharedInstance].progressDict objectForKey:[NSString stringWithFormat:@"%lld",recordEntity.messageId]];
//    
//    UIImage *blurImage = image;
//    
//    if (IsStrEmpty(pro) || [pro isEqualToString:@"1.00"]) {
//        self.bgView.hidden = YES;
//        blurImage = image;
//    }else {
//        self.bgView.hidden = NO;
//        [self.bgView setProgress:pro.floatValue animated:YES];
//        blurImage = [SSIMSpUtil blurImageWithImage:image];
//    }
    
//    self.iconView.image = blurImage;
    CGSize imgSize = image.size;
    
    if (image!=nil) {
//        E_MSG_E_TYPE imgType = recordEntity.ext;
//        CGFloat bgH;
//        CGFloat bgW;

//        if (imgType == WIDE_PICTURE) {//宽图
//            bgH = SCREEN_WIDTH*0.2;
//        }else{
//            bgH = SCREEN_HEIGHT*0.3;
//        }
//        bgW = bgH*imgSize.width/imgSize.height;
//        imgSize = CGSizeMake(bgW, bgH);
        self.iconView.image = [SSIMSpUtil imageCompressForSize:image targetSize:imgSize];
    }else{
        E_MSG_E_TYPE imgType = recordEntity.ext;
        CGFloat bgH;
        if (imgType == WIDE_PICTURE) {//宽图
            bgH = SCREEN_WIDTH*0.2;
        }else{
            bgH = SCREEN_HEIGHT*0.4;
        }
        CGFloat bgW = SCREEN_WIDTH*0.45;
        //CGFloat bgH = SCREEN_HEIGHT*0.3;
        imgSize = CGSizeMake(bgW, bgH);
        self.iconView.image = [SSIMSpUtil imageCompressForSize:IMGGET(@"bg_dialog_pictures") targetSize:imgSize];
        
    }

    UIImage *img = IMGGET(@"nim_chat_frame_right");
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    maskView.image = img;
    self.iconView.maskView = maskView;

    
//    CAShapeLayer *shape = [CAShapeLayer layer];
//    shape.contents = (id)[img CGImage];
//    shape.frame = CGRectMake(0, 0, 90, 80);
//    self.iconView.layer.mask = shape;
//    self.iconView.layer.masksToBounds = YES;
//    
//    CAShapeLayer *shape2 = [CAShapeLayer layer];
//    shape2.contents = (id)[img CGImage];
//    shape2.frame = CGRectMake(0.5, 0, 91, 81);
//    self.maskView.layer.mask = shape2;
//    self.maskView.layer.masksToBounds = YES;
    self.paoButton.hidden = YES;
//    CGRect rect = CGRectMake(0, 0, bgW, bgH);
//    self.frame = rect;
}
- (void)makeConstraints{
    [super makeConstraints];
    
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(-0.5);
        make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-9);
//        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-9);
//        make.width.equalTo(@102);
//        make.size.mas_equalTo(CGSizeMake(102, 82));
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(0);
        make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
//        make.size.mas_equalTo(CGSizeMake(100, 80));
        make.bottom.equalTo(self.paoButton.mas_bottom).with.offset(0);

    }];
    
    [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarBtn.mas_top);
        make.trailing.equalTo(self.iconView.mas_leading).with.offset(0);
        make.leading.equalTo(self.iconView.mas_leading);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(0);
    }];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.centerX.mas_equalTo(self.iconView.mas_centerX);
        make.height.mas_equalTo(@(30));
        make.width.mas_equalTo(@(30));
    }];
    
}

#pragma mark action
- (IBAction)tapRecognizerHandler:(UITapGestureRecognizer*)gesture
{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}

- (void)actionForward:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeForward];
}
#pragma mark UIGestureRecognizer
- (IBAction)recognizerHandler:(UIGestureRecognizer*)gesture
{
    NSArray *menuItems = self.menuItems;
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        self.paoButton.selected = YES;
        if (menuItems)
        {
            [self becomeFirstResponder];
            
            UIMenuController *menu = [UIMenuController sharedMenuController];
            menu.menuItems = menuItems;
            [menu setTargetRect:self.iconView.frame inView:self.contentView];
            [menu setMenuVisible:YES animated:YES];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(menuControllerDidHideMenuNotification:)
                                                         name:UIMenuControllerDidHideMenuNotification
                                                       object:nil];
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        
    }
}

#pragma mark getter
- (NSArray *)menuItems{
    if (!_menuItems) {
        _menuItems = @[kMenuItemForward];
    }
    return _menuItems;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.userInteractionEnabled = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [_iconView addGestureRecognizer:self.tapGestureRecognizer];
        [_iconView addGestureRecognizer:self.longPressRecognizer];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UIView*)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:CGRectZero];
        _maskView.backgroundColor = [SSIMSpUtil getColor:@"bbbbbb"];
        [self.contentView addSubview:_maskView];
    }
    return _maskView;
}


//- (UIView*)progressView{
//    if(!_progressView){
//        _progressView = [[UIView alloc]initWithFrame:CGRectZero];
//        _progressView.backgroundColor = kTipColor;
//        _progressView.userInteractionEnabled = YES;
//        [_progressView addGestureRecognizer:self.tapGestureRecognizer];
//        [_progressView addGestureRecognizer:self.longPressRecognizer];
//        [self.contentView addSubview:_progressView];
//    }
//    return _progressView;
//}


-(NIMInstallView *)bgView
{
    if (!_bgView) {
        _bgView = [[NIMInstallView alloc] initWithFrame:CGRectZero];
        _bgView.hidden = YES;
        _bgView.userInteractionEnabled = YES;
        _bgView.trackTintColor = [UIColor clearColor];
        _bgView.progressTintColor = [UIColor darkGrayColor];
        _bgView.thicknessRatio = 1.0f;
        
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

@end
