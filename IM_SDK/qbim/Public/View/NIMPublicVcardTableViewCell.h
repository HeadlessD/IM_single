//
//  NIMPublicVcardTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPublicVcardReuseIdentifier @"NIMPublicVcardTableViewCell"
@interface NIMPublicVcardTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end
