//
//  NIMRGainCell.m
//  QianbaoIM
//
//  Created by qianwang on 14/11/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRGainCell.h"
#import "OHASBasicHTMLParser.h"

@implementation NIMRGainCell

#pragma mark config
- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    [self makeConstraints];
    if (self.showTimeline) {
        self.timelineLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
    NSString* sbody = recordEntity.msgContent;
    
    NSData *dt = [sbody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:dt options:NSJSONReadingAllowFragments error:nil];
    NSString *contentStr =PUGetObjFromDict(@"content", dic, [NSString class]);
  
    [self updateWithContent:contentStr];
     
}

- (void)makeConstraints{
    
    
    if (self.showTimeline) {
        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.height.equalTo(@20);
        }];
        
        [self.containerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }else{
        [self.containerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerBtn.mas_top).with.offset(20);
        make.leading.equalTo(self.containerBtn.mas_leading).with.offset(10);
        make.trailing.equalTo(self.containerBtn.mas_trailing).with.offset(-10);
        make.bottom.equalTo(self.containerBtn.mas_bottom).with.offset(-60);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10);
        make.leading.equalTo(self.contentLabel.mas_leading);
        make.trailing.equalTo(self.contentLabel.mas_trailing);
        make.height.equalTo(@1);
    }];
    
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(15);
        make.leading.equalTo(self.lineView.mas_leading).with.offset(0);
        make.trailing.equalTo(self.lineView.mas_trailing).with.offset(-30);
        make.bottom.equalTo(self.containerBtn.mas_bottom).with.offset(-15);
        //        make.height.equalTo(@20);
    }];
    
    [self.accessory mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_top).with.offset(0);
        make.trailing.equalTo(self.lineView.mas_trailing).with.offset(0);
        make.bottom.equalTo(self.containerBtn.mas_bottom).with.offset(-15);
        make.width.equalTo(@20);
        //        make.height.equalTo(@20);
    }];

}
- (void)updateWithContent:(NSString *)content{
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSData *data = [content dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:data
                                                                            options:options
                                                                 documentAttributes:nil error:nil];

    
//    NSMutableAttributedString *mas = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:content];
    self.contentLabel.attributedText = attributedString;
}


#pragma mark actions
- (void)actionForward:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeForward];
}
-(void)todoSomething:(id)sender
{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}
- (void)paoClick:(UIButton *)button{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:button];
    [self performSelector:@selector(todoSomething:) withObject:button afterDelay:0.2f];
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
        [_containerBtn addTarget:self action:@selector(paoClick:) forControlEvents:UIControlEventTouchUpInside];
        _containerBtn.contentMode = UIViewContentModeScaleAspectFill;
        _containerBtn.layer.cornerRadius = 2;
        [self.contentView addSubview:_containerBtn];
        }
    return _containerBtn;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor darkTextColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}
- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lineView.clipsToBounds = YES;
        _lineView.backgroundColor = [SSIMSpUtil getColor:@"d5d5d5"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont boldSystemFontOfSize:14];
        _tipLabel.textColor = [UIColor darkTextColor];
        _tipLabel.text = @"立即查看";
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}
- (UIImageView *)accessory{
    if (!_accessory) {
        _accessory = [[UIImageView alloc] initWithImage:IMGGET(@"icon_activity_enter")];
        _accessory.clipsToBounds = YES;
        [self.contentView addSubview:_accessory];
    }
    return _accessory;
}

@end
