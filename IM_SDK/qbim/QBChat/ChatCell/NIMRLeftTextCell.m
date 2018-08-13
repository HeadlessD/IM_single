//
//  NIMRLeftTextCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftTextCell.h"
#import "TextEntity+CoreDataClass.h"

@interface NIMRLeftTextCell ()

@end

@implementation NIMRLeftTextCell
- (void)awakeFromNib {
     
    [super awakeFromNib];

}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enableText) name:@"IS_LINCK_BEGINLONGPRESS" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unEnableText) name:@"IS_LINCK_ENDLONGPRESS" object:nil];
    [super updateWithRecordEntity:recordEntity];
    TextEntity *textEntity = recordEntity.textFile;

    self.plaintextLabel.text = textEntity.text;
}

-(void)enableText
{
    self.plaintextLabel.enabled = NO;
}
-(void)unEnableText
{
    self.plaintextLabel.enabled = YES;
}

- (void)makeConstraints{
    [super makeConstraints];
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(4);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
//            make.trailing.equalTo(self.plaintextLabel.mas_trailing).with.offset(10);
            make.width.lessThanOrEqualTo([NSNumber numberWithFloat:CGRectGetWidth([UIScreen mainScreen].bounds) - 120]);
        }];
        
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.width.lessThanOrEqualTo([NSNumber numberWithFloat:CGRectGetWidth([UIScreen mainScreen].bounds) - 120]);
        }];
    }
    
    [self.plaintextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(10);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(20);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-10);
        make.height.greaterThanOrEqualTo(@20);
//        make.bottom.equalTo(self.paoButton.mas_bottom).with.offset(-10);
    }];
}
#pragma mark actions
- (void)actionCopy:(id)sender{
    [super actionCopy:sender];
}

- (void)actionForward:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeForward];
}

#pragma mark getter
- (NSArray *)menuItems{
    if (!_menuItems) {
        _menuItems = @[kMenuItemCopy,kMenuItemForward];
    }
    return _menuItems;
}

- (MLEmojiLabel *)plaintextLabel{
    
    if(!_plaintextLabel)
    {
        _plaintextLabel = [[MLEmojiLabel alloc]initWithFrame:CGRectZero];
        _plaintextLabel.numberOfLines = 0;
        _plaintextLabel.font =[UIFont systemFontOfSize:16];
        _plaintextLabel.backgroundColor = [UIColor clearColor];
        _plaintextLabel.textColor = [SSIMSpUtil getColor:@"262626"];
        _plaintextLabel.emojiDelegate = self;
        [_plaintextLabel addGestureRecognizer:self.longPressRecognizer];
        [self.contentView addSubview:_plaintextLabel];
    }
    _plaintextLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _plaintextLabel.customEmojiPlistName = @"faceMapQQNew.plist";
    return _plaintextLabel;
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type{
    if(_delegate && [_delegate respondsToSelector:@selector(chatTableViewCell:didSelectStr:withType:)]){
        [_delegate chatTableViewCell:self didSelectStr:link withType:type];
    }
}
@end
