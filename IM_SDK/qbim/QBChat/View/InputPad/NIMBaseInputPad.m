//
//  NIMBaseInputPad.m
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-15.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMBaseInputPad.h"
//#import "UIView+AnimationOptionsForCurve.h"
//#import "UIView+JSQMessages.h"

@implementation NIMBaseInputPad

@synthesize delegate        = _delegate;
@synthesize inputPadMode    = _inputPadMode;


+ (void)keyboardWillShowHide:(NSNotification *)notification up:(BOOL)up superView:(UIView *)superView inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView
{
    [NIMBaseInputPad keyboardWillShowHide:notification up:up superView:superView inputView:inputView tableView:tableView row:-1 withBar:NO];
}

+ (void)keyboardWillShowHide:(NSNotification *)notification up:(BOOL)up superView:(UIView *)superView inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView row:(int)row withBar:(BOOL)isBar
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGFloat keyboardY = [superView convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = inputView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = superView.frame.size.height - inputViewFrame.size.height;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         if(!up)
                         {
                             inputViewFrameY = messageViewFrameBottom;
                             
                             if(row != -1 )
                             {
                                 inputViewFrameY = 568;
                             }
                         }
                         
      
                         inputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                          inputViewFrameY,
                                                          inputViewFrame.size.width,
                                                          inputViewFrame.size.height);
                         
                         
                     }
                     completion:^(BOOL finished) {
                     }];
    
    [NIMBaseInputPad _changeTableHeight:YES change:inputView.frame.size.height + keyboardRect.size.height animation:NO superView:superView inputView:inputView tableView:tableView row:row withBar:isBar];
}

+ (void)inputHeightChange:(int)change inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView
{
    [NIMBaseInputPad inputHeightChange:change inputView:inputView tableView:tableView row:-1 withBar:NO];
}

+ (void)inputHeightChange:(int)change inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView row:(int)row withBar:(BOOL)isBar
{
    CGRect frameTable = tableView.frame;
    
    frameTable.size.height -= change;
    
    tableView.frame = frameTable;
    
    
    [NIMBaseInputPad scrollToBottomAnimated:YES tableView:tableView row:row withBar:isBar];

}

+ (void)_changeTableHeight:(BOOL)up change:(int) height animation:(BOOL)animation superView:(UIView *)superView inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView
{
    [NIMBaseInputPad _changeTableHeight:up change:height animation:animation superView:superView inputView:inputView tableView:tableView  row:-1 withBar:NO];
}

+ (void)_changeTableHeight:(BOOL)up change:(int) height animation:(BOOL)animation superView:(UIView *)superView inputView:(NIMBaseInputPad *)inputView tableView:(UITableView*)tableView  row:(int)row withBar:(BOOL)isBar
{
    CGRect frame = tableView.frame;
    if(row == -2)
    {
        frame.size.height = superView.frame.size.height - (isBar?49:0);
    }
    else  if(row == -1)
    {
         frame.size.height = superView.frame.size.height - height - (isBar?49:0);
    }
    else
    {
        frame.size.height = superView.frame.size.height - height;
    }
   
    tableView.frame = frame;
    
    
    [NIMBaseInputPad scrollToBottomAnimated:animation tableView:tableView row:row withBar:isBar];
}

+ (void)scrollToBottomAnimated:(BOOL)animated tableView:(UITableView*)tableView
{
    [self scrollToBottomAnimated:animated tableView:tableView row:-1 withBar:NO];
}

+ (void)scrollToBottomAnimated:(BOOL)animated tableView:(UITableView*)tableView row:(int)row withBar:(BOOL)isBar
{
	if(row == -1)
    {
        //当-1 跳转到最下面
        NSInteger rows = [tableView numberOfRowsInSection:0];
        
        if (rows > 0)
        {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                             atScrollPosition:UITableViewScrollPositionBottom
                                     animated:animated];
        }
    }
    else if(row == -2)
    {
        //当为-2时什么都不干
    }
    else
    {
        if (row >= 0)
        {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                             atScrollPosition:UITableViewScrollPositionBottom
                                     animated:animated];
        }
    }
}

+ (void)viewDidAppearWithObserver:(id)observer selectorShowKeyboard:(SEL)selectorShowKeyboard selectorHideKeyboard:(SEL)selectorHideKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:selectorShowKeyboard
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:selectorHideKeyboard
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

+ (void)viewWillDisappearWithObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:UIKeyboardWillHideNotification object:nil];
}





@end
