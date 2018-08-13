//
//  NIMLatestVcardViewController.h
//  QianbaoIM
//
//  Created by liunian on 14/9/20.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"

@protocol VcardForwardDelegate;
@interface NIMLatestVcardViewController : NIMTableViewController
@property (nonatomic, weak) id<VcardForwardDelegate>delegate;
@property (nonatomic, strong) id objectForward;
@property (nonatomic, assign) BOOL isShare;

@end

@protocol VcardForwardDelegate <NSObject>
- (void)latestVcardViewController:(NIMLatestVcardViewController *)viewController didSendThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock;

@end
