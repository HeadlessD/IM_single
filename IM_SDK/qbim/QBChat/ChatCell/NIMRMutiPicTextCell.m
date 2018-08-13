//
//  NIMRMutiPicTextCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRMutiPicTextCell.h"

@interface NIMRMutiPicTextCell ()
@property (nonatomic, strong) QBRPicHeaderView *headerView;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation NIMRMutiPicTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.containerView addGestureRecognizer:self.longPressRecognizer];
}
#pragma mark actions
- (void)viewClick:(UIButton *)sender{
    NSInteger index = sender.tag;
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity atIndex:index];
}

#pragma mark config
- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    NSString* sbody = recordEntity.msgContent;;
    NSDictionary *jsonDic = [NIMUtility jsonWithJsonString:sbody];
    NSArray *items = [jsonDic objectForKey:@"items"];
    self.itemCount = items.count;
    
    [self makeConstraints];
    if (self.showTimeline) {
        self.timelineLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
    

    if (_views) {
        [_views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            QBRPicLineView *picLineView = obj;
            [picLineView removeFromSuperview];
            picLineView = nil;
        }];
    }
    
    _views = @[].mutableCopy;
    
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        NSString *imageStr = [dic objectForKey:@"img_url"];
        NSString *titleStr = [dic objectForKey:@"title"];
        NSString *ctStr = [dic objectForKey:@"ct"];
        
        if (idx == 0) {
            [self.headerView updateWithName:titleStr icon:imageStr ct:ctStr index:idx];
        }else {
            CGFloat y = CGRectGetMaxY(self.headerView.frame)+ 10;
            y = 0;
            CGRect f = CGRectMake(0, 60 * (idx - 1) + y, CGRectGetWidth(self.frame) - 20, 60);
            QBRPicLineView *picLineView = [[QBRPicLineView alloc] initWithFrame:f];
            [picLineView updateWithName:titleStr icon:imageStr index:idx];
            [picLineView.containerBtn addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.listView addSubview:picLineView];
            [_views addObject:picLineView];
        }
    }];

    [self.contentView sendSubviewToBack:self.containerView];
    
}

- (void)makeConstraints{
    
    if (self.showTimeline) {
        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.height.equalTo(@20);
        }];
        
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(10);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
        
    }else{
        
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).with.offset(0);
        make.leading.equalTo(self.containerView.mas_leading).with.offset(0);
        make.trailing.equalTo(self.containerView.mas_trailing).with.offset(0);
        make.height.equalTo(@190);
    }];
    
    [self.listView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).with.offset(0);
        make.leading.equalTo(self.headerView.mas_leading).with.offset(0);
        make.trailing.equalTo(self.headerView.mas_trailing).with.offset(0);
        CGFloat height = (self.itemCount - 1) * 60;
        make.height.equalTo([NSNumber numberWithFloat:height]);
    }];
}

#pragma mark actions
- (void)actionForward:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeForward];
}

#pragma mark getter
- (NSArray *)menuItems{
    if (!_menuItems) {
        _menuItems = @[kMenuItemForward];
    }
    return _menuItems;
}
- (UILabel *)timelineLabel{
    if (!_timelineLabel) {
        _timelineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timelineLabel.font = [UIFont systemFontOfSize:12];
        _timelineLabel.textColor = [UIColor lightGrayColor];
        _timelineLabel.numberOfLines = 1;
        _timelineLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timelineLabel];
    }
    return _timelineLabel;
}
- (UIButton *)containerView{
    if (!_containerView) {
        UIImage *image = IMGGET(@"bg_task_cell");
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
        
        
        UIImage *imageHightlight = IMGGET(@"bg_task_cell_hightlight");
        imageHightlight = [imageHightlight resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                                                          resizingMode:UIImageResizingModeStretch];
        
        _containerView = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_containerView setBackgroundImage:image forState:UIControlStateNormal];
        [_containerView setBackgroundImage:imageHightlight forState:UIControlStateHighlighted];
        [_containerView setBackgroundImage:imageHightlight forState:UIControlStateSelected];
        _containerView.clipsToBounds = YES;
        _containerView.contentMode = UIViewContentModeScaleAspectFill;
        _containerView.layer.cornerRadius = 2;
        [self.contentView addSubview:_containerView];
    }
    return _containerView;
}

- (QBRPicHeaderView *)headerView{
    if (!_headerView) {
        CGRect rect = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMinY(self.containerView.frame), CGRectGetWidth(self.frame) - 2*CGRectGetMinX(self.containerView.frame), 180);
        _headerView = [[QBRPicHeaderView alloc] initWithFrame:rect];
        _headerView.userInteractionEnabled = YES;
        [_headerView.containerBtn addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_headerView];
    }
    return _headerView;
}

- (UIView *)listView{
    if (!_listView) {
        _listView = [[UIView alloc] initWithFrame:CGRectZero];
        _listView.userInteractionEnabled = YES;
        [self.contentView addSubview:_listView];
    }
    return _listView;
}
@end

@implementation QBRPicHeaderView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)updateWithName:(NSString *)name icon:(NSString *)icon ct:(NSString *)ct index:(NSInteger)index{
    _index = index;
    [self.containerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.leading.equalTo(self.mas_leading).with.offset(0);
        make.trailing.equalTo(self.mas_trailing).with.offset(0);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.leading.equalTo(self.mas_leading).with.offset(10);
        make.trailing.equalTo(self.mas_trailing).with.offset(-10);
        make.height.equalTo(@20);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
        make.leading.equalTo(self.timeLabel.mas_leading);
        make.trailing.equalTo(self.timeLabel.mas_trailing);
        make.height.equalTo(@140);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.timeLabel.mas_leading);
        make.trailing.equalTo(self.timeLabel.mas_trailing);
        make.bottom.equalTo(self.imageView.mas_bottom);
        make.height.greaterThanOrEqualTo(@30);
    }];
    self.timeLabel.text = [SSIMSpUtil parseTime:[ct longLongValue]/1000];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:IMGGET(@"bg_dialog_pictures")];
    self.nameLabel.text = name;
    
}

#pragma mark
- (UIButton *)containerBtn{
    if (!_containerBtn) {
        UIImage *image = IMGGET(@"bg_task_cell");
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
        
        
        UIImage *imageHightlight = IMGGET(@"bg_task_cell_hightlight");
        imageHightlight = [imageHightlight resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                                                          resizingMode:UIImageResizingModeStretch];
        
        _containerBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_containerBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_containerBtn setBackgroundImage:imageHightlight forState:UIControlStateHighlighted];
        [_containerBtn setBackgroundImage:imageHightlight forState:UIControlStateSelected];
        _containerBtn.clipsToBounds = YES;
        _containerBtn.contentMode = UIViewContentModeScaleAspectFill;
        _containerBtn.layer.cornerRadius = 2;
        _containerBtn.tag = self.index;
        [self addSubview:_containerBtn];
    }
    return _containerBtn;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.numberOfLines = 1;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        _nameLabel.numberOfLines = 2;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}


@end
@implementation QBRPicLineView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)updateWithName:(NSString *)name icon:(NSString *)icon index:(NSInteger)index{
    self.index = index;
    [self.containerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.leading.equalTo(self.mas_leading).with.offset(0);
        make.trailing.equalTo(self.mas_trailing).with.offset(0);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.leading.equalTo(self.mas_leading).with.offset(0);
        make.trailing.equalTo(self.mas_trailing).with.offset(0);
        make.height.equalTo(@1);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.leading.equalTo(self.mas_leading).with.offset(10);
        make.trailing.equalTo(self.mas_trailing).with.offset(-60);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.trailing.equalTo(self.mas_trailing).with.offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [self line];
    self.nameLabel.text = name;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];
}

#pragma mark actions
- (void)doClick:(id)sender{
    
}

#pragma mark
- (UIButton *)containerBtn{
    if (!_containerBtn) {
        UIImage *image = IMGGET(@"bg_task_cell");
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
        
        
        UIImage *imageHightlight = IMGGET(@"bg_task_cell_hightlight");
        imageHightlight = [imageHightlight resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                                                          resizingMode:UIImageResizingModeStretch];
        
        _containerBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_containerBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_containerBtn setBackgroundImage:imageHightlight forState:UIControlStateHighlighted];
        [_containerBtn setBackgroundImage:imageHightlight forState:UIControlStateSelected];
        _containerBtn.clipsToBounds = YES;
        _containerBtn.contentMode = UIViewContentModeScaleAspectFill;
        _containerBtn.layer.cornerRadius = 2;
        _containerBtn.tag = self.index;
        [_containerBtn addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_containerBtn];
    }
    return _containerBtn;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               10,
                                                               CGRectGetWidth(self.frame) - 60,
                                                               CGRectGetHeight(self.frame) - 20)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _nameLabel.numberOfLines = 2;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 50 ,
                                                                   10,
                                                                   40,
                                                                   40)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                                   CGRectGetWidth(self.frame),
                                                                   1)];
        _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:_line];
    }
    return _line;
}
@end
