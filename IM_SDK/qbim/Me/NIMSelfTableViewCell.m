//
//  NIMSelfTableViewCell.m
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/8.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMSelfTableViewCell.h"

@implementation NIMSelfTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"jinru");
    //    [self.contentView addSubview:self.leLocationLaebel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)getViewModelWithIndex:(NSIndexPath *)indexPath withVcard:(VcardEntity *)vcard{

    NSArray * titleArr = @[@"地区",@"来源",@"照片墙",@"个性签名"];
    self.titleLabel.text = titleArr[indexPath.section];
    [self.contentView addSubview:self.titleLabel];
    
    NSArray * contentArr = @[@"暂未填写所在地",@"未知添加来源",@"照片墙",@"暂无简介"];
    self.contentLabel.text = contentArr[indexPath.section];
    [self.contentView addSubview:self.contentLabel];

    if (indexPath.section == 2) {
        switch (_pics.count) {
            case 0:
            {
                self.picView1.hidden = YES;
                self.picView2.hidden = YES;
                self.picView3.hidden = YES;
            }
                break;
            case 1:
            {
                [self.picView1 sd_setImageWithURL:[NSURL URLWithString:self.pics.firstObject] placeholderImage:USER_ICON_DEFAULT];
                self.picView1.hidden = NO;
                self.picView2.hidden = YES;
                self.picView3.hidden = YES;
            }
                break;
            case 2:
            {
                [self.picView1 sd_setImageWithURL:[NSURL URLWithString:self.pics.firstObject] placeholderImage:USER_ICON_DEFAULT];
                [self.picView2 sd_setImageWithURL:[NSURL URLWithString:self.pics.lastObject] placeholderImage:USER_ICON_DEFAULT];

                self.picView1.hidden = NO;
                self.picView2.hidden = NO;
                self.picView3.hidden = YES;
            }
                break;
            case 3:
            {
                self.picView1.hidden = NO;
                self.picView2.hidden = NO;
                self.picView3.hidden = NO;
                [self.picView1 sd_setImageWithURL:[NSURL URLWithString:self.pics[0]] placeholderImage:USER_ICON_DEFAULT];
                [self.picView2 sd_setImageWithURL:[NSURL URLWithString:self.pics[1]] placeholderImage:USER_ICON_DEFAULT];
                [self.picView3 sd_setImageWithURL:[NSURL URLWithString:self.pics[2]] placeholderImage:USER_ICON_DEFAULT];
            }
                break;
                
            default:
                break;
        }
        _contentLabel.hidden = YES;
        [self.contentView addSubview:self.picView1];
        [self.contentView addSubview:self.picView2];
        [self.contentView addSubview:self.picView3];
        [self changePicViewMas];
    }
    [self creatMas];
}

-(void)creatMas{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(@80);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.equalTo(self.titleLabel.mas_bottom);
    }];
}

-(void)changePicViewMas{
    [self.picView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(self.picView1.mas_height);
    }];
    [self.picView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView1.mas_top);
        make.left.equalTo(self.picView1.mas_right).offset(10);
        make.width.equalTo(self.picView1.mas_height);
        make.height.equalTo(self.picView1.mas_height);
    }];
    [self.picView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView2.mas_top);
        make.left.equalTo(self.picView2.mas_right).offset(10);
        make.width.equalTo(self.picView2.mas_height);
        make.height.equalTo(self.picView2.mas_height);
    }];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16 * ScreenScale];

    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:16 * ScreenScale];
    }
    return _contentLabel;
}

-(UIImageView *)picView1{
    if (!_picView1) {
        _picView1 = [[UIImageView alloc]init];
        _picView1.backgroundColor = [UIColor blueColor];
        _picView1.layer.cornerRadius = 10;
        _picView1.clipsToBounds = YES;
        _picView1.userInteractionEnabled = YES;
    }
    return _picView1;
}

-(UIImageView *)picView2{
    if (!_picView2) {
        _picView2 = [[UIImageView alloc]init];
        _picView2.backgroundColor = [UIColor blueColor];
        _picView2.layer.cornerRadius = 10;
        _picView2.clipsToBounds = YES;
        _picView2.userInteractionEnabled = YES;
    }
    return _picView2;
}

-(UIImageView *)picView3{
    if (!_picView3) {
        _picView3 = [[UIImageView alloc]init];
        _picView3.backgroundColor = [UIColor blueColor];
        _picView3.layer.cornerRadius = 10;
        _picView3.clipsToBounds = YES;
        _picView3.userInteractionEnabled = YES;
    }
    return _picView3;
}

-(NSArray *)pics
{
    if (!_pics) {
        _pics = [[NSArray alloc] init];
    }
    return _pics;
}

@end
