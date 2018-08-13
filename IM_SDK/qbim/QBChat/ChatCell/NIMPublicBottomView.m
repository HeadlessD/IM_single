//
//  NIMPublicBottomView.m
//  QianbaoIM
//
//  Created by 徐庆 on 15/7/11.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicBottomView.h"
@interface NIMPublicBottomView ()
@property (nonatomic, strong) UIImageView   *headerView;
@property (nonatomic, strong) UIButton      *enterBtn;
@property (nonatomic, strong) UIButton      *showBtn;
@property (nonatomic, strong) UILabel       *headerViewLine;
@property (nonatomic, strong) UILabel   *menuLine;

@end

@implementation NIMPublicBottomView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [self makeConstraints];
    }
    return self;
}
- (void)makeConstraints{
    //    CGFloat screen_width = CGRectGetWidth([UIScreen mainScreen].bounds);
    [self.headerViewLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.leading.equalTo(self.mas_leading);
        make.height.equalTo(@(0.49));
        make.trailing.equalTo(self.mas_trailing);
    }];
    
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.leading.equalTo(self.mas_leading);
        make.bottom.equalTo(self.mas_bottom);
        make.trailing.equalTo(self.mas_trailing);
    }];
    
    [self.showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView.mas_leading).with.offset(7);
        make.bottom.equalTo(self.headerView.mas_bottom).with.offset(-9);
        make.width.equalTo(@28);
        make.height.equalTo(@28);
    }];
    
    [self.menuLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.showBtn.mas_leading).with.offset(34);
        make.bottom.equalTo(@0);
        make.width.equalTo(@0.5);
        make.top.equalTo(@0);
    }];
    [self.enterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.showBtn.mas_leading).with.offset(35);
        make.bottom.equalTo(self.headerView.mas_bottom).with.offset(-9);
        make.trailing.equalTo(self.headerView.mas_trailing);

        make.height.equalTo(@28);
    }];
    
}
-(void)showBtnClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showKeyBoardView)]) {
        [self.delegate showKeyBoardView];
    }
}
-(void)enterBtnClick:(id)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(enterShopBtnPressed)]) {
        [self.delegate enterShopBtnPressed];
    }
}
#pragma mark getter
- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerView.clipsToBounds = YES;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.userInteractionEnabled = YES;
        UIImage *img_header = [IMGGET(@"bg_tabbar.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)
                                                                         resizingMode:UIImageResizingModeStretch];
        
        [_headerView setImage:img_header];
        [self addSubview:_headerView];
    }
    return _headerView;
}
-(UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setImage:IMGGET(@"icon_keyboard") forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_showBtn];
    }
    return _showBtn;
}
-(UIButton*)enterBtn
{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setTitle:@"进入店铺" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(enterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_enterBtn];
    }
    return _enterBtn;
}
-(UILabel *)headerViewLine
{
    if (!_headerViewLine) {
        _headerViewLine = [[UILabel alloc]initWithFrame:CGRectZero];
        _headerViewLine.backgroundColor = [SSIMSpUtil getColor:@"bbbbbb"];
        [self.headerView addSubview:_headerViewLine];
    }
    return _headerViewLine;
}

-(UILabel *)menuLine
{
    if (!_menuLine) {
        _menuLine = [[UILabel alloc]initWithFrame:CGRectZero];
        _menuLine.backgroundColor = [SSIMSpUtil getColor:@"c9c9c9"];
        [self.headerView addSubview:_menuLine];
    }
    return _menuLine;
}

@end
