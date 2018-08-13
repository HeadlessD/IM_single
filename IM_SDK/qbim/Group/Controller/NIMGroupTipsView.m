//
//  QBGroupTipsView.m
//  QianbaoIM
//
//  Created by fengsh on 2/11/15.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMGroupTipsView.h"

@implementation NIMGroupTipsView

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
    self.tips = [[UILabel alloc]init];
    self.tips.textColor = UIColorOfHex(0xa6a6a6);
    self.tips.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:self.tips];
}

- (void)layoutControls
{
    [self.tips mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.bottom.equalTo(@0);
        make.height.equalTo(@30);
    }];
}

@end
