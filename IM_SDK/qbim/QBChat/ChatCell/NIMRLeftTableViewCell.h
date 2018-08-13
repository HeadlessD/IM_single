//
//  NIMRLeftTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRChatTableViewCell.h"
#import "NIMGroupUserIcon.h"
@interface NIMRLeftTableViewCell : NIMRChatTableViewCell<NIMGroupUserIconDelegate>
{
    UIButton    *_paoButton;
}
@property (nonatomic, strong) UILabel *timeLine;
@property (nonatomic, strong) UILabel *vNameLabel;
@property (nonatomic, strong) NIMGroupUserIcon *avatarBtn;
@property (nonatomic, strong) UIButton *paoButton;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (void)makeConstraints;
@end
