//
//  NIMRRightMerchandiseCell.h
//  QianbaoIM
//
//  Created by qianwang on 14/11/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightTableViewCell.h"
#import "NIMMyLable.h"
@interface NIMRRightMerchandiseCell : NIMRRightTableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) NIMMyLable *inStockLabel;
@property (nonatomic, strong) UIImageView *sourceImg;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *sourceTxt;
@end
