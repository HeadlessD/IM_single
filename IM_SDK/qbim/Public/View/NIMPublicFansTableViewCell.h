//
//  NIMPublicFansTableViewCell.h
//  QianbaoIM
//
//  Created by qianwang on 15/6/24.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPublicInfoModel.h"

@interface NIMPublicFansTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic ,strong)UICollectionView *collectionView;
@property(nonatomic ,strong)NSArray *fansArry;

-(void)setDataSource:(NIMPublicInfoModel *)model;
@end
