//
//  NIMLoginManager.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/15.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMLoginManager.h"
#import "NIMPullDownView.h"
@implementation NIMLoginManager
SingletonImplementation(NIMLoginManager)

- (void)updateAccount:(NSString *)userName
{
    userName = _IM_FormatStr(@"%@",userName);
    NSArray *users = getObjectFromUserDefault(@"users");
    NSMutableArray *userArr = [[NSMutableArray alloc] initWithArray:users];
    if (![userArr containsObject:userName]) {
        if (userArr.count > 5) {
            [userArr removeObjectAtIndex:0];
        }
        [userArr insertObject:userName atIndex:0];
    } else {
        [userArr removeObject:userName];
        [userArr insertObject:userName atIndex:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userArr forKey:@"users"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLastAccount
{
    NSString *name = @"";
    NSArray *users = getObjectFromUserDefault(@"users");
    if (users.count>0) {
        name = [users objectAtIndex:0];
    }
    return name;
}

- (void)showAccountsRect:(CGRect)rect
{
    NSArray *users = getObjectFromUserDefault(@"users");
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:users];
    NIMPullDownView *rightView = [[NIMPullDownView alloc] initWithContents:arr andRect:rect];
    __weak NIMPullDownView *weakSelf = rightView;
    //点击事件
    rightView.eventTouchSelf = ^(UIButton *btn){
        if (self.selectBlock) {
            NSString *userName = _IM_FormatStr(@"%@",users[btn.tag-100]);
            self.selectBlock(userName);
        }
        [weakSelf cancle];
    };
    rightView.eventTouchCloseBtn = ^(UIButton *btn){
        [arr removeObjectAtIndex:btn.tag-200];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"users"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [weakSelf cancle];
        if (arr.count==0) {
            if (self.clearBlock) {
                self.clearBlock();
            }
        }
    };
    [rightView showInView:[[UIApplication sharedApplication].delegate window]];
}
@end
