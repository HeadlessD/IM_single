//
//  NIMPChatTableViewController.h
//  QianbaoIM
//
//  Created by liunian on 14/9/17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NIMPChatTableViewControllerDelegate <NSObject>

-(void)reloadTableIfClearDataSource;
@end

@interface NIMPChatTableViewController : NIMTableViewController
@property (nonatomic, assign) int64_t userid;
@property (nonatomic,strong) NSString *msgBodyID;
@property (nonatomic,strong) NSString *acMsgBodyID;

@property (nonatomic, weak) id<NIMPChatTableViewControllerDelegate> delegate;
@end
