//
//  NIMNoneView.m
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/14.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMNoneView.h"




@implementation NIMNoneView


-(UIView * )initWithString:(NSString *)string{
    self = [super init];
    if (self) {
//        self.str = string;
        [self createViewWithString:string];
    }
    return self;
}

-(void)createViewWithString:(NSString *)string{
    
    CGFloat noneH = 250;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - noneH)/2-80, SCREEN_WIDTH, noneH)];
    backView.backgroundColor = [UIColor clearColor];
    
    UIImageView * noneImg = [[UIImageView alloc]initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 160, 180)];
//    noneImg.backgroundColor = [UIColor redColor];
    noneImg.image = IMGGET(@"nim_store_none");
    
    UILabel * strLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 180, SCREEN_WIDTH-100, 70)];
    strLabel.textAlignment = UITextAlignmentCenter;
    strLabel.text = string;
    strLabel.font =[UIFont systemFontOfSize:13];
    strLabel.textAlignment = NSTextAlignmentCenter;
    strLabel.numberOfLines = 2;
    strLabel.textColor =[SSIMSpUtil getColor:@"b2b2b2"];    
    
    [backView addSubview:noneImg];
    [backView addSubview:strLabel];

    [self addSubview:backView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
