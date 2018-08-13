//
//  NIMRGroupTipTextCell.m
//  qbim
//
//  Created by 秦雨 on 17/3/14.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMRGroupTipTextCell.h"

@interface NIMRGroupTipTextCell()<NIMAttributedLabelDelegate>

@end

@implementation NIMRGroupTipTextCell

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    [self makeConstraints];
    if (self.showTimeline) {
        self.timelineLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
    TextEntity *textEntity = recordEntity.textFile;
    NSString *tmptext = textEntity.text;
    NSMutableString *text = [NSMutableString stringWithString:tmptext];
//    if (recordEntity.stype==GROUP_NEED_AGREE) {
//        [text appendString:@" 去确认"];
//    }else{
//        [text appendString:@" 已确认"];
//    }
    /*
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, text.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(text.length-3, 3)];
    self.nameLabel.attributedText = attrStr;
    [self.nameLabel yb_addAttributeTapActionWithStrings:@[@"去确认",@"已确认"] delegate:self];
     */
    NSData *data = [recordEntity.msgContent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dict objectForKey:@"fds"];
    [self configurTTLabel:text fdArr:arr];
    if(!text){//拆包消息
        NSDictionary *bodydic = [SSIMSpUtil convertJSONToDict:recordEntity.msgContent];
        self.nameLabel.text = [bodydic objectForKey:@"description"]?[bodydic objectForKey:@"description"]:@"";
    }
}

- (void)makeConstraints{
    
    if (self.showTimeline) {
        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.height.equalTo(@20);
        }];
        
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(-5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.height.greaterThanOrEqualTo(@20);
        }];
        
    }else{
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.height.greaterThanOrEqualTo(@20);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
    }
    
}

- (void)configurTTLabel:(NSString *)tempStr fdArr:(NSArray *)fdArr{
    
    NSMutableArray *rangeArr = [NSMutableArray arrayWithCapacity:5];
    
    [self.nameLabel setText:tempStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString*(NSMutableAttributedString*mutableAttributedString){
        
        //设定可点击文字的的大小
        UIFont*boldSystemFont = [UIFont systemFontOfSize:12];
        CTFontRef font =CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize,NULL);
        
        for (NSDictionary *dict in fdArr) {
            
            NSString *name = [dict objectForKey:@"name"];
            
            //设置可点击文字的范围
            NSRange boldRange = [[mutableAttributedString string]rangeOfString:name options:NSCaseInsensitiveSearch];
            
            if (boldRange.length> 0) {
                NSString *rangStr = NSStringFromRange(boldRange);
                NSDictionary *rangdic = @{@"id":[dict objectForKey:@"id"],
                                          @"range":rangStr};
                [rangeArr addObject:rangdic];
            }
            if(font){
                //设置可点击文本的大小
                [mutableAttributedString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                //设置可点击文本的颜色
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor greenColor]CGColor] range:boldRange];
                
                CFRelease(font);
            }
        }
        
        return mutableAttributedString;
    }];
    
    for (NSDictionary *dict in rangeArr) {
        
        NSString * rStr= [dict objectForKey:@"range"];
        
        NSRange range = NSRangeFromString(rStr);
        [self.nameLabel addLinkToTransitInformation:dict withRange:range];
    }
    
//    [self.nameLabel addLinkToTransitInformation:nil withRange:_lineboldRange1];
}


-(void)attributedLabel:(NIMAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    if ([_delegate respondsToSelector:@selector(chatTableViewCell:didSelectUser:)]) {
        
        int64_t userid = [[components objectForKey:@"id"] longLongValue];
        [_delegate chatTableViewCell:self didSelectUser:userid];
    }
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
- (NIMAttributedLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[NIMAttributedLabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.delegate = self;
        _nameLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        _nameLabel.highlighted = NO;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}


@end
