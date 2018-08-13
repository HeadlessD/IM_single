//
//  NIMPullDownView.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/15.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMPullDownView : UIView
//根据外界传的数组动态的实例化视图
- (id)initWithContents:(NSArray *)contentsArr andRect:(CGRect)rect;

//显示
- (void)showInView:(UIView *)view;

//隐藏
- (void)cancle;

//按钮回传事件
@property (nonatomic, copy) void (^eventTouchSelf)(UIButton *btn);
@property (nonatomic, copy) void (^eventTouchCloseBtn)(UIButton *btn);

@end
