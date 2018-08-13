//
//  NIMRTipTextCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRTipTextCell.h"
#import "TextEntity+CoreDataClass.h"

@implementation NIMRTipTextCell


- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    if (self.showTimeline) {
        self.timelineLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
    TextEntity *textEntity = recordEntity.textFile;
    NSString *text = textEntity.text;
    self.nameLabel.text = text;
    if(!text){//拆包消息
        NSDictionary *bodydic = [SSIMSpUtil convertJSONToDict:recordEntity.msgContent];
        self.nameLabel.text = [bodydic objectForKey:@"description"]?[bodydic objectForKey:@"description"]:@"";
    }
    [self makeConstraints];
    
}

- (void)makeConstraints{
    CGSize size =[NSString nim_getSizeFromString:self.nameLabel.text withFont:[UIFont systemFontOfSize:14] andLabelSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-kMarginTipText, CGFLOAT_MAX)];
    if (self.showTimeline) {
        CGSize tsize =[NSString nim_getSizeFromString:self.timelineLabel.text withFont:[UIFont systemFontOfSize:13] andLabelSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-kMarginTipText, CGFLOAT_MAX)];
        
        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            //            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            //            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(tsize.width+13));
            make.height.equalTo(@20);
        }];
        
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(10);
            //            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            //            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(size.width+25));
            make.height.equalTo(@(size.height+5));
        }];
        
    }else{
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            //            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            //            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.width.equalTo(@(size.width+25));
            make.height.equalTo(@(size.height+5));
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        
    }
    
    
    
}
- (UILabel *)timelineLabel{
    if (!_timelineLabel) {
        _timelineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timelineLabel.font = [UIFont systemFontOfSize:13];
        _timelineLabel.numberOfLines = 1;
        _timelineLabel.textAlignment = NSTextAlignmentCenter;
        _timelineLabel.backgroundColor = kTipColor;
        _timelineLabel.textColor = [UIColor whiteColor];
        _timelineLabel.layer.cornerRadius = 4;
        _timelineLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_timelineLabel];
    }
    return _timelineLabel;
}
- (NIMQBLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[NIMQBLabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = kTipColor;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.layer.cornerRadius = [SSIMSpUtil pxSizeConvert:8];
        _nameLabel.layer.masksToBounds = YES;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _nameLabel.edgeInsets = UIEdgeInsetsMake(2, 12, 2, 12);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
@end

