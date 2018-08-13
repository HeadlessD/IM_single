//
//  NIMRightTipView.m
//  QianbaoIM
//
//  Created by liyan on 10/19/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMRightTipView.h"
@interface NIMRightTipView()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel     *messageView;
@property (nonatomic, strong) UIView      *bgView;

@end

@implementation NIMRightTipView

- (id)init
{
    CGRect frame = CGRectMake(0, 0, 210, 50);
    self = [super initWithFrame:frame];
    if(self)
    {
        _rightType = COLLETCTION_TYPE;
        self.bgView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:self.bgView];
        self.bgView.backgroundColor = _COLOR_BLACK;
        self.bgView.alpha = .8;
        
        UIImage *img = IMGGET(@"set_clear_cache_icon.png");
        self.iconView  = [[UIImageView alloc]initWithImage:img];
        [self addSubview:self.iconView];
        [self.iconView setFrame:_CGR(10, 17, 16, 16)];
//        self.iconView.backgroundColor = _COLOR_RED;
        
        self.messageView = [[UILabel alloc]initWithFrame:_CGR(28, 16, 180, 18)];
        [self addSubview:self.messageView];
        self.messageView.font = FONT_TITLE(15);
        
        self.messageView.textColor = _COLOR_WHITE;
        
    }
    return self;
}

- (void)setRightType:(RightViewType)rightType {
    _rightType = rightType;
    switch (rightType) {
        case COLLETCTION_TYPE:
            self.iconView.image = IMGGET(@"set_clear_cache_icon.png");
            break;
        case DIANZANG_TYPE:
            self.iconView.image = IMGGET(@"comment_show_tip");
            break;
            
        default:
            break;
    }
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [self init];
//    if(self)
//    {
//        
//    }
//    return self;
//}

- (void)setMessage:(NSString *)message
{
    self.messageView.text = message;
}
- (void)setNoIconMessage:(NSString *)message
{
    [self.iconView removeFromSuperview];
    self.messageView.frame = self.bounds;
    self.messageView.textAlignment = NSTextAlignmentCenter;
    
    self.messageView.text = message;
}

@end
