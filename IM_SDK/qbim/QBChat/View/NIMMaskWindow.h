//
//  NIMMaskWindow.h
//  QianbaoIM
//
//  Created by fengsh on 16/6/15.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//
/**
 *  蒙板层
 *  可用来，做第一次引导提示层，也或以用来改造为alterview这只是一个蒙板层，上面要显示的view按自己喜欢的addsubview
 *  即可，已处理键盘弹起时的view变化。但对view中的子view未作调整
 *
 */

#import <Foundation/Foundation.h>

@interface NIMMaskWindow : UIView
///YES时点击蒙版其它地方时消失,默认为NO
@property (nonatomic,assign) BOOL                   touchDismiss;
// 显示
- (void)show;
- (void)showAfterDelayDismiss:(NSTimeInterval)timeinterval;
// 消失
- (void)dismiss;

@end
