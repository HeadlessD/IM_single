//
//  NIMLoginManager.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/15.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMLoginManager : NSObject
SingletonInterface(NIMLoginManager);

@property (nonatomic, copy) void (^selectBlock)(NSString *userName);
@property (nonatomic, copy) void (^clearBlock)();

- (void)showAccountsRect:(CGRect)rect;

- (void)updateAccount:(NSString *)userName;
- (NSString *)getLastAccount;
@end
