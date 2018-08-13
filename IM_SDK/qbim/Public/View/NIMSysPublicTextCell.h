//
//  NIMSysPublicTextCell.h
//  QianbaoIM
//
//  Created by liunian on 14/10/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPublicTextBodyCellReuseIdentifier @"kPublicTextBodyCellReuseIdentifier"
#define kPublicTextCellReuseIdentifier @"kPublicTextCellReuseIdentifier"

@interface NIMSysPublicTextCell : UITableViewCell
@property (nonatomic, strong) UILabel *introLabel ;
- (void)updateWithPublicText:(NSString *)text;
+ (CGFloat)heightSysPublicTextCellWithText:(NSString *)text;
@end
