//
//  NIMFansCell.h
//  QianbaoIM
//
//  Created by xuqing on 16/4/26.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMGroupUserIcon.h"
#import "NIMFansModle.h"
@interface NIMFansCell : UITableViewCell
@property (nonatomic, strong) NIMGroupUserIcon *iconView;
@property (nonatomic, strong) UILabel   *titleLable;
@property (nonatomic, strong) UIView    *bottomLineView;
- (void)updateWithVcardEntity:(NIMFansModle *)vcardEntty;
@end
