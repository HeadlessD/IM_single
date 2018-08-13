//
//  NIMGroupVC.h
//  QianbaoIM
//
//  Created by liunian on 14/8/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "GroupList+CoreDataClass.h"
#import "NIMViewController.h"
@protocol GroupViewControllerDelegate;
@interface NIMGroupVC : NIMTableViewController
@property (nonatomic, assign) id<GroupViewControllerDelegate>delegate;
@property (nonatomic, assign) BOOL fromCreateGroup;

- (void)reloadDataFromDB;
@end

@protocol GroupViewControllerDelegate <NSObject>

@optional
- (void)groupViewController:(NIMGroupVC *)controller didSelectedWithGroupEntity:(GroupList *)groupEntity completeBlock:(VcardCompleteBlock)completeBlock;
- (void)groupViewController:(NIMGroupVC *)viewController didSelectRow:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock;

@end
