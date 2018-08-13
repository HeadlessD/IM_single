//
//  NIMBaseInputPad.h
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-15.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMInputPadDelegate.h"
#import "NIMInputPadHeader.h"

@interface NIMBaseInputPad : UIView
{
    __unsafe_unretained id<NIMInputPadDelegate>        _delegate;
    NIMInputPadMode              _inputPadMode;
}
@property (nonatomic, assign)NIMInputPadMode          inputPadMode;
@property (nonatomic, assign)id<NIMInputPadDelegate>    delegate;

/**根据键盘事件  改变位置 **/


+ (void)keyboardWillShowHide:(NSNotification *)notification up:(BOOL)up superView:(UIView *)superView inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView;
+ (void)keyboardWillShowHide:(NSNotification *)notification up:(BOOL)up superView:(UIView *)superView inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView row:(int)row withBar:(BOOL)isBar;

+ (void)inputHeightChange:(int)change inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView;
+ (void)inputHeightChange:(int)change inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView row:(int)row withBar:(BOOL)isBar;


+ (void)_changeTableHeight:(BOOL)up change:(int) height animation:(BOOL)animation superView:(UIView *)superView inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView ;

+ (void)_changeTableHeight:(BOOL)up change:(int) height animation:(BOOL)animation superView:(UIView *)superView inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView row:(int)row withBar:(BOOL)isBar;


+ (void)scrollToBottomAnimated:(BOOL)animated tableView:(UITableView*)tableView;
+ (void)scrollToBottomAnimated:(BOOL)animated tableView:(UITableView*)tableView row:(int)row withBar:(BOOL)isBar;


+ (void)viewDidAppearWithObserver:(id)observer selectorShowKeyboard:(SEL)selectorShowKeyboard selectorHideKeyboard:(SEL)selectorHideKeyboard;
+ (void)viewWillDisappearWithObserver:(id)observer;


@end
