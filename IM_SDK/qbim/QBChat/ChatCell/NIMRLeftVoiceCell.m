//
//  NIMRLeftVoiceCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftVoiceCell.h"
#import "AudioEntity+CoreDataClass.h"
//#import "NIMOperationBox.h"

@interface NIMRLeftVoiceCell ()
@property (nonatomic, strong) NSArray *voiceImages;
@end

@implementation NIMRLeftVoiceCell
- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    CGFloat width = kDefaultWidth;
    CGFloat totalW = [UIApplication sharedApplication].keyWindow.frame.size.width;
    [super updateWithRecordEntity:recordEntity];
    AudioEntity *audioEntity = recordEntity.audioFile;
    DBLog(@"file:%@ url:%@ duration:%d, read:%d",audioEntity.file,audioEntity.url,audioEntity.duration,audioEntity.read);
    NSString *time = nil;
    if(!audioEntity.file)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%d \"",audioEntity.duration];
        
        if (audioEntity.duration >59) {
            time =@"60 '";
            width = kDefaultWidth + (totalW-kDefaultWidth)*0.6;
        }
        else
        {
            time =[NSString stringWithFormat:@"%d \"",audioEntity.duration];
            width = (audioEntity.duration/60.0)*((totalW-kDefaultWidth)*0.6)+kDefaultWidth;
            if(width<kDefaultWidth)
                width = kDefaultWidth;
        }
        [self setPaoButtonWidth:width];
    }else{
        [self.indicatorView stopAnimating];
        if (audioEntity.duration >59) {
            time =@"60 \"";
            width = kDefaultWidth + (totalW-kDefaultWidth)*0.6;
        }
        else
        {
            time =[NSString stringWithFormat:@"%d \"",audioEntity.duration];
            width = (audioEntity.duration/60.0)*((totalW-kDefaultWidth)*0.6)+kDefaultWidth;
            if(width<kDefaultWidth)
                width = kDefaultWidth;
        }
        self.timeLabel.text = time;
        [self setPaoButtonWidth:width];
    }
    QIMAudioStatu audioStatu = audioEntity.state;
    if (audioStatu == QIMMessageStatuPlaying) {
        [self.iconView startAnimating];
    }else{
        [self.iconView stopAnimating];
    }
    self.signView.hidden = audioEntity.read;
        
}
- (void)setPaoButtonWidth:(CGFloat)width{
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(5);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.width.with.offset(width);
        }];
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.width.with.offset(width);
        }];
    }
}
- (void)makeConstraints{
    [super makeConstraints];
    
    [self setPaoButtonWidth:kDefaultWidth];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(10);
        make.bottom.equalTo(self.paoButton.mas_bottom).with.offset(-10);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(20);
        make.width.equalTo(@12);
//        make.height.equalTo(@20);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-10);
        make.width.equalTo(@30);
        make.height.equalTo(self.iconView.mas_height);
    }];
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(10);
        make.centerX.equalTo(self.timeLabel.mas_centerX);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.signView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.paoButton.mas_trailing).with.offset(10);
        make.centerY.equalTo(self.paoButton.mas_centerY);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
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

-(void)actionVoice:(id)sender
{
    BOOL isEarphone = [getObjectFromUserDefault(KEY_Earphone) boolValue];
    if (isEarphone) {
        _menuItems = @[kMenuItemReceiver];
    }else{
        _menuItems = @[kMenuItemSpeaker];

    }
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeVoice];
}

- (void)paoClick:(id)sender{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    BOOL isMenuVisible = menu.isMenuVisible;
    if (isMenuVisible) {
        return;
    }
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}
#pragma mark getter
- (NSArray *)menuItems{
    BOOL isEarphone = [getObjectFromUserDefault(KEY_Earphone) boolValue];
    if (isEarphone) {
        _menuItems = @[kMenuItemSpeaker];
    }else{
        _menuItems = @[kMenuItemReceiver];
        
    }
    return _menuItems;
}
- (NSArray *)voiceImages{
    if (!_voiceImages) {
        _voiceImages = @[IMGGET(@"icon_dialog_voice_left01"),IMGGET(@"icon_dialog_voice_left02"),IMGGET(@"icon_dialog_voice_left03")];
    }
    return _voiceImages;
}
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:IMGGET(@"icon_dialog_voice_left03")];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.userInteractionEnabled = NO;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.animationDuration = 1;
        _iconView.animationImages = self.voiceImages;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UIImageView *)signView{
    if (!_signView) {
        _signView = [[UIImageView alloc] initWithImage:IMGGET(@"icon_dialog_new-_small")];
        _signView.backgroundColor = [UIColor clearColor];
        _signView.userInteractionEnabled = YES;
        _signView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_signView];
    }
    return _signView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.numberOfLines = 1;
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}
- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
        [self.contentView addSubview:_indicatorView];
    }
    return _indicatorView;
}
@end
