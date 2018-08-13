//
//  NIMPublicSearchingCell.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/7/10.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMPublicSearchingCell : UITableViewCell
@property(nonatomic,strong)UIImageView *m_imageView;
@property(nonatomic,strong)UILabel     *titleLable;
@property(nonatomic)NSInteger         type;
- (void)setCellDataSource:(NSString*)searching type:(NSInteger)type;
@end
