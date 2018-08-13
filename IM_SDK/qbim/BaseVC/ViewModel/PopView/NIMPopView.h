//
//  NIMPopView.h
//  QianbaoIM
//
//  Created by liyan on 9/23/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIMPopBaseContextView;
@protocol NIMPopViewDelegate <NSObject>

@optional
- (void)popViewDidCloseEnd;
- (void)popViewDidShowEnd;

@end

@interface NIMPopView : UIView

@property(nonatomic, weak)id<NIMPopViewDelegate> delegate;

+ (instancetype)popView;

- (void)qb_show:(NIMPopBaseContextView *)contextView toUIViewController:(UIViewController *)viewController title:(NSString *)title
;

- (void)qb_showUIView:(UIView *)view toUIViewController:(UIViewController *)viewController title:(NSString *)title;

- (void)qb_showUIView:(UIView *)view toUIViewController:(UIViewController *)viewController titleView:(UIView *)titleView;


- (void)qb_hide;

- (void)moveUpInset:(float)upInset;

@end
