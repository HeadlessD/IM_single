//
//  NIMGroupCreateVC.h
//  QianbaoIM
//
//  Created by liunian on 14/8/23.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"

typedef NS_ENUM(NSInteger, GroupCreateType) {
    GroupCreateTypeDo       = 0,
    GroupCreateTypeForward  = 1,
};

@class NIMGroupCreateVC, GroupList;
@protocol GroupCreateViewControllerDelegate <NSObject>

@optional
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didCreatedGroup:(GroupList *)groupEntity;
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didSelectedThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock;
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didBackWithCompleteBlock:(VcardCompleteBlock)completeBlock;

- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didSelectRow:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock;


@end
@interface NIMGroupCreateVC : NIMViewController
@property (nonatomic, weak) id<GroupCreateViewControllerDelegate>delegate;
@property (nonatomic, assign) int64_t friendUserId;
@property (nonatomic, assign) GroupCreateType   groupCreateType;
@property (nonatomic, assign) BOOL  showSelected;
@end
