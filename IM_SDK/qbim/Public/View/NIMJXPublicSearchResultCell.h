//
//  NIMJXNIMPublicSearchResultCell.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/8/7.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPublicMode.h"
@class NIMJXNIMPublicSearchResultCell;
@protocol NIMJXNIMPublicSearchResultCellDeleagate <NSObject>
@optional
- (void)JXPublicfollowBtnPressed:(UITableViewCell*)cell publicMode:(publicMode*)publicModes;

@end
@interface NIMJXNIMPublicSearchResultCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImage;
@property (nonatomic,strong)UILabel     *nameLable;
@property (nonatomic,strong)UIImageView *flagImage;
@property (nonatomic,strong)UIImageView *RflagImage;
@property (nonatomic,strong)UIImageView *line;
@property (nonatomic,strong)UIButton  *followBtn;
@property (nonatomic,strong)UIImage *redBoxImage;
@property (nonatomic,strong)UIImage *redBoxImageHighlighted;
@property (nonatomic,strong)publicMode *m_publicMode;

@property (nonatomic,assign)id <NIMJXNIMPublicSearchResultCellDeleagate>  delegate;
- (void)setCellDataSource:(publicMode*)publicmode searchString:(NSString*)searchString;
-(void)updateButnState;
-(void)changeButnState;
@end
