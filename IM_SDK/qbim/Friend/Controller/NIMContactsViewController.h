//
//  NIMContactsViewController.h
//  QianbaoIM
//
//  Created by Yun on 14/8/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMTableViewController.h"
@interface NIMContactsViewController : NIMTableViewController
- (void)fetchFriends;
- (IBAction)showCoverView:(id)sender;
- (void)reloadFetchedResults:(NSNotification*)note;
@end
