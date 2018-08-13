//
//  NIMReportTableViewCell.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/3/20.
//  Copyright (c) 2015年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NIMReportTableViewCell;
@protocol NIMReportTableViewCelldelegate <NSObject>
@optional
-(void)chooseBtnClick:(NIMReportTableViewCell*)cell;
@end
@interface NIMReportTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton* btnChooseBg;
@property (nonatomic, strong) UILabel* labTitle;
@property (nonatomic, strong) UIImageView* botomLine;
@property (nonatomic,assign)id<NIMReportTableViewCelldelegate>delegate;
@end
