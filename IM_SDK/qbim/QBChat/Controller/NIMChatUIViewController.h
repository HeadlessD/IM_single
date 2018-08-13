//
//  NIMChatUIViewController.h
//  QianbaoIM
//
//  Created by qianwang on 14/11/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"
#import "NIMADview.h"
@interface NIMChatUIViewController : NIMViewController<NIMADviewDelegate>
@property (nonatomic, strong) NSString * titleString;
@property (nonatomic, strong) NIMADview * adview;
@property (nonatomic, strong) NSString *thread;
@property (nonatomic)BOOL  isBuyer;

@property (nonatomic, strong) void(^backReadClean)();

//是否从商品界面进入
@property (nonatomic)BOOL  isGoods;
//是否从订单界面进入
@property (nonatomic)BOOL  isOrder;
@property (nonatomic, strong) id content;

/**
 *  真实的thread,是从threadVc界面传进来的
 */
@property (nonatomic, strong) NSString *actualThread;
-(void)removeObserver;
@end
