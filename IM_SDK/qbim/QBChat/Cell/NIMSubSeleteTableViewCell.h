//
//  NIMSubSeleteTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMDefaultTableViewCell.h"
#define kSubSeleteReuseIdentifier @"kSubSeleteReuseIdentifier"

@class NIMSubSeleteTableViewCell;
@protocol NIMSubSeleteTableViewCellDelegate <NSObject>

-(void)click:(UIButton*)btn;

@end
@interface NIMSubSeleteTableViewCell : NIMDefaultTableViewCell
@property(nonatomic, strong) UIButton *seleteBtn;
@property (nonatomic, getter=isHave)BOOL have;
@property (nonatomic, weak)id<NIMSubSeleteTableViewCellDelegate> selDeleagte;
@end


