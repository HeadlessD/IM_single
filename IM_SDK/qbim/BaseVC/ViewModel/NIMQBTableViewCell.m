//
//  NIMQBTableViewCell.m
//  QianbaoIM
//
//  Created by tiezhang on 14-9-17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMQBTableViewCell.h"

#define kdefault_offsetX    15

@interface NIMQBTableViewCell ()

//_PROPERTY_NONATOMIC_ASSIGN(BOOL, qb_whole);
_PROPERTY_NONATOMIC_RETAIN(UILabel, qb_bottomLine);

@end

@implementation NIMQBTableViewCell

- (void)qbf_setInit
{
//    self.qbm_bottomLineWidth = 15;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self qb_setCellBgColor:nil];
    
    [self qbf_setInit];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self qbf_setInit];
        
        [self qb_setCellBgColor:nil];
        
        [self.contentView addSubview:self.qb_bottomLine];
        [self qb_setLineWidthLeftValue:kdefault_offsetX];
        
        [self.qb_bottomLine setHidden:YES];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)qb_setCellBgColor:(UIColor*)color
{
    if(!color)
    {
        _CLEAR_BACKGROUND_COLOR_(self);
        _CLEAR_BACKGROUND_COLOR_(self.contentView);
    }
    else
    {
        [self.contentView setBackgroundColor:color];
    }
}

- (void)qb_showBottomLine:(BOOL)show
{
    if(show)
    {
        [self.qb_bottomLine setHidden:NO];
        [self.contentView addSubview:self.qb_bottomLine];
    }
    else
    {
        [_qb_bottomLine setHidden:YES];
    }
}
- (void)qb_setLineWidthLeftValue:(CGFloat)left height:(CGFloat)height
{
    [self qb_showBottomLine:YES];
    [self.qb_bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(self.contentView.mas_bottom).offset(-height);
        make.height.equalTo(@0);
    }];
}

- (void)qb_setLineWidthLeftValue:(CGFloat)left
{
    [self qb_setLineWidthLeftValue:left height:_LINE_HEIGHT_1_PPI];
}

- (void)qb_setLineWidthLeft:(MASViewAttribute*)left height:(CGFloat)height
{
    [self qb_showBottomLine:YES];
    [self.qb_bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(left);
        make.trailing.equalTo(@(0));
        make.top.equalTo(self.contentView.mas_bottom).offset(-height);
        make.height.equalTo(@0);
    }];
}
- (void)qb_setLineWidthLeft:(MASViewAttribute*)left
{
    [self qb_setLineWidthLeft:left height:_LINE_HEIGHT_1_PPI];
}

- (void)qb_setLineColor:(UIColor*)bColor
{
    [self.qb_bottomLine setBackgroundColor:bColor];
}

#pragma mark -- getter
_GETTER_BEGIN(UILabel, qb_bottomLine)
{
    CGFloat t_orginX = 15;
    
    _CREATE_LABEL(_qb_bottomLine, _CGR(t_orginX, (GetHeight(self.contentView)- _LINE_HEIGHT_1_PPI), GetWidth(self.contentView) - t_orginX, _LINE_HEIGHT_1_PPI), 10);
    [_qb_bottomLine setBackgroundColor:[SSIMSpUtil getColor:@"e6e6e6"]];
}
_GETTER_END(qb_bottomLine)

_GETTER_BEGIN(UIImageView, qbm_taskDetailImageView)
{
    
    UIImage *t_img      = IMGNAMED(@"icon_activity_enter.png");
    CGFloat t_padding   = 15;
    CGFloat t_width     = t_img.size.width;
    CGFloat t_height    = t_img.size.height;
    CGFloat t_orignX    = GetWidth(self.contentView) - t_padding - t_width;
    NSInteger t_orginY  = ceilf((50 - t_height)/2);
    _CREATE_UIIMAGEVIEW_IMAGE(_qbm_taskDetailImageView, _CGR(t_orignX, t_orginY, t_width, t_height), t_img);
}
_GETTER_END(qbm_taskDetailImageView)

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
