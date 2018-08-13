//
//  NIMRLeftImageCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftImageCell.h"
#import "ImageEntity+CoreDataClass.h"
#import "GTMBase64.h"
@implementation NIMRLeftImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    ImageEntity *imageEntity = recordEntity.imageFile;
    UIImage *image = nil;

    if (imageEntity.file) {
        
        NSString *fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",fullPath,imageEntity.file];
        image = [UIImage imageWithContentsOfFile:filePath];
        
        if (!image) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:recordEntity success:^(BOOL success) {
                    
                }];
            });
//            NSString *imageUrl = imageEntity.img;
//            [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (image) {
//                    [NIMBaseUtil cacheImage:image mid:recordEntity.messageId];
//                    
//                    CGSize chatSize = [SSIMSpUtil getChatImageSize:image];
//                    image = [SSIMSpUtil imageCompressForSize:image targetSize:chatSize];
//                    
//                    imageEntity.file = [NIMBaseUtil thumbImageDocMsgId:recordEntity.messageId];
//                    imageEntity.bigFile = [NIMBaseUtil bigImageDocMsgId:recordEntity.messageId];
//                    [[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] MR_saveToPersistentStoreAndWait];
//                }
//            }];
        }
        
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
//        NSString *imageUrl = imageEntity.img;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:recordEntity success:^(BOOL success) {
                
            }];
        });
//        [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                
//                [[SDImageCache sharedImageCache] removeImageForKey:imageUrl];
//
//                NSString *fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
//                
//                NSString *thumbImageDirectory = [NSString stringWithFormat:@"%@%@",fullPath,[NIMBaseUtil thumbImageDocMsgId:recordEntity.messageId]];
//                
//                if(![[NSFileManager defaultManager] fileExistsAtPath:thumbImageDirectory]){
//                    [NIMBaseUtil cacheImage:image mid:recordEntity.messageId];
//                    
//                    CGSize chatSize = [SSIMSpUtil getChatImageSize:image];
//                    image = [SSIMSpUtil imageCompressForSize:image targetSize:chatSize];
//                    
//                    imageEntity.file = [NIMBaseUtil thumbImageDocMsgId:recordEntity.messageId];
//                    imageEntity.bigFile = [NIMBaseUtil bigImageDocMsgId:recordEntity.messageId];
//                    [[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] MR_saveToPersistentStoreAndWait];
//                }
//                
//                
//            }
//        }];
    }

    CGSize imgSize = image.size;
    
    if (image!=nil) {
//        E_MSG_E_TYPE imgType = recordEntity.ext;
//        CGFloat bgH;
//        CGFloat bgW;
//        
//        if (imgType == WIDE_PICTURE) {//宽图
//            bgH = SCREEN_WIDTH*0.2;
//        }else{
//            bgH = SCREEN_HEIGHT*0.3;
//        }
//        bgW = bgH*imgSize.width/imgSize.height;
//        imgSize = CGSizeMake(bgW, bgH);
        self.iconView.image = [SSIMSpUtil imageCompressForSize:image targetSize:imgSize];
//        self.iconView.image = image;
    }else{
        E_MSG_E_TYPE imgType = recordEntity.ext;
        CGFloat bgH;
        CGFloat bgW = SCREEN_WIDTH*0.4;
        if (imgType == WIDE_PICTURE) {//宽图
            bgH = SCREEN_WIDTH*0.2;
        }else if (imgType == LONG_PICTURE){
            bgH = SCREEN_WIDTH*0.4;
            bgW = SCREEN_WIDTH*0.25;
        }else{
            bgH = SCREEN_WIDTH*0.4;
        }
        imgSize = CGSizeMake(bgW, bgH);
        self.iconView.image = [SSIMSpUtil imageCompressForSize:IMGGET(@"bg_dialog_pictures") targetSize:imgSize];
        
    }
    UIImage *img = IMGGET(@"nim_chat_bg_left");
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 10) resizingMode:UIImageResizingModeStretch];
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    maskView.image = img;
    self.iconView.maskView = maskView;
    self.paoButton.hidden = YES;
    
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
@end
