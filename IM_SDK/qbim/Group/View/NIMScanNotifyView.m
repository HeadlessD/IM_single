//
//  NIMScanNotifyView.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/8/1.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMScanNotifyView.h"

@implementation NIMScanNotifyView

-(instancetype)initWithTips:(NSString *)tips
{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if (self = [super initWithFrame:rect]) {
        [self setupTip:tips];
    }
    
    return self;
}

-(void)setupTip:(NSString *)tips
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imgView.layer.cornerRadius = 50;
    imgView.image = IMGGET(@"icon_dialog_marvel");
    CGPoint center = self.center;
    imgView.center = center;
    
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imgView.frame)+10, SCREEN_WIDTH-20, 60)];
    tipL.numberOfLines = 3;
    tipL.textAlignment = NSTextAlignmentCenter;
    tipL.font = [UIFont systemFontOfSize:16 weight:5];
    tipL.text = tips;
    [self addSubview:imgView];
    [self addSubview:tipL];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
