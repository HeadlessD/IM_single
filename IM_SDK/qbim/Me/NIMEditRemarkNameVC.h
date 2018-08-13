//
//  NIMEditRemarkNameVC.h
//  QianbaoIM
//
//  Created by Yun on 14/10/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"

@interface NIMEditRemarkNameVC : NIMViewController
@property (nonatomic, assign) int64 userId;
@property (nonatomic, copy) NSString* remarkName;
@property (nonatomic,copy) void(^backRefesh)();

@end
