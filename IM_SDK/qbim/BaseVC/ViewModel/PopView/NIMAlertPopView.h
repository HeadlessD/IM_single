//
//  NIMAlertPopView.h
//  QianbaoIM
//
//  Created by liyan on 11/5/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NIMAlertPopView;

@protocol NIMAlertPopViewDelegate<NSObject>

- (void)alertPopViewFinish:(NIMAlertPopView *)alert;
- (void)alertPopViewBack:(NIMAlertPopView *)alert;
@end

@interface NIMAlertPopView : UIView

@property (nonatomic, weak)id <NIMAlertPopViewDelegate>      delegate;
@property (nonatomic, strong)id                             info;
@property (nonatomic, assign)BOOL                           isNeedBack;

_PROPERTY_NONATOMIC_RETAIN(UIImageView, viewBG);

- (void)qb_ShowTitle:(NSString *)title okTitle:(NSString *)okTitle toUIViewController:(UIViewController *)viewController;

- (void)qb_ShowTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle  toUIViewController:(UIViewController *)viewController;


- (void)qb_hide;


@end
