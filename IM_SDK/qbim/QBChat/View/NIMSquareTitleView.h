//
//  NIMSquareTitleView.h
//  QianbaoIM
//
//  Created by Yun on 14/9/9.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SquareTitleDeleagate <NSObject>
@optional
- (void)headerTitleClick:(BOOL)isShow;

@end
@interface NIMSquareTitleView : UIView
@property (nonatomic, copy) NSString* barTitle;
@property (nonatomic, strong) UILabel* labTitle;
@property (nonatomic, strong) UIImageView* barImage;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, assign) id<SquareTitleDeleagate>delegate;
- (void)setCurrentShowStatus:(BOOL)isShow;
- (void)setBarTitle:(NSString *)barTitle font:(UIFont *)font;

@end
