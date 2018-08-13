//
//  IncomeCell.h
//  QianbaoIM
//
//  Created by Yun on 14/9/19.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMIncomeCell : UITableViewCell
+ (CGFloat)getCellHeight:(NSDictionary*)dic;//有数据需要修改为收益实体
- (void)setCellDataSource:(NSDictionary*)dic;
@end
