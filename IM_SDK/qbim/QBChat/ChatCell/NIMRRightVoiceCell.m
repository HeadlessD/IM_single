//
//  NIMRRightVoiceCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightVoiceCell.h"
#import "AudioEntity+CoreDataClass.h"
//#import "NIMOperationBox.h"



@interface NIMRRightVoiceCell ()
@property (nonatomic, strong) NSArray *voiceImages;

@end

@implementation NIMRRightVoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.paoButton addGestureRecognizer:self.longPressRecognizer];
    [self.iconView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    AudioEntity *audioEntity = recordEntity.audioFile;
    if(!audioEntity.file)
    {
        [self.indicatorView startAnimating];
        [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:self.recordEntity success:^(BOOL success) {
            
        }];
    }else{
        [self.indicatorView stopAnimating];
        NSString *time = nil;
        CGFloat width = kDefaultWidth;
        CGFloat totalW = [UIApplication sharedApplication].keyWindow.frame.size.width;
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
        [self setPaoButtonWidth:width];
        self.timeLabel.text = time;
    }
    QIMAudioStatu audioStatu = audioEntity.state;
    if (audioStatu == QIMMessageStatuPlaying) {
        [self.iconView startAnimating];
    }else{
        [self.iconView stopAnimating];
    }
    
}

- (void)setPaoButtonWidth:(CGFloat)width{
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.with.offset(width);
        }];
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
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
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-20);
        make.width.equalTo(@12);
//        make.height.equalTo(@20);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(self.iconView.mas_height);
    }];
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(10);
        make.centerX.equalTo(self.timeLabel.mas_centerX);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
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
        _voiceImages = @[IMGGET(@"icon_dialog_voice_right01"),IMGGET(@"icon_dialog_voice_right02"),IMGGET(@"icon_dialog_voice_right03")];
    }
    return _voiceImages;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:IMGGET(@"icon_dialog_voice_right03")];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.userInteractionEnabled = NO;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.animationDuration = 1;
        _iconView.animationImages = self.voiceImages;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _timeLabel.numberOfLines = 1;
        _timeLabel.textColor = [UIColor whiteColor];
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
