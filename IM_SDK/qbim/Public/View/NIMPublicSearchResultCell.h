//
//  NIMPublicSearchResultCell.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/6/25.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPublicMode.h"
@class NIMJXNIMPublicSearchResultCell;
@protocol NIMPublicSearchResultCellDeleagate <NSObject>
@optional
-(void)JXPublicfollowBtnPressed:(UITableViewCell *)cell publicMode:(publicMode *)publicModes;

@end
@interface NIMPublicSearchResultCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImage;
@property (nonatomic,strong)UILabel     *nameLable;
@property (nonatomic,strong)UILabel     *numbLable;
@property (nonatomic,strong)UILabel     *detailLable;
@property (nonatomic,strong)UIImageView *line;
@property (nonatomic,strong)UIImageView *flagImage;
@property (nonatomic,strong)UIImageView *JXflagImage;
@property (nonatomic,strong)UIButton  *followBtn;
@property (nonatomic,strong)UIImage *redBoxImage;
@property (nonatomic,strong)UIImage *redBoxImageHighlighted;
@property (nonatomic,strong)publicMode *m_publicMode;
@property (nonatomic,assign)id <NIMPublicSearchResultCellDeleagate>  delegate;
- (void)setCellDataSource:(publicMode*)publicmode searchString:(NSString*)searchString;
-(void)updateButnState;
-(void)changeButnState;
@end
