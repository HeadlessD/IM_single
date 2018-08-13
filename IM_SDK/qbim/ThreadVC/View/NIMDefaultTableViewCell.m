//
//  NIMDefaultTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMDefaultTableViewCell.h"
#import "VcardEntity+CoreDataClass.h"
#import "GMember+CoreDataClass.h"
#import "GroupList+CoreDataClass.h"
//#import "PublicEntity.h"
#import "NIMManager.h"

@interface NIMDefaultTableViewCell ()
@property (nonatomic, strong) VcardEntity *vcardEntity;
@property (nonatomic, strong) GroupList *groupEntity;
//@property (nonatomic, strong) PublicEntity *publicEntity;

@end

@implementation NIMDefaultTableViewCell
@synthesize delegate = _delegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self makeConstraints];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self makeConstraints];
    }
    
    return self;
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [(UITapGestureRecognizer*)gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (5 < translation.x && translation.x < 50 && translation.y >5 && translation.y < 65)
    {
        return NO;
    }
    
    return YES;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.iconView setViewIconFromImage:nil];
    self.titleLable.text = nil;
}
#pragma mark 新改
- (void)updateWithGroupEntity:(GroupList *)groupEntity{
    self.groupEntity = groupEntity;
    
    [self.iconView setViewDataSourceFromUrlString:GROUP_ICON_URL(self.groupEntity.groupId)];
    self.titleLable.text = groupEntity.name;
    
}

- (void)updateWithVcardEntity:(VcardEntity *)vcardEntty{
    self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    [self makeConstraints];
    self.vcardEntity = vcardEntty;

    [self.iconView setViewDataSourceFromUrlString:USER_ICON_URL(vcardEntty.userid)];
    self.titleLable.text = [NIMStringComponents finFristNameWithID:vcardEntty.userid];
}

#pragma mark - 修改群成员
-(void)updateWithMemberEntity:(GMember *)memberEntity
{
    VcardEntity *vcardEntity = [memberEntity vcard];
    if (nil == vcardEntity){
        vcardEntity = [VcardEntity instancetypeFindUserid:memberEntity.userid];
    }
    
    FDListEntity * fdlist =  [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld ",OWNERID,memberEntity.userid]];
    NSString *name = @"用户";
    if (!IsStrEmpty(fdlist.fdRemarkName)) {
        name = fdlist.fdRemarkName;
    }else if (!IsStrEmpty(memberEntity.groupmembernickname)){
        name = memberEntity.groupmembernickname;
    }else{
        name = vcardEntity.defaultName;
    }
    
    if (![memberEntity.showName isEqualToString:name]) {
        memberEntity.showName = name;
        memberEntity.fullLitter = [PinYinManager getFullPinyinString:name];
        memberEntity.allFullLitter = [PinYinManager getAllFullPinyinString:name];
    }
    if (![memberEntity.fLitter isEqualToString:[PinYinManager getFirstLetter:name]]) {
        memberEntity.fLitter = [PinYinManager getFirstLetter:name];
    }
    [self.iconView setViewDataSourceFromUrlString:USER_ICON_URL(memberEntity.userid)];
    self.titleLable.text = name;
}

//- (void)updateWithPublicEntity:(PublicEntity *)publicEntty{
//    self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
//
//    self.publicEntity = publicEntty;
//    NSString *name = @"用户";
//
//    if (publicEntty.name) {
//        name = publicEntty.name;
//    }
//    [self.iconView setViewDataSourceFromUrlString:publicEntty.avatar];
//    self.titleLable.text = name;
//}

- (void)updateWithImage:(UIImage *)image name:(NSString *)name{
    self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    [self makeConstraints];
    [self.iconView setViewIconFromImage:image];
    self.titleLable.text = name;
    self.titleLable.textColor = [SSIMSpUtil getColor:@"262626"];
}

#pragma mark config
- (void)makeConstraints{
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.width.height.equalTo(@36);
    }];
    
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(6);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(-6);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
    }];
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.trailing.equalTo(self.mas_trailing).with.offset(0);
        make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
    }];
    
    //    if (_hasLineLeadingLeft) {
    
    //    }else{
    //        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.leading.equalTo(self.iconView.mas_trailing).offset(10);
    //            make.bottom.equalTo(self.mas_bottom).with.offset(0);
    //            make.trailing.equalTo(self.mas_trailing).with.offset(0);
    //            make.height.equalTo(_LINE_HEIGHT_1_PPI);
    //        }];
    //    }
}


#pragma mark NIMGroupUserIconDelegate
- (void)NIMGroupUserIconClick{
    if ([_delegate respondsToSelector:@selector(iconDidSlectedWithtableViewCell:)]) {
        [_delegate iconDidSlectedWithtableViewCell:self];
    }
    
}

#pragma mark getter
- (NIMGroupUserIcon *)iconView{
    if (!_iconView) {
        _iconView = [[NIMGroupUserIcon alloc] initWithFrame:CGRectZero];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.cornerRadius = 2;
        _iconView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _iconView.clipsToBounds = YES;
        _iconView.delegate = self;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.numberOfLines = 1;
        _titleLable.font = [UIFont systemFontOfSize:16];//[UIFont boldSystemFontOfSize:16];
        _titleLable.textColor = __COLOR_262626__;
        [self.contentView addSubview:_titleLable];
    }
    return _titleLable;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = [SSIMSpUtil getColor:@"EBEBEB"];
        [self.contentView addSubview:_bottomLineView];
    }
    return _bottomLineView;
}


@end
