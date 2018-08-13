//
//  NIMAddFriendAttributeCell.m
//  QBNIMClient
//
//  Created by 豆凯强 on 2017/8/16.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMAddFriendAttributeCell.h"


@interface NIMAddFriendAttributeCell()<NIMAttributedLabelDelegate>

@end

@implementation NIMAddFriendAttributeCell

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    if (self.showTimeline) {
        self.timelineLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
 
    TextEntity * textEntity = recordEntity.textFile;
     NSString *tmptext = textEntity.text;
     NSMutableString *text = [NSMutableString stringWithString:tmptext];
    
    [self configurTTLabel:text];
    
    [self makeConstraints];
}

- (void)makeConstraints{
    CGSize size =[NSString nim_getSizeFromString:self.btnStrLabel.text withFont:[UIFont systemFontOfSize:14] andLabelSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-kMarginTipText, CGFLOAT_MAX)];

    if (self.showTimeline) {
        CGSize tsize =[NSString nim_getSizeFromString:self.timelineLabel.text withFont:[UIFont systemFontOfSize:13] andLabelSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-kMarginTipText, CGFLOAT_MAX)];

        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
//            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
//            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(tsize.width+10));
            make.height.equalTo(@20);
        }];
        
        [self.btnStrLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(10);
//            make.leading.equalTo(self.contentView.mas_leading).with.offset(20);
//            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-20);
//            make.height.greaterThanOrEqualTo(@30);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(size.width+25));
            make.height.equalTo(@(size.height+5));
        }];
        
    }else{
        [self.btnStrLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(self.contentView.mas_leading).with.offset(20);
//            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-20);
//            make.height.greaterThanOrEqualTo(@35);
//            make.centerY.equalTo(self.contentView.mas_centerY);
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(size.width+25));
            make.height.equalTo(@(size.height+5));
        }];
    }
}


- (void)configurTTLabel:(NSString *)tempStr{
    NSMutableArray *rangeArr = [NSMutableArray arrayWithCapacity:5];

    
    [self.btnStrLabel setText:tempStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString*(NSMutableAttributedString*mutableAttributedString){
        
        //设定可点击文字的的大小
        UIFont*boldSystemFont = [UIFont systemFontOfSize:14];
        CTFontRef font =CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize,NULL);
        
        //设置可点击文字的范围
        NSRange boldRange = [[mutableAttributedString string]rangeOfString:@"发送好友验证" options:NSCaseInsensitiveSearch];
        
        NSString *rangStr = NSStringFromRange(boldRange);
        NSDictionary *rangdic = @{@"id":[NSString stringWithFormat:@"%lld",self.recordEntity.opUserId],
                                  @"range":rangStr};
        [rangeArr addObject:rangdic];
        
        if(font){
            //设置可点击文本的大小
            [mutableAttributedString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)font range:boldRange];
            //设置可点击文本的颜色
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[SSIMSpUtil getColor:@"3399FF"]CGColor] range:boldRange];
            
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    
    for (NSDictionary *dict in rangeArr) {
        
        NSString * rStr= [dict objectForKey:@"range"];
        
        NSRange range = NSRangeFromString(rStr);
        [self.btnStrLabel addLinkToTransitInformation:dict withRange:range];
    }

//    [_btnStrLabel addLinkToTransitInformation: withRange:range];
}



-(void)attributedLabel:(NIMAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    if ([_delegate respondsToSelector:@selector(chatTableViewCell:didSelectUser:)]) {
        
        int64_t userid = [[components objectForKey:@"id"] longLongValue];
        [_delegate chatTableViewCell:self didSelectUser:userid];
    }
}

- (NIMAttributedLabel *)btnStrLabel{
    if (!_btnStrLabel) {
        _btnStrLabel = [[NIMAttributedLabel alloc] initWithFrame:CGRectZero];
        _btnStrLabel.textAlignment = NSTextAlignmentLeft;
        _btnStrLabel.font = [UIFont systemFontOfSize:14];
        _btnStrLabel.numberOfLines = 0;
        _btnStrLabel.textColor = [UIColor whiteColor];
        _btnStrLabel.backgroundColor = kTipColor;
        _btnStrLabel.delegate = self;
        _btnStrLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        _btnStrLabel.highlighted = NO;
        _btnStrLabel.layer.cornerRadius = [SSIMSpUtil pxSizeConvert:8];
        _btnStrLabel.layer.masksToBounds = YES;
        _btnStrLabel.textInsets =  UIEdgeInsetsMake(2, 12, 2, 12);
        [self.contentView addSubview:_btnStrLabel];
    }
    return _btnStrLabel;
}


- (UILabel *)timelineLabel{
    if (!_timelineLabel) {
        _timelineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timelineLabel.font = [UIFont systemFontOfSize:13];
        _timelineLabel.textColor = [UIColor whiteColor];
        _timelineLabel.backgroundColor = kTipColor;
        _timelineLabel.numberOfLines = 1;
        _timelineLabel.textAlignment = NSTextAlignmentCenter;
        _timelineLabel.layer.cornerRadius = 4;
        _timelineLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_timelineLabel];
    }
    return _timelineLabel;
}


@end
