//
//  NIMReportDetailViewController.h
//  QianbaoIM
//
//  Created by Yun on 14/10/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"

@interface NIMReportDetailViewController : NIMViewController
@property (nonatomic, assign) NSString* uuid;
//@property (nonatomic, assign) IMReportType type;
@property (nonatomic) BOOL isGoods;
@property (nonatomic) BOOL isIMChat;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userId;
@end
