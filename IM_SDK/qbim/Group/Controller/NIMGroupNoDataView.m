//
//  QBGroupNoDataView.m
//  QianbaoIM
//
//  Created by fengsh on 3/11/15.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMGroupNoDataView.h"

@implementation NIMGroupNoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createControls];
        [self layoutControls];
    }
    
    return self;
}

- (void)createControls
{
    self.nodatalogo = [[UIImageView alloc]init];
    [self addSubview:self.nodatalogo];
    
    self.lbnodataTips = [[UILabel alloc]init];
    self.lbnodataTips.textAlignment = NSTextAlignmentCenter;
    self.lbnodataTips.textColor = UIColorOfHex(0xd5d5d5);
    [self addSubview:self.lbnodataTips];
}

- (void)layoutControls
{
    [self.nodatalogo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        make.width.equalTo(@80);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-60);
    }];
    
    [self.lbnodataTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@26);
        make.centerY.equalTo(self.mas_centerY).offset(20);
    }];
}

@end
