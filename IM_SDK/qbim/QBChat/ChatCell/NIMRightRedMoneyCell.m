//
//  NIMRightRedMoneyCell.m
//  QianbaoIM
//
//  Created by fengsh on 15/12/2.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMRightRedMoneyCell.h"

@implementation NIMRightRedMoneyCell

- (void)awakeFromNib {
     
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity
{
    [super updateWithRecordEntity:recordEntity];
    
    [self.iconView setImage:IMGGET(@"nim_redbag_nom")];
    
    /*
     UIImage *img = IMGGET(@"image_mask");
     CAShapeLayer *shape = [CAShapeLayer layer];
     shape.contents = (id)[img CGImage];
     shape.frame = CGRectMake(0, 0, 220, 100);
     self.iconView.layer.mask = shape;
     self.iconView.layer.masksToBounds = YES;
     
     CAShapeLayer *shape2 = [CAShapeLayer layer];
     shape2.contents = (id)[img CGImage];
     shape2.frame = CGRectMake(0.5, 0, 221, 101);
     self.maskView.layer.mask = shape2;
     self.maskView.layer.cornerRadius = 10;
     self.maskView.layer.masksToBounds = YES;
     */
    self.redmoneylogo.image = IMGGET(@"nim_redbag_key");
    self.paoButton.hidden = NO;
    
    NSString *detail = recordEntity.msgContent;
    NSData *dt = [detail dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:dt options:NSJSONReadingAllowFragments error:nil];
    
    if (dic) {
        self.redBagdesc.text = dic[@"desc"];
        NSString * redType = dic[@"type"];
        
        if ([redType isEqualToString:@"WORD"]) {
            self.redmoneylogo.hidden = NO;
            self.redBagType.text = @"领取口令红包";
            [self.iconView setImage:IMGGET(@"nim_redbag_lock")];
        }else if ([redType isEqualToString:@"LUCK"]){
            self.redmoneylogo.hidden = YES;
            self.redBagType.text = @"领取红包";
        }else{
            self.redmoneylogo.hidden = YES;
            self.redBagType.text = @"领取红包";
        }
    }
}

- (void)makeConstraints
{
    [super makeConstraints];

//    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.paoButton.mas_top).with.offset(-0.5);
//        make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(3);
//        make.size.mas_equalTo(CGSizeMake(232, 102));
//    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(0);
        make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(230, 100));
    }];
    
    [self.bubble mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(-3);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.avatarBtn.mas_centerY);
    }];
    
    [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarBtn.mas_top);
        make.trailing.equalTo(self.iconView.mas_leading).with.offset(0);
        make.leading.equalTo(self.iconView.mas_leading);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    
    [self.redmoneylogo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).offset(22);
        make.leading.equalTo(self.iconView.mas_leading).offset(50);
        make.width.equalTo(@10);
        make.height.equalTo(@15);
    }];
    
    [self.redBagdesc mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redmoneylogo.mas_top).offset(-6);
        make.leading.equalTo(self.redmoneylogo.mas_trailing).offset(5);
        make.trailing.equalTo(self.iconView.mas_trailing).offset(-15);
        make.height.equalTo(@25);
    }];
    
    [self.redBagType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redBagdesc.mas_bottom);
        make.leading.equalTo(self.redBagdesc.mas_leading);
        make.height.greaterThanOrEqualTo(@20);
        make.trailing.equalTo(self.redBagdesc.mas_trailing);
    }];
    
    [self.redBagSource mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-1);
        make.height.equalTo(@15);
        make.leading.equalTo(self.iconView.mas_leading).offset(10);
        make.trailing.equalTo(self.iconView.mas_trailing).offset(-10);
    }];
}

- (IBAction)recognizerHandler:(UIGestureRecognizer*)gesture
{
    
}

- (IBAction)tapRecognizerHandler:(UITapGestureRecognizer*)gesture
{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}

- (UIImageView *)redmoneylogo
{
    if (!_redmoneylogo) {
        _redmoneylogo = [[UIImageView alloc]init];
        [self.iconView addSubview:_redmoneylogo];
    }
    return _redmoneylogo;
}

- (UILabel *)redBagdesc
{
    if (!_redBagdesc) {
        _redBagdesc = [[UILabel alloc]init];
        _redBagdesc.textColor = [UIColor whiteColor];
        _redBagdesc.font = [UIFont boldSystemFontOfSize:16];
        [self.iconView addSubview:_redBagdesc];
    }
    return _redBagdesc;
}

- (UILabel *)redBagType
{
    if (!_redBagType) {
        _redBagType = [[UILabel alloc]init];
        _redBagType.textColor = [UIColor yellowColor];
        _redBagType.numberOfLines = 1;
        _redBagType.font = [UIFont systemFontOfSize:14];
        [self.iconView addSubview:_redBagType];
    }
    return _redBagType;
}

- (UILabel *)redBagSource
{
    if (!_redBagSource) {
        _redBagSource = [[UILabel alloc]init];
        _redBagSource.backgroundColor = [UIColor whiteColor];
        _redBagSource.textColor = [UIColor grayColor];
        _redBagSource.clipsToBounds = YES;
        _redBagSource.textAlignment = NSTextAlignmentLeft;
        _redBagSource.font = [UIFont systemFontOfSize:13];
        _redBagSource.text = @"钱宝红包";
        [self.iconView addSubview:_redBagSource];
    }
    return _redBagSource;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _iconView.backgroundColor = [UIColor blueColor];
        _iconView.userInteractionEnabled = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [_iconView addGestureRecognizer:self.tapGestureRecognizer];
        [_iconView addGestureRecognizer:self.longPressRecognizer];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}
- (UIImageView *)bubble{
    if (!_bubble) {
        _bubble = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubble.image = IMGGET(@"nim_bubble_right");
        _bubble.layer.cornerRadius = 5;
        [self.contentView addSubview:_bubble];
    }
    return _bubble;
}
@end
