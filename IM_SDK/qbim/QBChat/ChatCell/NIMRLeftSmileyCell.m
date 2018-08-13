//
//  NIMRLeftSmileyCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftSmileyCell.h"
#import "TextEntity+CoreDataClass.h"
#import "NIMQBLabel.h"
#import "UIImage+NIMEffects.h"
@implementation NIMRLeftSmileyCell
- (void)awakeFromNib {
     
    [super awakeFromNib];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    TextEntity *textEntity = recordEntity.textFile;
    NSDictionary *smileyFile = [NIMQBLabel getBigFaceMap];
    NSString *imgFile = [NSString stringWithFormat:@"%@",[NIMQBLabel faceKeyForValue:textEntity.text map:smileyFile]];
    self.paoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [UIImage nim_animatedGIFNamed:imgFile];
//    [self.paoButton setImage:IMGGET(imgFile) forState:UIControlStateNormal];
    [self.paoButton setImage:image forState:UIControlStateNormal];


}
- (void)makeConstraints{
    [super makeConstraints];
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(10);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
    }
    
}

-(void)paoClick:(id)sender
{
    
}

#pragma mark actions
- (void)actionForward:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeForward];
}

#pragma mark getter
- (NSArray *)menuItems{
    if (!_menuItems) {
        _menuItems = @[kMenuItemForward];
    }
    return _menuItems;
}
- (UIButton *)paoButton{
    if (!_paoButton) {
        _paoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_paoButton addTarget:self action:@selector(paoClick:) forControlEvents:UIControlEventTouchUpInside];
        [_paoButton addGestureRecognizer:self.longPressRecognizer];
        [self.contentView addSubview:_paoButton];
    }
    return _paoButton;
}

@end
