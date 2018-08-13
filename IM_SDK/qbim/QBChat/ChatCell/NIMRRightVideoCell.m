//
//  NIMRRightVideoCell.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/27.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMRRightVideoCell.h"

@implementation NIMRRightVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView addGestureRecognizer:self.longPressRecognizer];
    [self.iconView addGestureRecognizer:self.tapGestureRecognizer];
}

-(void)updateWithRecordEntity:(ChatEntity *)recordEntity
{
    [super updateWithRecordEntity:recordEntity];
    CGFloat imageW = SCREEN_WIDTH*0.45;
    CGFloat imageH = SCREEN_HEIGHT*0.4;
    CGSize imgSize = CGSizeMake(imageW, imageH);
    VideoEntity *videoEntity = recordEntity.videoFile;
    UIImage *image = nil;
    if (videoEntity.thumb) {
        
        NSString *fullPath = [[NIMCoreDataManager currentCoreDataManager] recordPathMov];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",fullPath,videoEntity.thumb];
        image = [UIImage imageWithContentsOfFile:filePath];
        if (image == nil) {
            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:nil];
        }
        
    } else if (videoEntity.thumbUrl){
        NSString *imageUrl = [SSIMSpUtil holderImgURL:videoEntity.thumbUrl];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMGGET(@"bg_dialog_pictures") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [NIMBaseUtil cacheVideoThumb:image msgId:recordEntity.messageId];
            
            self.iconView.image = image;
            UIImage *img = IMGGET(@"image_mask_sender");
            img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(50,50, 50, 50) resizingMode:UIImageResizingModeStretch];
            UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
            maskView.image = img;
            self.iconView.maskView = maskView;
            videoEntity.thumb = [NIMBaseUtil videoThumbImageDocMsgId:recordEntity.messageId];
            [[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] MR_saveToPersistentStoreAndWait];
        }];
    
        
    }else{
        
    }
    if (image!=nil) {
        self.iconView.image = [SSIMSpUtil imageCompressForSize:image targetSize:imgSize];
    }else{
        self.iconView.image = [SSIMSpUtil imageCompressForSize:IMGGET(@"bg_dialog_pictures") targetSize:imgSize];
    }
    UIImage *img = IMGGET(@"nim_chat_frame_right");
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    maskView.image = img;
    self.iconView.maskView = maskView;
    self.paoButton.hidden = YES;
    self.playView.image = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"playVideo")];
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
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.45, SCREEN_HEIGHT*0.4));
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
    
    [self.playView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.centerX.mas_equalTo(self.iconView.mas_centerX);
        make.height.mas_equalTo(@(40));
        make.width.mas_equalTo(@(40));
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

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.playView) {
        return self.iconView;
    }
    return view;
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

- (UIImageView *)playView{
    if (!_playView) {
        _playView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _playView.userInteractionEnabled = YES;
        _playView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_playView];
    }
    return _playView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
