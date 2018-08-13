//
//  NIMJXFeaturedResultCell.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/8/7.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPublicMode.h"
@class NIMJXFeaturedResultCell;
@protocol NIMJXFeaturedResultCellDeleagate <NSObject>
@optional
- (void)JXPublicfollowBtnPressed:(UITableViewCell*)cell publicMode:(publicMode*)publicModes;


@end
@interface NIMJXFeaturedResultCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImage;
@property (nonatomic,strong)UILabel     *nameLable;
@property (nonatomic,strong)UILabel     *detailLable;
@property (nonatomic,strong)UIImageView *line;
@property (nonatomic,strong)UIImageView *flagImage;
@property (nonatomic,strong)UIImageView *RflagImage;
@property (nonatomic,strong)UIButton  *followBtn;
@property (nonatomic,strong)UIImage *redBoxImage;
@property (nonatomic,strong)UIImage *redBoxImageHighlighted;
@property (nonatomic,strong)publicMode *m_publicMode;
@property (nonatomic,assign)id <NIMJXFeaturedResultCellDeleagate>  delegate;
- (void)setCellDataSource:(publicMode*)publicmode;
-(void)updateButnState;
-(void)changeButnState;
@end
