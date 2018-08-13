//
//  UIViewController+NIMPushVC.h
//  QianbaoIM
//
//  Created by tiezhang on 14-9-17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SecurityVerificationViewController.h"
@class QBMyTaskInfoModel;
@class QBFoundCellModel;
@class HandPassViewController;

// add by shiji

typedef void (^finishBlock) (void);


@interface UIViewController (NIMPushVC)

- (void)nim_pushToVC:(UIViewController*)vc animal:(BOOL)animal;

- (void)nim_showScanCodeView;






@end


