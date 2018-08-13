//
//  NIMLoginHistoryCell.h
//  QianbaoIM
//
//  Created by xuqing on 16/3/3.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMAccountsInfo.h"
@protocol NIMLoginHistoryCellDelegate<NSObject>
@optional
-(void)deleteLocalAccounts:(NSMutableArray*)array;
-(void)selectAccount:(NIMAccountsInfo *)model;
@end


@interface NIMLoginHistoryCell : UICollectionViewCell
@property(nonatomic,strong)NSMutableArray *acountArray;
@property(nonatomic,weak)id<NIMLoginHistoryCellDelegate>delegate;
-(void)setAutoLayOut:(NSArray*)array;

@end
