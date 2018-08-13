//
//  DFModifyViewController.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/2.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMTableViewController.h"


@class DFModifyViewController;
@protocol DFModifyViewControllerDelegate <NSObject>

@optional

- (void)modifyViewController:(DFModifyViewController *)viewController didSelectPriType:(Moments_Priv_Type)type users:(NSArray *)users;

@end

@interface DFModifyViewController : NIMTableViewController
@property (nonatomic, weak) id<DFModifyViewControllerDelegate>delegate;
@property(nonatomic,assign)NSInteger index;
@end
