//
//  NIMSubDetailTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSubDetailTableViewCell.h"
#import "GMember+CoreDataClass.h"
  
@interface NIMSubDetailTableViewCell ()<NSURLConnectionDelegate>
@property(nonatomic, strong) GroupList *groupEntity;

@end
@implementation NIMSubDetailTableViewCell

#pragma mark 11.7
- (void)fetchGroupDetail:(double)groupid{
  
//    [self.activityIndicator startAnimating];
//    self.activityIndicator.hidden = NO;
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//
//        
//    });
    
    
    
}
- (void)updateIntroLabel:(NSInteger)count{

    if (count >0) {
        self.deLablel.text = [NSString stringWithFormat:@"%ld人",(long)count];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }
}

#pragma mark 新改
- (void)updateWithGroupList:(GroupList *)groupEntity;{
    NSInteger count = groupEntity.membercount;
    self.titleLable.text = groupEntity.name;
    [self updateIntroLabel:count];
    
    
    
    [self.iconView setViewDataSourceFromUrlString:GROUP_ICON_URL(groupEntity.groupId)];
}

//判断
-(void) validateUrl: (NSURL *) candidate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:candidate];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"error %@",error);
        if (!request && error) {
            NSLog(@"不可用%@",request);
        }else{
            //NSLog(@"可用%@",request);
        }
    }];
    [task resume];
}

#pragma mark config
- (void)makeConstraints{
    [super makeConstraints];
    
    [self.titleLable mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconView.mas_top).with.offset(0);
//        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-70);
//        make.height.equalTo(@20);
//        make.centerY.equalTo(self.iconView.mas_centerY);

    }];
    
    [self.deLablel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLable.mas_trailing);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
        make.centerY.equalTo(self.titleLable.mas_centerY);
        
    }];
    
    [self.activityIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.deLablel.mas_leading);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
        make.centerY.equalTo(self.deLablel.mas_centerY);
        make.centerX.equalTo(self.deLablel.mas_centerX);
    }];
    
}
#pragma mark getter
- (UILabel *)deLablel{
    if (!_deLablel) {
        _deLablel = [[UILabel alloc] initWithFrame:CGRectZero];
        _deLablel.numberOfLines = 1;
        _deLablel.font = [UIFont systemFontOfSize:14];
        _deLablel.textColor = [SSIMSpUtil getColor:@"888888"];
        _deLablel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_deLablel];
    }
    return _deLablel;
}
- (UIActivityIndicatorView *)activityIndicator{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        [self.contentView addSubview:_activityIndicator];
    }
    return _activityIndicator;
}
@end
