//
//  NIMGroupVcardVC.h
//  QianbaoIM
//
//  Created by qianwang on 14/12/3.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"
typedef void (^QBReturnBlock)();

@interface NIMGroupVcardVC : NIMViewController
@property (nonatomic, assign) int64_t groupid;
@property (nonatomic, assign) int64_t inviteid;
@property (nonatomic, copy) QBReturnBlock returnBlock;
@end
