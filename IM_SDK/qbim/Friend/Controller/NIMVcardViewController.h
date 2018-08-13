//
//  NIMVcardViewController.h
//  QianbaoIM
//
//  Created by liunian on 14/8/22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//


typedef NS_ENUM(NSInteger, VcardActionType){
    VcardActionTypeNone      = 0,
    VcardActionTypeSelected  = 1,
    VcardActionTypeForward   = 2,
    VcardActionTypeShare     = 3,
};

@class NIMVcardViewController;
@protocol VcardViewControllerDelegate <NSObject>

@required
- (void)VcardViewController:(NIMVcardViewController *)viewController didSelectedWithCardInfos:(NSArray *)entitys;

@end

@interface NIMVcardViewController : NIMTableViewController
@property (nonatomic, strong) ChatEntity *recordEntity;
@property (nonatomic, assign) VcardActionType vcardType;
@property (nonatomic, weak) id<VcardViewControllerDelegate>delegate;
@end
