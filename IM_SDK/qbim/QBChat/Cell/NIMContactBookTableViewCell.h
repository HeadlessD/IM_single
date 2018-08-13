//
//  NIMContactBookTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/10/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kContactBookIdentifier  @"contactBookTableViewCell"
@class PhoneBookEntity;
@protocol ContactBookTableViewCellDelegate;
@interface NIMContactBookTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *introLablel;
@property (nonatomic, strong) UIButton *accessoryBtn;
@property (nonatomic, strong) id<ContactBookTableViewCellDelegate>delegate;
- (void)updateWithphoneBookEntity:(PhoneBookEntity *)phoneBookEntity;
@end

@protocol ContactBookTableViewCellDelegate <NSObject>

- (void)contactBookTableViewCell:(NIMContactBookTableViewCell *)cell didSelectedWithphoneBookEntity:(PhoneBookEntity *)phoneBookEntity;

@end
