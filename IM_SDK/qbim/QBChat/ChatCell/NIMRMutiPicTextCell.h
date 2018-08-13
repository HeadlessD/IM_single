//
//  NIMRMutiPicTextCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRChatTableViewCell.h"

@interface NIMRMutiPicTextCell : NIMRChatTableViewCell
@property (nonatomic, strong) UILabel    *timelineLabel;
@property (nonatomic, strong) UIButton    *containerView;
@end

@interface QBRPicHeaderView : UIView
@property (nonatomic, strong) UIButton    *containerBtn;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger index;
- (void)updateWithName:(NSString *)name icon:(NSString *)icon ct:(NSString *)ct index:(NSInteger)index;
@end

@interface QBRPicLineView : UIView
@property (nonatomic, strong) UIButton    *containerBtn;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, assign) NSInteger index;
- (void)updateWithName:(NSString *)name icon:(NSString *)icon index:(NSInteger)index;
@end
