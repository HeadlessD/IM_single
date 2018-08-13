//
//  NIMRRightTextCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightTextCell.h"
#import "TextEntity+CoreDataClass.h"
//#import "OHASMarkupParserManager.h"

@implementation NIMRRightTextCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.plaintextLabel addGestureRecognizer:self.longPressRecognizer];
    
}
-(void)enableText
{
    self.plaintextLabel.enabled = NO;
}
-(void)unEnableText
{
    self.plaintextLabel.enabled = YES;
}
- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enableText) name:@"IS_LINCK_BEGINLONGPRESS" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unEnableText) name:@"IS_LINCK_ENDLONGPRESS" object:nil];
    
    [super updateWithRecordEntity:recordEntity];
    TextEntity *textEntity = recordEntity.textFile;
    self.plaintextLabel.text = textEntity.text;
    
    
    [self makeConstraints];
}

- (void)paoClick:(id)sender{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    BOOL isMenuVisible = menu.isMenuVisible;
    if (isMenuVisible) {
        return;
    }
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}

- (void)makeConstraints{
    [super makeConstraints];
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(4);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.width.lessThanOrEqualTo([NSNumber numberWithFloat:CGRectGetWidth([UIScreen mainScreen].bounds) - 120]);
        }];
        
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.width.lessThanOrEqualTo([NSNumber numberWithFloat:CGRectGetWidth([UIScreen mainScreen].bounds) - 120]);
        }];
    }
    [self.plaintextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(10);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(10);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-20);
        //刚好有一个\n在最大行宽度后面时，会有飘移，因此加上这句
        CGSize size = [self.plaintextLabel preferredSizeWithMaxWidth:kMaxWidthContent];
        size.width += 2;
        make.width.greaterThanOrEqualTo(@(size.width));
        make.height.greaterThanOrEqualTo(@20);
        
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
        _plaintextLabel.textColor = [UIColor whiteColor];
        _plaintextLabel.emojiDelegate = self;
        [_plaintextLabel addGestureRecognizer:self.longPressRecognizer];
        
        _plaintextLabel.frame = CGRectMake(0, 0, 160, 100);
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
