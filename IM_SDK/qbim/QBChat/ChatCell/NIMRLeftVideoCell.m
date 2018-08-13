//
//  NIMRLeftVideoCell.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/27.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMRLeftVideoCell.h"
#import "UIImage+NIMEffects.h"
@implementation NIMRLeftVideoCell

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
    NSString *fullPath = [[NIMCoreDataManager currentCoreDataManager] recordPathMov];
    NSString *filePath = [NSString stringWithFormat:@"%@/%lld.jpg",fullPath,recordEntity.messageId];
    if ([[DFFileManager sharedInstance] checkLocalFile:filePath]) {
        image = [UIImage imageWithContentsOfFile:filePath];
    } else if (videoEntity.thumb) {
        image = [UIImage imageWithContentsOfFile:filePath];
    } else if (videoEntity.thumbUrl){
        NSString *imageUrl = [SSIMSpUtil holderImgURL:videoEntity.thumbUrl];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMGGET(@"bg_dialog_pictures") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [NIMBaseUtil cacheVideoThumb:image msgId:recordEntity.messageId];
            
            self.iconView.image = [SSIMSpUtil imageCompressForSize:image targetSize:imgSize];
            
            UIImage *img = IMGGET(@"nim_chat_bg_left");
            img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
            UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
            maskView.image = img;
            self.iconView.maskView = maskView;
            videoEntity.thumb = [NSString stringWithFormat:@"%lld.jpg",recordEntity.messageId];
            [[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] MR_saveToPersistentStoreAndWait];
            [self makeConstraints];
        }];
        
        
    } else if (videoEntity.file){
        NSString *fullPath = [[NIMCoreDataManager currentCoreDataManager] recordPathMov];
        NSString *filePath = [fullPath stringByAppendingPathComponent:videoEntity.file];
        image = [UIImage nim_getVideoPreViewImage:[NSURL fileURLWithPath:filePath]];
        if (image) {
            [NIMBaseUtil cacheVideoThumb:image msgId:recordEntity.messageId];
            videoEntity.thumb = [NIMBaseUtil videoThumbImageDocMsgId:recordEntity.messageId];
            [[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] MR_saveToPersistentStoreAndWait];
        }
    } else if (videoEntity.url){
        image = [UIImage nim_getVideoPreViewImage:[NSURL URLWithString:[SSIMSpUtil holderImgURL:videoEntity.url]]];
        if (image) {
            [NIMBaseUtil cacheVideoThumb:image msgId:recordEntity.messageId];
            videoEntity.thumb = [NIMBaseUtil videoThumbImageDocMsgId:recordEntity.messageId];
            [[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] MR_saveToPersistentStoreAndWait];
        }
    }
    if (image!=nil) {
        self.iconView.image = [SSIMSpUtil imageCompressForSize:image targetSize:imgSize];
    }else{
        self.iconView.image = [SSIMSpUtil imageCompressForSize:IMGGET(@"bg_dialog_pictures") targetSize:imgSize];
    }
    UIImage *img = IMGGET(@"nim_chat_bg_left");
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    maskView.image = img;
    self.iconView.maskView = maskView;
    self.paoButton.hidden = YES;
    self.playView.image = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"playVideo")];
}

- (void)makeConstraints{
    [super makeConstraints];
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(0);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.width.equalTo(@90);
            //            make.height.equalTo(@80);
        }];
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.width.equalTo(@90);
            //            make.height.equalTo(@80);
        }];
    }
    
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(-0.5);
        make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(9);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(1);
        //make.size.mas_equalTo(CGSizeMake(102, 82));
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top);
        make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
        make.bottom.equalTo(self.paoButton.mas_bottom).with.offset(0);
        // make.width.equalTo(@100);
        //        make.height.equalTo(@80);
    }];
    
    [self.playView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.centerX.mas_equalTo(self.iconView.mas_centerX);
        make.height.mas_equalTo(@(40));
        make.width.mas_equalTo(@(40));
    }];
    
}

#pragma mark actions
- (IBAction)tapRecognizerHandler:(UITapGestureRecognizer*)gesture
{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}

- (void)actionForward:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeForward];
}
#pragma mark Menu Notification
- (void)menuControllerDidHideMenuNotification:(NSNotification *)notification{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    BOOL isMenuVisible = menu.isMenuVisible;
    self.paoButton.selected = isMenuVisible;
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
            [menu setTargetRect:self.paoButton.frame inView:self.contentView];
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
